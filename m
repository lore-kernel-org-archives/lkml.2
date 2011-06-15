Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997Ab1FOEP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 00:15:58 -0400
Received: from smtp.infotech.no ([82.134.31.41]:47627 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab1FOEP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 00:15:57 -0400
Message-ID: <4DF831E6.3050502@interlog.com>
Date: Wed, 15 Jun 2011 00:15:34 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiangliang Yu <yuxiangl@marvell.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "yxlraid@gmail.com" <yxlraid@gmail.com>,
        "jack_wang@usish.com" <jack_wang@usish.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "maciej.trela@intel.com" <maciej.trela@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Subject: Re: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com> <1308065367.2401.24.camel@mulgrave> <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-14 09:44 PM, Xiangliang Yu wrote:
> Subject: Re: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
>
> On Tue, 2011-06-14 at 23:17 +0800, yxlraid@gmail.com wrote:
>>> From: Xiangliang Yu<yuxiangl@marvell.com>
>>>
>>> -- The value of child link rate should is minimum of link rate, or
>>>     command will fail if child link rate is bigger than parent link rate.
>>>
>>> Signed-off-by: Xiangliang Yu<yuxiangl@marvell.com>
>>> ---
>>>   drivers/scsi/libsas/sas_expander.c |    2 +-
>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>>> index 874e29d..6ccca09 100644
>>> --- a/drivers/scsi/libsas/sas_expander.c
>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>> @@ -638,7 +638,7 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
>>>   			sas_port_add_phy(port, phy->phy);
>>>   		}
>>>   	}
>>> -	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
>>> +	child->linkrate = min(parent_phy->linkrate, child->min_linkrate);
>
>> This patch doesn't look right.  It will clamp the phy to the minim
>> possible link rate.
> Link negotiation should get the minimum.

spl2r01.pdf [Most recent SAS-3 draft for the protocol layers]

5.7.4.2.1 SAS speed negotiation sequence overview

"The SAS speed negotiation sequence establishes communications between
the two phys on a physical link at the highest possible transmission
rate."


That seems to suggest:
    min(<one_end>.max_linkrate, <other_end>.max_linkrate)

Doug Gilbert


