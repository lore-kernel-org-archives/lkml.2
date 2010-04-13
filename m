Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab0DMPAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:00:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab0DMPAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:00:17 -0400
Message-ID: <4BC486CE.1040503@redhat.com>
Date: Tue, 13 Apr 2010 10:59:26 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc14 Thunderbird/3.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com
Subject: Re: [PATCH 2/2] RFC: iscsi ibft: convert iscsi_ibft module to iscsi
 boot lib
References: <1271095578-4212-1-git-send-email-michaelc@cs.wisc.edu> <201004122221.05326.konrad@darnok.org> <4BC3D7C1.90307@cs.wisc.edu> <201004122236.13843.konrad@darnok.org>
In-Reply-To: <201004122236.13843.konrad@darnok.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 10:36 PM, Konrad Rzeszutek Wilk wrote:
> On Monday 12 April 2010 22:32:33 Mike Christie wrote:
>> On 04/12/2010 09:21 PM, Konrad Rzeszutek Wilk wrote:
>>>> + * Helper routiners to check to determine if the entry is valid
>>>> + * in the proper iBFT structure.
>>>> + */
>>>> +static mode_t ibft_check_nic_for(void *data, int type)
>>>> +{
>>>> +	struct ibft_kobject *entry = data;
>>>> +	struct ibft_nic *nic = entry->nic;
>>>> +	mode_t rc = 0;
>>>> +
>>>> +	switch (type) {
>>>> +	case ISCSI_BOOT_ETH_INDEX:
>>>> +	case ISCSI_BOOT_ETH_FLAGS:
>>>> +		rc = 1;
>>>
>>> Did you mean for that value?
>>>
>>>> +		break;
>>>> +	case ISCSI_BOOT_ETH_IP_ADDR:
>>>> +		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
>>>> +			rc = S_IRUGO;
>>>> +		break;
>>>> +	case ISCSI_BOOT_ETH_SUBNET_MASK:
>>>> +		if (nic->subnet_mask_prefix)
>>>> +			rc = S_IRUGO;
>>>> +		break;
>>>> +	case ISCSI_BOOT_ETH_ORIGIN:
>>>> +		rc = 1;
>>>
>>> and this one as well?
>>
>> I did not. They should be S_IRUGO. Do you want me to resubmit the
>> patches or are you just going to edit those two lines if you merge them?
> 
> No need to resend them (unless Peter eyes found something I missed).

Nope, that's all I see.

-- 
        Peter

Sanity's just a one trick pony anyway.  You only get one trick -- rational
thinking -- but when you're good and crazy, the sky's the limit!
		-- The Tick
