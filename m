Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1FOEzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 00:55:19 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:39043 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922Ab1FOEzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 00:55:17 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "yxlraid@gmail.com" <yxlraid@gmail.com>,
        "jack_wang@usish.com" <jack_wang@usish.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "maciej.trela@intel.com" <maciej.trela@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Date: Tue, 14 Jun 2011 21:52:05 -0700
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Topic: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Index: AcwrEux3RnqcN2EwTTKKJBltrXMSzQAA3p6w
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAE66A54@SC-VEXCH4.marvell.com>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
 <1308065367.2401.24.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
 <4DF831E6.3050502@interlog.com>
In-Reply-To: <4DF831E6.3050502@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5F4tUYt017669


On 11-06-14 09:44 PM, Xiangliang Yu wrote:
>> Subject: Re: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
>>
>> On Tue, 2011-06-14 at 23:17 +0800, yxlraid@gmail.com wrote:
>>>> From: Xiangliang Yu<yuxiangl@marvell.com>
>>>>
>>>> -- The value of child link rate should is minimum of link rate, or
>>>>     command will fail if child link rate is bigger than parent link rate.
>>>>
>>>> Signed-off-by: Xiangliang Yu<yuxiangl@marvell.com>
>>>> ---
>>>>   drivers/scsi/libsas/sas_expander.c |    2 +-
>>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>>>> index 874e29d..6ccca09 100644
>>>> --- a/drivers/scsi/libsas/sas_expander.c
>>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>>> @@ -638,7 +638,7 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
>>>>   			sas_port_add_phy(port, phy->phy);
>>>>   		}
>>>>   	}
>>>> -	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
>>>> +	child->linkrate = min(parent_phy->linkrate, child->min_linkrate);
>>
>>> This patch doesn't look right.  It will clamp the phy to the minim
>>> possible link rate.
>> Link negotiation should get the minimum.

>spl2r01.pdf [Most recent SAS-3 draft for the protocol layers]
>5.7.4.2.1 SAS speed negotiation sequence overview
>"The SAS speed negotiation sequence establishes communications between
>the two phys on a physical link at the highest possible transmission
>rate."
>That seems to suggest:
>    min(<one_end>.max_linkrate, <other_end>.max_linkrate)

Thanks£¡
The current statement like this: child->linkrate = min(child_phy_linkrate, max(parent->max_linkrate, child_phy_linkrate->max_linkrate);

How about this change:
child->linkrate = min(parent->max_linkrate, child->max_linkrate);

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
