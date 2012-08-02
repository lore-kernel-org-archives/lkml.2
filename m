Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2HBMFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:05:45 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:48456 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634Ab2HBMFo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:05:44 -0400
From: Virupax SADASHIVPETIMATH <virupax.sadashivpetimath@stericsson.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Praveena NADAHALLY <praveen.nadahally@stericsson.com>
Date: Thu, 2 Aug 2012 14:05:29 +0200
Subject: RE: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
Thread-Topic: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
Thread-Index: Ac1wngFrABAwD6vQRXCjNx/a8EhQlgABgaMg
Message-ID: <A3217089E06965468FCEC60ADC3A8F925C21599AC7@EXDCVYMBSTM006.EQ1STM.local>
References: <1343889402-7826-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
 <20120802110010.GA5443@kroah.com>
In-Reply-To: <20120802110010.GA5443@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, August 02, 2012 4:30 PM
> To: Virupax SADASHIVPETIMATH
> Cc: balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Praveena
> NADAHALLY
> Subject: Re: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
> 
> On Thu, Aug 02, 2012 at 12:06:42PM +0530, Virupax Sadashivpetimath wrote:
> > In case of USB bulk transfer, when himem page
> > is received, the usb_sg_init function sets the
> > urb transfer buffer to NULL. When such URB
> > transfer is handled, kernel crashes in PIO mode.
> > Handle this by mapping the highmem buffer in PIO mode.
> >
> > Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
> 
> Why is this not a problem in any other host controller? 

Problem is seen only when the RAM on the board is 1GB or more. When the urb sg is in highmem. 

Below crash is seen without the patch

[   50.467529] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[   50.475616] pgd = c0004000
[   50.478302] [00000000] *pgd=00000000
[   50.481872] Internal error: Oops: 817 [#1] PREEMPT SMP ARM
[   50.546630] CPU: 0    Tainted: G           O  (3.4.0+ #1)
[   50.552062] PC is at __raw_readsl+0x30/0x100
[   50.556304] LR is at 0x0
[   50.558837] pc : [<c028b500>]    lr : [<00000000>]    psr: 20000193
[   50.558837] sp : c09b5c80  ip : 00000000  fp : c09b5cb4
[   50.570312] r10: db9a46c0  r9 : c0a45538  r8 : 00000000
[   50.575531] r7 : 00000002  r6 : df860028  r5 : 00000200  r4 : 00010101
[   50.582031] r3 : 464c457f  r2 : 00000078  r1 : 00000000  r0 : df860028
[   50.588562] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[   50.595947] Control: 10c5787d  Table: 1bf0c04a  DAC: 00000015

> Are you sure this fix is correct?

I have tested the patch on the board with the issue and it seems to work.

>  Why do you need to modify the struct urb for this?

The URB transfer may take more than 1 interrupt for the complete transfer
to store the state of sg_miter specific to urb, struct urb is used.

Thanks 
Virupax S 



