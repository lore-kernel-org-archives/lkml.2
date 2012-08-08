Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab2HHSrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:47:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58597 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561Ab2HHSrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:47:37 -0400
Message-ID: <5022B444.2020501@wwwdotorg.org>
Date: Wed, 08 Aug 2012 12:47:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: vt8500-wm8505-linux-kernel@googlegroups.com, linux-fbdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-doc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Eric Andersson <eric.andersson@unixphere.com>,
        linux-serial@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>, Neil Zhang <zhangwm@marvell.com>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 5/8] video: vt8500: Add devicetree support for vt8500-fb
 and wm8505-fb
References: <1344389967-8465-1-git-send-email-linux@prisktech.co.nz> <1344389967-8465-6-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1344389967-8465-6-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 07:39 PM, Tony Prisk wrote:
> Update vt8500-fb, wm8505-fb and wmt-ge-rops to support device
> tree bindings.

> Small change in wm8505-fb.c to support WM8650 framebuffer color
> format.

That might warrant a separate patch?

> diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c

> +	np = of_find_node_by_name(NULL, "display");
> +	if (!np) {
> +		pr_err("%s: No display description in Device Tree\n", __func__);
> +		ret = -EINVAL;
> +		goto failed_free_res;
> +	}

I believe that using hard-coded node names is frowned upon. Better would
be to put a phandle into the display controller's node that points at
the node representing the display, e.g.:

    fb@d800e400 {
        compatible = "via,vt8500-fb";
        reg = <0xd800e400 0x400>;
        interrupts = <12>;
        via,display = <&display>;
    };
    display: display {
        ...
    };

