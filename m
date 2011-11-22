Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab1KVKR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:17:56 -0500
Received: from mail.klingt.org ([86.59.21.178]:45496 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab1KVKRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:17:54 -0500
From: Tim Blechmann <tim@klingt.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [alsa-devel] [bisected] lx6464es fails to open a second time
Date: Tue, 22 Nov 2011 11:17:45 +0100
Message-ID: <12713926.WkIoyVagpM@moka>
User-Agent: KMail/4.7.3 (Linux/3.1.1+; KDE/4.7.3; x86_64; ; )
In-Reply-To: <4ECB5257.4040600@ladisch.de>
References: <2428359.JOQWRg64O4@moka> <4ECB5257.4040600@ladisch.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (klingt.org [86.59.21.178]); Tue, 22 Nov 2011 11:17:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > today, i was able to bisect the issue and the first bad commit is:
> > 
> > commit 6175ddf06b6172046a329e3abfd9c901a43efd2e
> > Author: Brian Gerst <brgerst@gmail.com>
> > Date:   Fri Feb 5 09:37:07 2010 -0500
> > 
> >     x86: Clean up mem*io functions.
> > 
> > the communication with the device is done by passing simple commands via
> > memcpy_fromio and memcpy_toio (compare sound/pci/lx6464es/lx_core.c,
> > lines 75 to 99). any idea, what is going wrong there?
> 
> The old and new implementations of memcpy_*io do not have any differences
> in the documented API, but the new ones are much more optimized, so they
> might not use 8- or 32-bit accesses or a different access pattern.
> 
> Does the card's mapped I/O region behave exactly like memory, or has it
> any restrictions on how it can be used?  In the latter case, you should
> implement your readbuf/writebuf functions by hand to use plain 32-bit
> accesses in order (or whatever is required).

indeed, emulating memcpy_*io with ioread32/iowrite32 fixes the issue.

thanks, tim
