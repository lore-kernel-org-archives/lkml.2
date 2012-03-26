Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab2CZFWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:22:40 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:52140 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2CZFWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:22:35 -0400
X-Greylist: delayed 2101 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2012 01:22:35 EDT
Message-ID: <4F6FF179.5090600@toshiba.co.jp>
Date: Mon, 26 Mar 2012 13:32:57 +0900
From: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org,
        stephen.doel@linaro.org, venkat@linaro.org, ilho215.lee@samsung.com,
        nala.la@samsung.com, girish.shivananjappa@linaro.org,
        vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com,
        sreekumar.c@samsung.com, vinholikatti@gmail.com, linkinjeon@gmail.com,
        michaelc@cs.wisc.edu
Subject: Re: [PATCH v3 1/5] [SCSI] ufshcd: UFS Host controller driver
References: <1330497714-26504-2-git-send-email-santoshsy@gmail.com>
In-Reply-To: <1330497714-26504-2-git-send-email-santoshsy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +        utrdlp[i].response_upiu_length =
> > +                cpu_to_le16(ALIGNED_UPIU_SIZE);

Response UPIU Length(RUL) shows the response UPIU length in Dword.
(JEDEC Standard No.223 6.2.1 UTP Transfer Request Descriptor)
The following will be correct.

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 07ec973..feffe65 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -836,7 +836,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
                 utrdlp[i].prd_table_offset =
                                 cpu_to_le16((prdt_offset >> 2));
                 utrdlp[i].response_upiu_length =
-                               cpu_to_le16(ALIGNED_UPIU_SIZE);
+                               cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);

                 hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
                 hba->lrb[i].ucd_cmd_ptr =

