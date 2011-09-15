Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740Ab1IOUS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:18:56 -0400
Received: from mx2.parallels.com ([64.131.90.16]:41660 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934640Ab1IOUSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:18:55 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 20/27] Initconst section fixes for SCSI
Thread-Topic: [PATCH 20/27] Initconst section fixes for SCSI
Thread-Index: AQHMc+N1cKxGB8ANgUKWRWrm3FwhhpVPVuqA
Date: Thu, 15 Sep 2011 20:18:48 +0000
Message-ID: <1316117927.2983.74.camel@dabdike.hansenpartnership.com>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
	 <1316117394-21666-21-git-send-email-andi@firstfloor.org>
In-Reply-To: <1316117394-21666-21-git-send-email-andi@firstfloor.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.243.235.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE0726A6EB1CDA4E936E908973B98468@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8FKJAR3030530

On Thu, 2011-09-15 at 13:09 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>

I don't know why you're doing this without a description (and please cc
at least linux-scsi on SCSI patches).

> Cc: JBottomley@parallels.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/scsi/aacraid/linit.c        |    2 +-
>  drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 3382475..9c8d000 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -92,7 +92,7 @@ static DECLARE_PCI_DEVICE_TABLE(aac_pci_tbl) = {
>  #elif defined(__devinitconst)
>  static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
>  #else
> -static const struct pci_device_id aac_pci_tbl[] __devinitdata = {
> +static const struct pci_device_id aac_pci_tbl[] __devinitconst = {

How can this possibly be correct?  You just checked in the preceding
#elif defined() that __devinitconst wasn't defined for this leg, so if
it's taken there'll be an instant compile failure.

If you want to argue the whole of the #ifdef construct should be removed
then I'd be interested.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
