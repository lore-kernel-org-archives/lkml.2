Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab2C0ECC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 00:02:02 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37592 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2C0ECA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 00:02:00 -0400
MIME-Version: 1.0
In-Reply-To: <4F6FF179.5090600@toshiba.co.jp>
References: <1330497714-26504-2-git-send-email-santoshsy@gmail.com> <4F6FF179.5090600@toshiba.co.jp>
From: Santosh Y <santoshsy@gmail.com>
Date: Tue, 27 Mar 2012 09:31:37 +0530
Message-ID: <CALMYJDu5+=wQSkR9SGMFqOSRARPeSK0XzmG8sfjuj2qUn9jOLA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] [SCSI] ufshcd: UFS Host controller driver
To: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org,
        stephen.doel@linaro.org, venkat@linaro.org, ilho215.lee@samsung.com,
        nala.la@samsung.com, girish.shivananjappa@linaro.org,
        vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com,
        sreekumar.c@samsung.com, vinholikatti@gmail.com, linkinjeon@gmail.com,
        michaelc@cs.wisc.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:02 AM, KOBAYASHI Yoshitake
<yoshitake.kobayashi@toshiba.co.jp> wrote:
>> > +        utrdlp[i].response_upiu_length =
>> > +                cpu_to_le16(ALIGNED_UPIU_SIZE);
>
>
> Response UPIU Length(RUL) shows the response UPIU length in Dword.
> (JEDEC Standard No.223 6.2.1 UTP Transfer Request Descriptor)
> The following will be correct.
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 07ec973..feffe65 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -836,7 +836,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba
> *hba)
>                utrdlp[i].prd_table_offset =
>                                cpu_to_le16((prdt_offset >> 2));
>                utrdlp[i].response_upiu_length =
> -                               cpu_to_le16(ALIGNED_UPIU_SIZE);
> +                               cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
>
>
>                hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
>                hba->lrb[i].ucd_cmd_ptr =
>

Thanks, i'll update it.

-- 
~Santosh
