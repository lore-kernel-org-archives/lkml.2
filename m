Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab1JaN5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 09:57:23 -0400
Received: from hera.cwi.nl ([192.16.191.8]:64654 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab1JaN5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 09:57:22 -0400
Message-ID: <4EAEA93A.9010100@science.uva.nl>
Date: Mon, 31 Oct 2011 13:57:14 +0000
From: "Wouter M. Koolen" <wmkoolen@science.uva.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Icedove/3.1.15
MIME-Version: 1.0
To: Alex Davis <alex14641@yahoo.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] i915 dpms does not switch back light on
References: <1319743670.62757.YahooMailNeo@web130109.mail.mud.yahoo.com> <1319747904.1731.YahooMailNeo@web130113.mail.mud.yahoo.com>
In-Reply-To: <1319747904.1731.YahooMailNeo@web130113.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 09:38 PM, Alex Davis wrote:
> If the patch above doesn't work, try this one:
>
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index 6f56676..a9e0c7b 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -262,6 +262,8 @@ void intel_panel_disable_backlight(struct drm_device *dev)
>                  dev_priv->backlight_level = intel_panel_get_backlight(dev);
>                  dev_priv->backlight_enabled = false;
>          }
> +
> +       intel_panel_set_backlight(dev, 0);
>   }
>   
>   void intel_panel_enable_backlight(struct drm_device *dev)
Hi Alex,

That indeed solves the problem here.

Thanks for your swift response.

Wouter
