Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab2AVKq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 05:46:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39749 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2AVKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 05:46:53 -0500
Message-ID: <4F1BE91E.6080300@gmail.com>
Date: Sun, 22 Jan 2012 10:46:54 +0000
From: Chris Diamand <chris.diamand@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: linux-kernel@vger.kernel.org, tiwai@suse.de, melchior.franz@gmail.com
Subject: Re: i915/kms/backlight-combo mode problem
References: <4F1AF145.2090407@gmail.com> <86k44kkity.fsf@sumi.keithp.com> <4F1B2D64.7020705@gmail.com> <86bopwk7r7.fsf@sumi.keithp.com>
In-Reply-To: <86bopwk7r7.fsf@sumi.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Here's a patch which just flips the interpretation of that value over;
> does this work?
>
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index 04d79fd..43faa9d 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -207,6 +207,7 @@ u32 intel_panel_get_backlight(struct drm_device *dev)
>                          u8 lbpc;
>
>                          pci_read_config_byte(dev->pdev, PCI_LBPC,&lbpc);
> +                       lbpc = 0xff - lbpc;
>                          val *= lbpc;
>                  }
>          }
> @@ -238,7 +239,7 @@ static void intel_panel_actually_set_backlight(struct drm_device *dev, u32 level
>
>                  lbpc = level * 0xfe / max + 1;
>                  level /= lbpc;
> -               pci_write_config_byte(dev->pdev, PCI_LBPC, lbpc);
> +               pci_write_config_byte(dev->pdev, PCI_LBPC, 0xff - lbpc);
>          }
>
>          tmp = I915_READ(BLC_PWM_CTL);
This works - the backlight stays on, and can be switched off with Fn-F6.
Interestingly the values for setpci -s are still *exactly the same*, as 
in 0x00 is fully on, 0xFF is off (with graduation in between), despite 
the values being reversed.

Chris.
