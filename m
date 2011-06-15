Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab1FOBrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:47:19 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:45709 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752334Ab1FOBrQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:47:16 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "yxlraid@gmail.com" <yxlraid@gmail.com>
CC: "jack_wang@usish.com" <jack_wang@usish.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "maciej.trela@intel.com" <maciej.trela@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Date: Tue, 14 Jun 2011 18:44:26 -0700
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Topic: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Index: Acwqp9vMNbR+W9HUQXesEQiSUlxiugAUnwsg
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
 <1308065367.2401.24.camel@mulgrave>
In-Reply-To: <1308065367.2401.24.camel@mulgrave>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Re: [PATCH] [SCSI] LIBSAS: fix libsas link error issue

On Tue, 2011-06-14 at 23:17 +0800, yxlraid@gmail.com wrote:
>> From: Xiangliang Yu <yuxiangl@marvell.com>
>> 
>> -- The value of child link rate should is minimum of link rate, or
>>    command will fail if child link rate is bigger than parent link rate.
>> 
>> Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
>> ---
>>  drivers/scsi/libsas/sas_expander.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> index 874e29d..6ccca09 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -638,7 +638,7 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
>>  			sas_port_add_phy(port, phy->phy);
>>  		}
>>  	}
>> -	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
>> +	child->linkrate = min(parent_phy->linkrate, child->min_linkrate);

>This patch doesn't look right.  It will clamp the phy to the minim
>possible link rate.  
Link negotiation should get the minimum.

>The child is supposed to support everywhere between
>child->min_linkrate and child->max_linkrate.  The reason why we pick the
>max is because we should use that if the parent supports it, and fall
>back only if the parent isn't capable.
Now, the problem is command fail, and LIBSAS seem to do nothing.
Do you mean drive need to fix the link error?
Thanks!

PS: The Kernel will panic when link error happening.

