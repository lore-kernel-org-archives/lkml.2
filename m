Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0DUO5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:57:10 -0400
Received: from exhub016-2.exch016.msoutlookonline.net ([207.5.72.164]:11540
	"EHLO EXHUB016-2.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755339Ab0DUO5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:57:08 -0400
Message-ID: <4BCF123C.6010400@cfl.rr.com>
Date: Wed, 21 Apr 2010 10:57:00 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org>
In-Reply-To: <20100421004434.GA27420@shareable.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/2010 8:44 PM, Jamie Lokier wrote:
> readahead() doesn't make much sense on a directory - the offset and
> size aren't meaningful.
> 
> But does plain opendir/readdir/closedir solve the problem?

No, since those are synchronous.  I want to have readahead() queue up
reading the entire directory in the background to avoid blocking, and
get the queue filled with a bunch of requests that can be merged into
larger segments before being dispatched to the hardware.

I don't actually care to have the contents of the directories returned,
so readdir() does more than I need in that respect, and also it performs
a blocking read of one disk block at a time, which is horribly slow with
a cold cache.
