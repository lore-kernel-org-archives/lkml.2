Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1KDKXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 06:23:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43446 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab1KDKXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 06:23:51 -0400
MIME-Version: 1.0
In-Reply-To: <4EB39BB4.3060508@intel.com>
References: <4EB39BB4.3060508@intel.com>
Date: Fri, 4 Nov 2011 06:23:49 -0400
Message-ID: <CAGxe1ZFxE+ktigoTQjsCx8AYJbSfT+FDa9ms4Y=d8P96enzxSA@mail.gmail.com>
Subject: Re: Incorrect checkpatch warning
From: Girish K S <girish.shivananjappa@linaro.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: joe@perches.com, linux-kernel@vger.kernel.org,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2011 04:00, Adrian Hunter <adrian.hunter@intel.com> wrote:
> Hi
>
> This checkpatch warning looks wrong:
>
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #73: FILE: drivers/mmc/host/sdhci-pci-data.c:5:
> +EXPORT_SYMBOL_GPL(sdhci_pci_get_data);
>
> The patch has this:
>
> diff --git a/drivers/mmc/host/sdhci-pci-data.c b/drivers/mmc/host/sdhci-pci-data.c
> new file mode 100644
> index 0000000..a611217
> --- /dev/null
> +++ b/drivers/mmc/host/sdhci-pci-data.c
> @@ -0,0 +1,5 @@
> +#include <linux/module.h>
> +#include <linux/mmc/sdhci-pci-data.h>
> +
> +struct sdhci_pci_data *(*sdhci_pci_get_data)(struct pci_dev *pdev, int slotno);
> +EXPORT_SYMBOL_GPL(sdhci_pci_get_data);
>since it is a prototype you get that message. use EXPORT_SYMBOL below the function definition and not below prototype declaration
>
> Regards
> Adrian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
