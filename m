Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1GLJ6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:58:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34293 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab1GLJ6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:58:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAA9_cmeWUjiTghKbjAvith5c6z9PDVdFSeK55RYWfyQKFSjA+Q@mail.gmail.com>
References: <1310310203-12288-1-git-send-email-sundaram@ti.com>
	<CAKnu2MqzSm8BVK4z9E-ud8e_jUohDfSfYO9aW-oN3RFw4p7GrA@mail.gmail.com>
	<CAA9_cmeWUjiTghKbjAvith5c6z9PDVdFSeK55RYWfyQKFSjA+Q@mail.gmail.com>
Date: Tue, 12 Jul 2011 11:58:04 +0200
Message-ID: <CACRpkdbj-xucUN+jxMsBnfXfcmy3ohuhd=66x_AqcCykMsNwPQ@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sundaram Raju <sundaram@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:39 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Jul 11, 2011 at 2:28 AM, Linus Walleij <linus.walleij@linaro.org> wrote:

> ...and I suspect the slave device drivers that use TI DMA are not
> expected to ever work with other dmaengines?  Likely the case, but
> just wondering out loud.

Typically the OMAP/TI drivers are one-to-one with this specific DMA
controller, but they *can* support controllers without stride options, and
notice that striding will only be used for the display driver IIRC,
pseudo-code:

ret = dmaengine_device_control(chan, TI_DMA_STRIDE_CONFIG,
                        (unsigned long) &my_stride_config);
if (ret) {
   /*
    * OK no striding on this DMA engine, fall back to something else,
    * such as creating an SGlist which emulates the striding with one
    * sglist element per stride.
    */
}

By injecting an error in the stride config path this can even be
properly tested. So it will become an optional acceleration.

Thanks,
Linus Walleij
