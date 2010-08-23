Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0HWONa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:13:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab0HWON1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:13:27 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present detect
Date: Mon, 23 Aug 2010 16:18:49 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org, gregkh@suse.de,
        jlee@novell.com, Dennis.Jansen@web.de, linux-acpi@vger.kernel.org
References: <1282563648-21935-1-git-send-email-jlee@novell.com>
In-Reply-To: <1282563648-21935-1-git-send-email-jlee@novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008231618.50131.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 August 2010 13:40:48 Lee, Chun-Yi wrote:
> There have some machines not support by i915 drm driver, e.g. MSI U110/U150,
> there are use poulsbo chip and drm driver not support it because legal issue.
> Those machines's acpi backlight control actually work fine and don't need apply
> the intel opregion support.
> So, add intel drm blacklist to intel_opregion_present, it can enable the acpi
> brightness interface on Poulsbo/Morrestown.
> 
> Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
...
> @@ -2567,7 +2584,14 @@ static int __init intel_opregion_present(void)
>  		pci_read_config_dword(dev, 0xfc, &address);
>  		if (!address)
>  			continue;
> -		return 1;
> +		for (i = 0; intel_drm_blacklist[i].device != 0; i++) {
> +			if (dev->device == intel_drm_blacklist[i].device) {
> +				in_blacklist = 1;
> +				break;
You can just return 0 here...
> +			}
> +		}
> +		if (!in_blacklist)
> +			return 1;
and get rid of in_blacklist variable.
Makes the code a bit easier to read.

      Thomas
