Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab1GWUff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 16:35:35 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52793 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab1GWUfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 16:35:30 -0400
MIME-Version: 1.0
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E9403026FE695@dbde02.ent.ti.com>
References: <1310310203-12288-1-git-send-email-sundaram@ti.com>
	<CABb+yY1HJOR+QzmM4-ju4cs+8keoyUbMv+SpVoM6BW=DCMzmQQ@mail.gmail.com>
	<CACRpkdbLg0+_2kpi4NizFj0fDWb6QPtkcKirKgoH+83vGD0O0A@mail.gmail.com>
	<CABb+yY1RqHJ6jsMB2RqPNnBLff-bzhwaXG1U-hCD8CpME+a3aA@mail.gmail.com>
	<E0D41E29EB0DAC4E9F3FF173962E9E94030259DBBE@dbde02.ent.ti.com>
	<CABb+yY1_vuM7NGxV4o103YmYfte09XKpaXnYARcn3jjnChiBsQ@mail.gmail.com>
	<E0D41E29EB0DAC4E9F3FF173962E9E9403026FE695@dbde02.ent.ti.com>
Date: Sun, 24 Jul 2011 02:05:28 +0530
Message-ID: <CABb+yY2=CrA8=9ces=4ABjxrHieXjtJTGm6Q3Kg30eHye9_N2g@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride configuration
From: Jassi Brar <jassisinghbrar@gmail.com>
To: "Raju, Sundaram" <sundaram@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 1:21 PM, Raju, Sundaram <sundaram@ti.com> wrote:
>>
>> Maybe a new api to pass fixed-format variable-length encoded message
>> to the DMAC drivers?
>> Which could be interpreted by DMAC drivers to extract all the needed xfer
>> parameters from the 'header' section and instructions to program the xfers
>> in the DMAC from the variable length body of the 'message' buffer.
>> It might sound complicated but we can have helpers to make the job easy.
>> Btw, the regular single/sg-list xfers could also be expressed by this method.
>
> Do you expect this variable length body of the message to be DMAC
> independent? I don't think so. In that case how is this different from what
> we have here already?
Yes, this whould be DMAC independent.

> If it can be DMAC independent, can you illustrate more on how this can
> be done? But the point to note is, if this can be made DMAC independent
> then the control command we have also can be made DMAC independent
> by generalizing the configuration structure passed to it.
The 'header' I suggest, would in fact be a structure body, only an extra pointer
would point to the 'instructions' to convey actual location and sizes
of mico-xfers.
I don't think it is possible to have general definition of such transfers fully
within a structure. If I understand what you ask.

I have just posted an RFC. I kept the terms same so that it is easier
to understand.
Please have a look. You are CC'ed too.

Thanks,
Jassi
