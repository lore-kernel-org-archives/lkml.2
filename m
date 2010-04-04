Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0DDCIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 22:08:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40832 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063Ab0DDCIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 22:08:25 -0400
X-Sasl-enc: ywjH8Ir2MnIXJjLGmqrYYmgPp1EhF74/pPzcWpbXMVFd 1270346904
Date: Sat, 3 Apr 2010 23:08:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Pilarski <Thomas.Pilarski@arcor.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug 12309] Large I/O operations result in slow performance
 and high iowait times
Message-ID: <20100404020821.GC17218@khazad-dum.debian.net>
References: <bug-12309-14043@http.bugzilla.kernel.org/>
 <201003162357.o2GNvkNF024562@demeter.kernel.org>
 <1269935094.2481.23.camel@localhost>
 <20100331002549.GB9925@khazad-dum.debian.net>
 <1270322388.26420.56.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270322388.26420.56.camel@localhost>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Apr 2010, Thomas Pilarski wrote:
> > > This problem is enormous increased, while the ultra bay disc is acceded
> > > with udma2 instead of udma6 (caused by another bug), 
> > 
> > There is a thinkpad BIOS bug that could cause that: it will not signal a
> > 80-wire cable when you hot-add an HD on a PATA ultrabay.  Exists at least on
> > all T4x, including the T43.
> 
> It's a SATA untrabay disk. There is a 40-wire message, but sometimes it
> works and sometimes not. I could not figure out, when it does and when
> not. 

Which ThinkPad model?  And yes, if it is the BIOS 40-wire problem, it
doesn't show up always.  I keep forgetting exactly how to trigger it (I
think it is hotplug device when you boot with the bay empty), but it is
100% reproducible.

> > The fix is to whitelist these thinkpads for high-speed UDMA even on 40-wire
> > cables.  The workaround is to add a kernel command line parameter (I forget
> > which).
> > 
> > Does that match your udma2 instead of udma6 problem?
> 
> Thanks. I will try it. But have to finish another project first. 

Just make sure to tell me if the ata 40-wire short cable override fixes
your problem when you get around to trying it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
