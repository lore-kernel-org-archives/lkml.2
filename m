Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2HFXCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:02:08 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36391 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756373Ab2HFXCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:02:06 -0400
X-Sasl-enc: hNjeTeJG0qtt3QrBHwCKrol7kotvhqUjkNrtKiCSMdiX 1344294122
Date: Mon, 6 Aug 2012 20:01:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: manoj.iyer@canonical.com
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        mjg@redhat.com, ibm-acpi@hmh.eng.br,
        platform-driver-x86@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: recognize latest
 V-Series using DMI_BIOS_VENDOR
Message-ID: <20120806230157.GC8824@khazad-dum.debian.net>
References: <1344291669-9711-1-git-send-email-manoj.iyer@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344291669-9711-1-git-send-email-manoj.iyer@canonical.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2012, manoj.iyer@canonical.com wrote:
> From: Manoj Iyer <manoj.iyer@canonical.com>
> 
> In the latest V-series bios DMI_PRODUCT_VERSION does not contain
> the string Lenovo or Thinkpad, but is set to the model number, this
> causes the thinkpad_acpi module to fail to load. Recognize laptop
> as Lenovo using DMI_BIOS_VENDOR instead, which is set to Lenovo.

Please add here the testing you did.

> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> ---
>  drivers/platform/x86/thinkpad_acpi.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index e7f7328..66dfdef 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -8663,6 +8663,14 @@ static int __must_check __init get_thinkpad_model_data(
>  		if (!tp->model_str)
>  			return -ENOMEM;
>  	}
> +	else {

Please fix this:  } else {   all in a single line.

> +		s = dmi_get_system_info(DMI_BIOS_VENDOR);
> +		if (s && !(strnicmp(s, "Lenovo", 6))) {
> +			tp->model_str = kstrdup(s, GFP_KERNEL);
> +			if (!tp->model_str)
> +				return -ENOMEM;
> +		}
> +	} 
>  
>  	s = dmi_get_system_info(DMI_PRODUCT_NAME);
>  	tp->nummodel_str = kstrdup(s, GFP_KERNEL);

That should be all.  You might want to get acquinted with the checkpatch
script, it would have pointed the "else" thing to you, I think (I didn't
notice it right away).

Anyway, other than the cosmetic stuff above, the patch looks good.  I
haven't tested it yet on a IBM thinkpad, though.  Will do later today.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
