Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935325Ab2JaKPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:15:40 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:52038 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932975Ab2JaKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:15:37 -0400
Message-ID: <5090FA1A.2070605@marvell.com>
Date: Wed, 31 Oct 2012 18:14:50 +0800
From: yongd <yongd@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Daniel Drake <dsd@laptop.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>, Zhangfei Gao <zgao6@marvell.com>,
        Kevin Liu <kliu5@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] mmc: remove MMC_CAP_NEEDS_POLL setting in sdhci_add_host
References: <1351589403-26398-1-git-send-email-yongd@marvell.com> <20121030231124.GA2902@lizard>
In-Reply-To: <20121030231124.GA2902@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 Oct 2012 10:14:46.0807 (UTC) FILETIME=[8DCF9270:01CDB750]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年10月31日 07:11, Anton Vorontsov wrote:
> On Tue, Oct 30, 2012 at 05:30:00PM +0800, yongd wrote:
>> Sorry for my so late. And eventually these updated patches are here for your
>> review. Thanks in advance.
>> For patch 1, add SDHCI_QUIRK_BROKEN_CARD_DETECTION setting for ESDHC_CD_GPIO type,
>> or the host controller detection interrupts will be redundantly enabled. And its
>> comment is correspondingly updated.
>> For patch 2, broaden SDHCI_QUIRK_BROKEN_CARD_DETECTION setting for all detection
>> types except S3C_SDHCI_CD_INTERNAL. Then also update the comment.
>> For patch 3, no update.
> They all look OK, but note that I did not check drivers' logic, so I hope
> you carefully reviewed all the drivers yourself. :)
>
> Unfortunately, you decided to go the dangerous way, instead of taking my
> 100%-safe approach (i.e.
> http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg16555.html ),
> which, to me, still makes more sense (of course :).
>
> Anyways, I'm not opposed either, so hopefully it works:
>
> 	Reviewed-by: Anton Vorontsov <cbouatmailru@gmail.com>
>
> Thanks!
> Anton.

Anton,
Thanks for your kindly review:-)

Just as I replied to u in the past (maybe got missed due to my previous 
improper mail setting.
Thanks for Shawn Guo again:-)), I don't think your approach is proper. 
Pls forgive me, ha ha...

Something like SDHCI_QUIRK_NEEDS_POLL means all the other detection 
types are unavailable
except polling, and then if the card is removable, polling will be 
enabled. Based on such meaning,
host driver will need set this flag if the host and card are of the 
case. That is exactly of the detection
type like  ESDHC_CD_NONE or S3C_SDHCI_CD_NONE, etc. So, why not directly 
set the existing
MMC_CAP_NEEDS_POLL in host driver itself (just like Au1xmmc.c, etc)? I 
think it is better than achieving
this indirectly through one more flag and some more logic code. Yes, one 
more line for each host driver,
but it is very clear and save one unnecessary flag, isn't it?

BTW, currently not all SDHCI_QUIRK_BROKEN_CARD_DETECTION flags in other 
host drivers are set to
notify we shall use polling since this flag has its own pure usage. So 
we can not simply convert them
to the new flag u mentioned. Hope I've gotten your idea:-)

So I think my patches are the proper way:-) BTW, I've carefully review 
those patches. Thanks for your
reminding.

Shawn,
Could u pls help review those patches again? Thanks in advance.
