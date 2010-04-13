Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0DMCdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 22:33:31 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35658 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab0DMCda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 22:33:30 -0400
Message-ID: <4BC3D7C1.90307@cs.wisc.edu>
Date: Mon, 12 Apr 2010 21:32:33 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pjones@redhat.com, open-iscsi@googlegroups.com
Subject: Re: [PATCH 2/2] RFC: iscsi ibft: convert iscsi_ibft module to iscsi
 boot lib
References: <1271095578-4212-1-git-send-email-michaelc@cs.wisc.edu> <1271095578-4212-2-git-send-email-michaelc@cs.wisc.edu> <201004122221.05326.konrad@darnok.org>
In-Reply-To: <201004122221.05326.konrad@darnok.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 09:21 PM, Konrad Rzeszutek Wilk wrote:
>> + * Helper routiners to check to determine if the entry is valid
>> + * in the proper iBFT structure.
>> + */
>> +static mode_t ibft_check_nic_for(void *data, int type)
>> +{
>> +	struct ibft_kobject *entry = data;
>> +	struct ibft_nic *nic = entry->nic;
>> +	mode_t rc = 0;
>> +
>> +	switch (type) {
>> +	case ISCSI_BOOT_ETH_INDEX:
>> +	case ISCSI_BOOT_ETH_FLAGS:
>> +		rc = 1;
>
> Did you mean for that value?
>> +		break;
>> +	case ISCSI_BOOT_ETH_IP_ADDR:
>> +		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
>> +			rc = S_IRUGO;
>> +		break;
>> +	case ISCSI_BOOT_ETH_SUBNET_MASK:
>> +		if (nic->subnet_mask_prefix)
>> +			rc = S_IRUGO;
>> +		break;
>> +	case ISCSI_BOOT_ETH_ORIGIN:
>> +		rc = 1;
>
> and this one as well?

I did not. They should be S_IRUGO. Do you want me to resubmit the 
patches or are you just going to edit those two lines if you merge them?
