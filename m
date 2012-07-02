Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2GBPUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:20:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58889 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2GBPUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:20:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH 3/4] [SCSI] ufs: Add AMBA glue driver to ufshcd
Date: Mon, 2 Jul 2012 15:20:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com,
        arnd@linaro.org, girish.shivananjappa@linaro.org,
        saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org,
        k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org,
        ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org,
        sreekumar.c@samsung.com
References: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com> <1341239572-7408-4-git-send-email-vinholikatti@gmail.com>
In-Reply-To: <1341239572-7408-4-git-send-email-vinholikatti@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207021520.03774.arnd@arndb.de>
X-Provags-ID: V02:K0:8xVBas2YJ7CLOrJurqcLU7xd+HDxxnSGMIcnFdqaJ1u
 VhKq21Yv3GU7dNM94drN1qHFb13qWRZekNxTRysjeabfQJOmzL
 0tDVmX/p3Rwm5ZPJtOL+vpfG/3BK8MqVcl4J0u6R817fCRQRvI
 n1sP0eVInOhlaeIvbVxhD67U9ZrjQzYXtiuPgq6CmI2ynQfUis
 5MbchFihKuarR3jgrH/rA2u9kMDbcmeKz7CCYE3iRXc4R1wjgm
 Pl+5XqsF32DXwbgIJr6nHG3LNDMuYKKJPQLFtT98oMWhN7QcVN
 GgHv8Uy6Bav1KzNMfWmJT3bJJvD/8ey/zAVjdQ29dkv3QiqnEB
 xxJDp4mGZnYEU7v8pnB8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2012, Vinayak Holikatti wrote:
> +static struct amba_id ufshcd_amba_ids[] = {
> +       {
> +               /* Fake id for Primecell.*/
> +               .id     = 0x00041FF0,
> +               .mask   = 0x000fffff,
> +       },
> +       { 0, 0 },
> +};

Hi Vinayak,

Can you explain where this fake ID comes from? Is this ID actually
used by any hardware that is around somewhere? If not, I think it
would be better not to provide an AMBA driver at all, but instead
use the platform driver from patch 2 for all non-PCI uses.

	Arnd
