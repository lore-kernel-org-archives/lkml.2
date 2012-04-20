Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2DTCsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 22:48:52 -0400
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:33179 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2DTCsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 22:48:51 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 22:48:51 EDT
X-AuthUser: garloff@garloff.de
References: <CABawtvMOtG3tsscoOD4P7VH-v8PWJL=JaoOoTwvzRi=aigvEdA@mail.gmail.com> <CABawtvMM8JeVbnRZagdogzdOVDoPaE6eAFPR3QPTEbuwOfLBsQ@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CABawtvMM8JeVbnRZagdogzdOVDoPaE6eAFPR3QPTEbuwOfLBsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Fwd: [PATCH] drivers/acpi/numa.c: Add localities checking code against proximity domains to slit_valid()
From: Kurt Garloff <kurt@garloff.de>
Date: Thu, 19 Apr 2012 19:38:08 -0700
To: ethan zhao <ethan.kernel@gmail.com>, len.brown@intel.com
CC: linux-kernel@vger.kernel.org
Message-ID: <3c0e0332-6cfb-4e4a-a599-2f4c86e45745@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ethan,





ethan zhao <ethan.kernel@gmail.com> schrieb:

> Some buggy BIOS/ACPI will set different number to SLIT localities and
> SRAT proximity domains,
>  That will make NUMA configuration invalid and kernel will output
> information like following
> 
> NUMA:Warning:invalid distance parameter, from=-1 to=-1 distance=83
> 
> This patch adds some checking code to slit_valid() function in order
> to check the SLIT localities
> count against SRAT proximity domains number and give clear information
> about ACPI bug.
> 
> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
> ---
>  drivers/acpi/numa.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index e56f3be..55c8a8e 100644
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -161,6 +161,13 @@ static __init int slit_valid(struct
> acpi_table_slit
> *slit)
>  {
>         int i, j;
>         int d = slit->locality_count;
> +       int pxd = nodes_weight(nodes_found_map);
> +       if (pxd != d) {
> +               printk(KERN_INFO "ACPI: BIOS bug! SLIT localities
> count %d
> doesn't equal SRAT proximity domains number %d\n",
> +                       d , pxd);
> +               return 0;
> +       }
> +
>         for (i = 0; i < d; i++) {
>                 for (j = 0; j < d; j++)  {
>                         u8 val = slit->entry[d*i + j];
> --
> 1.7.1

Patch looks good to me. When I first saw it I was wondering whether that should be controlled via some quirk entry. But probably it can't trigger if everything is correct so that it's probably unneeded complexity. Someone with more intimate knowledge of ACPI should confirm  that and this should be good to go.


Cheers, 

-- 
Kurt Garloff <Kurt@Garloff.de>  [Köln/ Greven]
(Sent from Android phone with K-9 Mail.)
