Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1BDV7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:59:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:59099 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab1BDV7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:59:43 -0500
Subject: Re: Sun GEM PPC32 Bug?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Matt <jackdachef@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "R. Herbst" <ruediger.herbst@googlemail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <AANLkTimBFBKJf0-TNRLr2hHNEehR2cnKPvx06=yyHGVj@mail.gmail.com>
References: <AANLkTimBFBKJf0-TNRLr2hHNEehR2cnKPvx06=yyHGVj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Feb 2011 07:51:07 +1100
Message-ID: <1296852667.2349.804.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 16:55 +0000, Matt wrote:
> Hi guys,
> 
> I myself don't have any PPC32 box but I just googled some of the
> keywords Ruediger posted "gem eth0: RX MAC fifooverflow smac"
> 
> and there were even similar or related messages going back to 2004
> (and kernel 2.6.9).
> 
> Slab corruption seems to be involved (in some ?) cases (e.g.
> http://www.mail-archive.com/netdev@vger.kernel.org/msg08345.html)
> 
> so it sounds serious to me (from an users point of view).
> 
> A kind of temporary fix seems to rmmod and modprobe the kernel-module,
> according to:http://ubuntuforums.org/showthread.php?t=1428330
> 
> 
> For the German speaking folks there's a thread over at
> forums.gentoo.org (http://forums.gentoo.org/viewtopic-t-862767.html)
> 
> and 2 additional English threads which might provide additional info
> on this (and another sound) issue:
> 
> http://forums.gentoo.org/viewtopic-t-862229.html "kernel: eth0: RX MAC
> fifo overflow smac"
> 
> http://forums.gentoo.org/viewtopic-t-862579.html "Soundissue extreme quietly"
> 
> I'm not subscribed to the list so please CC

So the slab corruption doesn't seem to have ever been reported since
2.6.16, do we know if that's still a problem ?

The FIFO overflow could be a driver bug or a HW issue, there are some
known issues with the small FIFOs in that chip, but it's also possible
that we don't configure them quite right. Anybody wants to dig in and
see what's going on there ? May want to look at the Darwin sungem driver
for reference on how it configures them... However, it should generally
recover when that happens. If not, then we have a bug there.

Cheers,
Ben.


