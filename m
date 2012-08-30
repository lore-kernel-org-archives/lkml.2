Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2H3Lly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:41:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34202 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab2H3Llx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:41:53 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Devendra Naga <develkernel412222@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] lp8727_charger: free_irq when lp8727_register_psy
 fail
Thread-Topic: [PATCH 1/2] lp8727_charger: free_irq when lp8727_register_psy
 fail
Thread-Index: AQHNfkyUtH5d/Bt1GkGZ8dxbM6LPuJdnHKMAgAsuxRA=
Date: Thu, 30 Aug 2012 11:41:47 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1CF2@DQHE02.ent.ti.com>
References: <1343583999-30231-1-git-send-email-develkernel412222@gmail.com>
	<1344573355.2441.0.camel@test-laptop>	<20120819205018.GA1031@lizard>
 <CA+C2MxTwu74macE5+AH8ZOyPW+Ko-9PoUr7PiCoPNX=+=dBMFg@mail.gmail.com>
In-Reply-To: <CA+C2MxTwu74macE5+AH8ZOyPW+Ko-9PoUr7PiCoPNX=+=dBMFg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Best Regards,
Milo


> -----Original Message-----
> From: Devendra Naga [mailto:develkernel412222@gmail.com]
> Sent: Friday, August 24, 2012 1:52 AM
> To: Anton Vorontsov
> Cc: David Woodhouse; linux-kernel@vger.kernel.org; Kim, Milo
> Subject: Re: [PATCH 1/2] lp8727_charger: free_irq when
> lp8727_register_psy fail
> 
> Hi Anton,
> 
> On Mon, Aug 20, 2012 at 2:20 AM, Anton Vorontsov
> <cbouatmailru@gmail.com> wrote:
> > On Fri, Aug 10, 2012 at 10:05:55AM +0530, Devendra wrote:
> >> Sorry Guys on disturbing you,
> >>
> >> Will you guys please ACK, NACK or comment on this?
> >
> > Technically, it looks OK. But the irq registration logic is sill
> broken,
> > and the hidden issue is much more serious.
> >
> > 1. lp8727_init_device() -> the function enables interrupts in hw;
> > 2. lp8727_intr_config() -> the function requests interrupts, so CPU
> >    is now able to process them;
> > 3. lp8727_register_psy() -> the function allocates power supply
> >    objects.
> >
> > Now, the problem will arise if interrupt comes between "2." and
> > "3.", the interrupt service routine will cause NULL dereference.
> >
> > So, what you really want to fix the driver is to reorder "2." and
> "3.",
> > and on error condition call lp8727_unregister_psy().

Please refer to the patch below.
[PATCH 2/8] lp8727_charger: cleanup _probe() and _remove()

Best Regards,
Milo
