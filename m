Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0IVSWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:22:50 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:13502 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0IVSWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:22:49 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Early console confusion
Date: Wed, 22 Sep 2010 12:21:59 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, yinghai@kernel.org,
        just.for.lkml@googlemail.com, tglx@linutronix.de, hpa@linux.intel.com,
        Feng Tang <feng.tang@intel.com>, Alan Cox <alan@linux.intel.com>,
        greg@kroah.com
References: <4C7B0578.8090807@kernel.org> <201009221044.58735.bjorn.helgaas@hp.com> <4C9A3487.6080005@zytor.com>
In-Reply-To: <4C9A3487.6080005@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221222.00475.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 22, 2010 10:53:27 am H. Peter Anvin wrote:
> On 09/22/2010 09:44 AM, Bjorn Helgaas wrote:
> >
> > If we don't like "uart8250,io,0x3f8" (which I agree is awfully clunky),
> > we could easily add something like "console=com1" which encapsulated
> > the well-defined PC concept.
> 
> console=ttyS0 ... already works fine.

Yes, but it doesn't give you early output.  You have to wait until the
8250 driver loads and figures out which device will be ttyS0.

If we use "console=tty0" or "console=ttyS0", those are device names
that don't work until the driver is loaded.  But if we specify the
device explicitly, via "uart8250", "com1", "hsu", "vga", etc., we
can make the console work early using a minimal driver, then switch
to the regular driver later.

The question is whether that would be good enough to let us remove
the "earlycon=" and "earlyprintk=" stuff.

> But yes, it's ugly and we have bass-ackwards compatibility problem...

I think earlycon and earlyprintk have minimal backwards compatibility
problems, since they're mostly for developers.  And if we decided
we did need to keep them, they could be undocumented and implemented
on top of "console=" with the appropriate explicit device.

I guess this is all just hot air since I don't have time to actually
produce any patches :-(

Bjorn
