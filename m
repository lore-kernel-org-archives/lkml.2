Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab1FNF7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:59:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37244 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1FNF7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=i/i0cIIVpBR1dr97UOpBh+TU1C/V/JeCxQcO04ggwMJ1LKaI+S4ZpApoJNf8IwQck9
         Wh1wZXK8GaonSkUM1RKGqfbfI4yTemQP8hLrPXZL8f4B6iXi+wqhgwg7DVp3MX+RYOwo
         b+CEo/R6HchtkQ5OwsOmqiCA0tg2MIxOBGo7E=
MIME-Version: 1.0
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E9403020B7B37@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
	<20110609124723.GA24636@n2100.arm.linux.org.uk>
	<E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com>
	<20110609163206.GB24636@n2100.arm.linux.org.uk>
	<1307686397.10976.116.camel@vkoul-udesk3>
	<E0D41E29EB0DAC4E9F3FF173962E9E940301FE337F@dbde02.ent.ti.com>
	<20110610104318.GC24636@n2100.arm.linux.org.uk>
	<E0D41E29EB0DAC4E9F3FF173962E9E940301FE3452@dbde02.ent.ti.com>
	<20110610133338.GD24636@n2100.arm.linux.org.uk>
	<BANLkTimZ=v4W1hFJ7hvZRmyHMSU_3MmZEA@mail.gmail.com>
	<E0D41E29EB0DAC4E9F3FF173962E9E9403020B7B37@dbde02.ent.ti.com>
Date: Tue, 14 Jun 2011 07:59:29 +0200
X-Google-Sender-Auth: 9eIbyxe0LqpxRUYGMwttAVV8010
Message-ID: <BANLkTik5KP1Ro4be1g9e-dqUxjsu4F_6=A@mail.gmail.com>
Subject: Re: [RFC] dmaengine: add new api for preparing simple slave transfer
From: Linus Walleij <linus.walleij@linaro.org>
To: "Raju, Sundaram" <sundaram@ti.com>
Cc: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan <dan.j.williams@intel.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/14 Raju, Sundaram <sundaram@ti.com>:

> Yes, the hardware can skip over sequences like that.
> I also thought about your suggestion, at first before submitting the RFC.
> But I dint pursue this because, this ioctl() call has to be made before
> every single prepare call.

It's not an ioctl(), ioctl()s would be expensive since they involve
userspace to kernelspace context switches. It is just "ioctl()-like".
It is a simple, fast function call.

> I may have to end up using this if we decide not to change the API
> signature for prepare APIs.

Is it really so bad? It is a custom configuration after all. Even if
there were many DMACs out there supporting it, we'd probably
model it like this, just pass something like DMA_STRIDE_CONFIG
instead of something named after a specific slave controller.

This way DMACs that didn't support striding could NACK a
transfer for device drivers requesting it and then it could figure
out what to do.

If we can get some indication as to whether more DMACs can
do this kind of stuff, we'd maybe like to introduce
DMA_STRIDE_CONFIG already now.

Thanks,
Linus Walleij
