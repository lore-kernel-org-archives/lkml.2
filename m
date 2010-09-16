Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0IPNs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 09:48:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41333 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab0IPNs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 09:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SFboomBYVcHqnvVZTYbJCdQCBIG0gahxhjf1wKx2DGrVJG0IziKV+a/6/R8oOs1APQ
         +uytF53pOnvg/9R1fz+3khwfRyIWF8pIpNykekRPsC1iIu1MVgbj5C/GvMs7VEEIuOo+
         rUk+rzBOD9LFSGoS9+CgvX+MzI85cgMbElBt8=
Message-ID: <4C922045.5090408@gmail.com>
Date: Thu, 16 Sep 2010 15:48:53 +0200
From: Maurus Cuelenaere <mcuelenaere@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; nl; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>,
        MeeGo <meego-dev@meego.com>, LKML <linux-kernel@vger.kernel.org>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Arjan <arjan@linux.intel.com>
Subject: Re: [PATCH v3] USB device driver of Topcliff PCH
References: <4C921E19.7010101@dsn.okisemi.com>
In-Reply-To: <4C921E19.7010101@dsn.okisemi.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Op 16-09-10 15:39, Masayuki Ohtake schreef:
> This patch was modified according to the comments of Maurus and Michal.

This isn't a commit description, if you want to put information about what
changed compared to the previous patch, do it ...

>
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> ---

... here

(and add a "---\n")

>  drivers/usb/gadget/Kconfig        |   24 +
>  drivers/usb/gadget/Makefile       |    2 +-
>  drivers/usb/gadget/gadget_chips.h |    7 +
>  drivers/usb/gadget/pch_udc.c      | 3343 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 3375 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/usb/gadget/pch_udc.c
>
[snip]
> +static int speed_fs;
> +module_param_named(speed_fs, speed_fs, bool, S_IRUGO);
> +MODULE_PARM_DESC(speed_fs, "true for Full speed operation");
> +MODULE_DESCRIPTION("OKISEMI PCH USB Device Controller");
> +MODULE_LICENSE("GPL");

MODULE_{DESCRIPTION,LICENSE} is normally put at the end of the file; I don't
know if there's a written rule for that? (if not, you can ignore this)

Also, there's no MODULE_AUTHOR?

[snip]
> +static inline void pch_udc_bit_set(struct pch_udc_dev *dev,
> +                     unsigned long reg,
> +                     unsigned long bitmask)
> +{
> +    pch_udc_writel((dev), ((pch_udc_readl((dev), (reg)) | (bitmask))),
> +               (reg));

nitpick: remove the unneeded parentheses

> +}
> +static inline void pch_udc_bit_clr(struct pch_udc_dev *dev,
> +                     unsigned long reg,
> +                     unsigned long bitmask)
> +{
> +    pch_udc_writel((dev), (pch_udc_readl((dev), (reg)) & (~(bitmask))),
> +               (reg));

and here

> +}
> +
[snip]
> +static inline void pch_udc_ep_bit_set(struct pch_udc_ep *ep,
> +                     unsigned long reg,
> +                     unsigned long bitmask)
> +{
> +    pch_udc_ep_writel((ep), ((pch_udc_ep_readl((ep), (reg)) | (bitmask))),
> +              (reg));

and here

> +}
> +static inline void pch_udc_ep_bit_clr(struct pch_udc_ep *ep,
> +                     unsigned long reg,
> +                     unsigned long bitmask)
> +{
> +    pch_udc_ep_writel((ep), (pch_udc_ep_readl((ep), (reg)) & (~(bitmask))),
> +              (reg));

here too

> +}
> +

--
Maurus Cuelenaere
