Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab1ESQS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:18:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:45299 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933209Ab1ESQSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:18:24 -0400
X-ExtLoop1: 1
Message-ID: <4DD542C8.9040206@intel.com>
Date: Thu, 19 May 2011 09:18:16 -0700
From: Kiran Patil <kiran.patil@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Yi Zou <yi.zou@intel.com>,
        Joe Eykholt <joe.eykholt@gmail.com>
Subject: Re: linux-next: build warning after merge of the scsi tree
References: <20110518114912.dfdf8835.sfr@canb.auug.org.au>	 <1305684362.2856.349.camel@haakon2.linux-iscsi.org>	 <20110518135823.a809f829.sfr@canb.auug.org.au> <1305773688.2856.449.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1305773688.2856.449.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Sorry, I should have fixed that issue. Anyways, I will fix it and send 
patch out.


On 5/18/2011 7:54 PM, Nicholas A. Bellinger wrote:
> On Wed, 2011-05-18 at 13:58 +1000, Stephen Rothwell wrote:
>> Hi Nicholas,
>>
>> On Tue, 17 May 2011 19:06:02 -0700 "Nicholas A. Bellinger"<nab@linux-iscsi.org>  wrote:
>>> On Wed, 2011-05-18 at 11:49 +1000, Stephen Rothwell wrote:
>>>> After merging the scsi tree, today's linux-next build (x86_64 allmodconfig)
>>>> produced this warning:
>>>>
>>>> drivers/target/tcm_fc/tfc_io.c: In function 'ft_queue_data_in':
>>>> drivers/target/tcm_fc/tfc_io.c:209: warning: format '%x' expects type 'unsigned int', but argument 5 has type 'size_t'
>>>>
>>>> Introduced by commit 3699d92a4d7b ("[SCSI] tcm_fc: Adding FC_FC4 provider
>>>> (tcm_fc) for FCoE target (TCM - target core) support").
>>>>
>>> It appears that this warning was fixed in LIO upstream a while back, but
>>> did not make it into this morning scsi-misc merge.  Please apply.
>>>
>>> > From b830de5068d0c3745e83393f81d87f745ef7a4f2 Mon Sep 17 00:00:00 2001
>>> From: Nicholas Bellinger<nab@linux-iscsi.org>
>>> Date: Thu, 17 Feb 2011 21:56:16 +0000
>>> Subject: [PATCH] tcm_fc: Fix conversion spec compile warning in ft_queue_data_in
>>> MIME-Version: 1.0
>>> Content-Type: text/plain; charset=UTF-8
>>> Content-Transfer-Encoding: 8bit
>>>
>>> This patch fixes the following compile warning in ft_queue_data_in():
>>>
>>> drivers/target/tcm_fc/tfc_io.c: In function ‘ft_queue_data_in’:
>>> drivers/target/tcm_fc/tfc_io.c:209: warning: format ‘%x’ expects type ‘unsigned int’, but argument 5 has type ‘size_t’
>>>
>>> Signed-off-by: Nicholas A. Bellinger<nab@linux-iscsi.org>
>>> ---
>>>   drivers/target/tcm_fc/tfc_io.c |    3 ++-
>>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
>>> index 4c3c0ef..3936bb1 100644
>>> --- a/drivers/target/tcm_fc/tfc_io.c
>>> +++ b/drivers/target/tcm_fc/tfc_io.c
>>> @@ -206,7 +206,8 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
>>>                                                  "xid<0x%x>, remaining<0x%x>, "
>>>                                                  "lso_max<0x%x>\n",
>>>                                                  __func__, fp, ep->xid,
>>> -                                               remaining, lport->lso_max);
>>> +                                               (unsigned int)remaining,
>>> +                                               lport->lso_max);
>> Given that "remaining" really is a length, surely it makes more sense to
>> print it with %zd than to cast it and print it with %x ...
>>
> This is fine with me.  Bad habit of explictly casting conversion
> specifications from sector_t type usage..
>
> Kiran, would you mind fixing this to use %zd in your tree, and include
> this along with the TMR LUN_RESET bugfix for James to include in
> scsi-misc..?
>
> Thanks,
>
> --nab
>
No problem. I will fix it and get it out along with my other patch 
series for offload, big fixes, etc.. via. Open-FCoE which has been 
rebased to scsi-misc yesterday (scsi-misc now has tcm_fc)

Thanks,
-- Kiran P.

