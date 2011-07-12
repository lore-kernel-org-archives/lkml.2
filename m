Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1GLKQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:16:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34961 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1GLKQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:16:06 -0400
From: "Raju, Sundaram" <sundaram@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 12 Jul 2011 15:45:47 +0530
Subject: RE: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride
 configuration
Thread-Topic: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride
 configuration
Thread-Index: AcxAejOuAcnAAO+QSky2G2ZcMR7bHgAAER0A
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E94030259DAFE@dbde02.ent.ti.com>
References: <1310310203-12288-1-git-send-email-sundaram@ti.com>
	<CAKnu2MqzSm8BVK4z9E-ud8e_jUohDfSfYO9aW-oN3RFw4p7GrA@mail.gmail.com>
	<CAA9_cmeWUjiTghKbjAvith5c6z9PDVdFSeK55RYWfyQKFSjA+Q@mail.gmail.com>
 <CACRpkdbj-xucUN+jxMsBnfXfcmy3ohuhd=66x_AqcCykMsNwPQ@mail.gmail.com>
In-Reply-To: <CACRpkdbj-xucUN+jxMsBnfXfcmy3ohuhd=66x_AqcCykMsNwPQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: Tuesday, July 12, 2011 3:28 PM
> To: Dan Williams
> Cc: Raju, Sundaram; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; davinci-linux-open-source@linux.davincidsp.com;
> linux@arm.linux.org.uk; linux-omap@vger.kernel.org
> Subject: Re: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride
> configuration
> 
> On Mon, Jul 11, 2011 at 11:39 PM, Dan Williams <dan.j.williams@intel.com>
> wrote:
> > On Mon, Jul 11, 2011 at 2:28 AM, Linus Walleij <linus.walleij@linaro.org>
> wrote:
> 
> > ...and I suspect the slave device drivers that use TI DMA are not
> > expected to ever work with other dmaengines?  Likely the case, but
> > just wondering out loud.
> 
> Typically the OMAP/TI drivers are one-to-one with this specific DMA
> controller, but they *can* support controllers without stride options, and
> notice that striding will only be used for the display driver IIRC,
> pseudo-code:
> 
> ret = dmaengine_device_control(chan, TI_DMA_STRIDE_CONFIG,
>                         (unsigned long) &my_stride_config);
> if (ret) {
>    /*
>     * OK no striding on this DMA engine, fall back to something else,
>     * such as creating an SGlist which emulates the striding with one
>     * sglist element per stride.
>     */
> }
> 
> By injecting an error in the stride config path this can even be
> properly tested. So it will become an optional acceleration.

Yes, this is exactly what I also wanted to say. :)

But if the client driver does not implement a fallback like this then that
driver will work only with TI DMA and not any other dmaengines.
(Mentioning this because, there are client drivers which are tightly 
coupled to this special configuration)

Keeping this in mind, I had started the original discussion with
the suggestion of modifying the existing prepare API and adding
an extra argument to it, which can be used to pass special configuration.
And I also wanted to generalize that configuration passed.

Anyways that design also will come down to this same path, and instead
of modifying the existing API signatures, I think this is the best way
we can go.

Regards,
Sundaram
