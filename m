Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031377Ab2CFVLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:11:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:59694 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031152Ab2CFVLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:11:34 -0500
Date: Tue, 6 Mar 2012 22:11:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sven Joachim <svenjoac@gmx.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
In-Reply-To: <87r4x5zbe5.fsf@turtle.gmx.de>
Message-ID: <alpine.LFD.2.02.1203062210340.2742@ionos>
References: <20120228010511.GA8453@kroah.com> <20120228010434.412979550@linuxfoundation.org> <87hay4dqjr.fsf@turtle.gmx.de> <201203050143.24541.s.L-H@gmx.de> <CA+55aFxZsVxkxifR+EUZi=RsUGKfs5vYXX3nN_M_Az1BY5yyaw@mail.gmail.com> <alpine.LFD.2.02.1203060927190.2742@ionos>
 <alpine.LFD.2.02.1203060957140.2742@ionos> <alpine.LFD.2.02.1203062019340.2742@ionos> <8762eh1p7d.fsf@turtle.gmx.de> <alpine.LFD.2.02.1203062101040.2742@ionos> <87r4x5zbe5.fsf@turtle.gmx.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Tue, 6 Mar 2012, Sven Joachim wrote:
> Am 06.03.2012 um 21:26 schrieb Thomas Gleixner:
> 
> > On Tue, 6 Mar 2012, Sven Joachim wrote:
> >> Am 06.03.2012 um 20:31 schrieb Thomas Gleixner:
> >> 
> >> > Stephan, Sven: Can you please provide the output of /proc/interrupts ?
> >> 
> >> Here is mine, from a freshly booted 3.3-rc6 kernel.
> >> 
> >> Cheers,
> >>        Sven
> >> 
> >>            CPU0       
> >>   0:      25050    XT-PIC-XT-PIC    timer
> >>   1:        101    XT-PIC-XT-PIC    i8042
> >>   2:          0    XT-PIC-XT-PIC    cascade
> >>   3:          1    XT-PIC-XT-PIC  
> >>   4:          1    XT-PIC-XT-PIC  
> >>   5:          0    XT-PIC-XT-PIC    ehci_hcd:usb1, uhci_hcd:usb2
> >>   6:          1    XT-PIC-XT-PIC    i915, uhci_hcd:usb5, yenta
> >>   7:          1    XT-PIC-XT-PIC  
> >>   8:          0    XT-PIC-XT-PIC    rtc0
> >>   9:        634    XT-PIC-XT-PIC    acpi
> >>  10:        341    XT-PIC-XT-PIC    uhci_hcd:usb4, snd_hda_intel, b43
> >
> > Ah, XT-PIC uses handle_level_irq(). /me bangs head against desk.
> >
> > Does the patch below fix the problem for you ?
> 
> Yep, it does.  Thanks!

Can you pick it up directly or want me to send it via tip ?

Thanks,

	tglx
