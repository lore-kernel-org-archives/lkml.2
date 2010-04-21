Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0DUAoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:44:37 -0400
Received: from mail2.shareable.org ([80.68.89.115]:46198 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab0DUAog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:44:36 -0400
Date: Wed, 21 Apr 2010 01:44:34 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100421004434.GA27420@shareable.org>
References: <4BCC7C05.8000803@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCC7C05.8000803@cfl.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> I have been trying to improve boot times with ureadahead and have
> identified a period of time of almost zero IO throughput caused by calls
> to open() blocking during name lookup while fetching directory blocks.
> At first I thought this could simply be fixed by calling readahead() on
> the directories first before open()ing all of the normal files for
> readahead.
> 
> Unfortunately it seems that readahead() fails when called on a
> directory.  I was wondering if I could get some help understanding why
> this is, and how it could be fixed.

readahead() doesn't make much sense on a directory - the offset and
size aren't meaningful.

But does plain opendir/readdir/closedir solve the problem?

-- Jamie
