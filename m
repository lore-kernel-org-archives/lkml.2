Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2A0LjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:39:00 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39533 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159Ab2A0LjA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:39:00 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.166.112]
In-Reply-To: <4F212E9E.9060807@monstr.eu>
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com>
 <4F1FF870.3000105@monstr.eu> <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com>
 <4F200F64.9060203@monstr.eu> <CAK=WgbZDADRf1OF=uWbbsF+t2dx36tqj=kRftn5nd4RA7DtEnA@mail.gmail.com>
 <4F212E9E.9060807@monstr.eu>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 27 Jan 2012 13:38:39 +0200
Message-ID: <CAK=WgbYMBDp3Qm8TErNrnDwn2ZTFt62+OuyyQvVE-jrnNsL6kg@mail.gmail.com>
Subject: Re: remoteproc: Load coprocessor code to the specific main memory location
To: monstr@monstr.eu
Cc: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 12:44 PM, Michal Simek <monstr@monstr.eu> wrote:
> I have one small problem which is that physical address is 0x10000000
> which means that firmware entry point is the same.

This is what we do with the davinci DSPs, too.

> In rproc_load_segments is da composed from phdr->p_paddr which is
> 0x10000000.

Ok, I don't see any issue here.

> And code is designed that this load addr is offset.

Not sure exactly what do you mean by that ?

> Here is the code:
>        /* go through the available ELF segments */
>        for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
>                u32 da = phdr->p_paddr; // OFFSET 0x10000000
>                u32 memsz = phdr->p_memsz;
>
> But for my case is physical address correct and it is not offset 0x10000000.

Again, I'm not sure what exactly is the issue. p_paddr is the physical
address where the image is expected, that sounds ok to me.

Thanks,
Ohad.
