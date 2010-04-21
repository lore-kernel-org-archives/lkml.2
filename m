Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0DUUOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:14:06 -0400
Received: from exhub016-4.exch016.msoutlookonline.net ([207.5.72.225]:22765
	"EHLO EXHUB016-4.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226Ab0DUUOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:14:04 -0400
Message-ID: <4BCF5C87.8060509@cfl.rr.com>
Date: Wed, 21 Apr 2010 16:13:59 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Evgeniy Polyakov <zbr@ioremap.net>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <20100421183853.GA14897@ioremap.net> <20100421185124.GM27575@shareable.org> <4BCF509E.2040903@cfl.rr.com> <20100421200104.GT27575@shareable.org>
In-Reply-To: <20100421200104.GT27575@shareable.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/2010 4:01 PM, Jamie Lokier wrote:
> Ok, this discussion has got a bit confused.  Text above refers to
> needing to asynchronously read next block in a directory, but if they
> are small then that's not important.

It is very much important since if you ready each small directory one
block at a time, it is very slow.  You want to queue up reads to all of
them at once so they can be batched.

> FIEMAP suggestion is only if you think you need to issue reads for
> multiple blocks in the _same_ directory in parallel.  From what you say,
> I doubt that's important.

That may be why you suggested it, but it is also exactly what
readahead() does.  It also queues the read asynchronously which is what
I really want so that I can queue more reads on other directories in one
big batch.

> That was my first suggestion: threads with readdir(); I thought it had
> been rejected hence the further discussion.

Yes, it was sort of rejected, which is why I said it's just a workaround
for now until readahead() works on directories.  It will produce the
desired IO pattern but at the expense of ram and cpu cycles creating a
bunch of short lived threads that go to sleep almost immediately after
being created, and exit when they wake up.  readahead() would be much
more efficient.

