Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1GFTQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:16:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60836 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab1GFTQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:16:47 -0400
Message-ID: <4E14B511.5000408@cn.fujitsu.com>
Date: Thu, 07 Jul 2011 03:18:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 14/19] KVM: MMU: clean up spte updating and clearing
References: <4E0C3178.2080603@cn.fujitsu.com> <4E0C32FE.2020805@cn.fujitsu.com> <20110706173911.GA9820@amt.cnet>
In-Reply-To: <20110706173911.GA9820@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 03:16:06,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 03:16:06,
	Serialize complete at 2011-07-07 03:16:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 01:39 AM, Marcelo Tosatti wrote:
 
>> -static bool spte_is_bit_cleared(u64 old_spte, u64 new_spte, u64 bit_mask)
>> +static void track_spte_bits(u64 old_spte, u64 keep_bits, bool always_track)
>>  {
>> -	return (old_spte & bit_mask) && !(new_spte & bit_mask);
>> +	if (always_track ||
>> +	      (spte_is_bit_cleared(old_spte, keep_bits, shadow_accessed_mask)))
>> +		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
>> +
>> +	if (always_track ||
>> +	      (spte_is_bit_cleared(old_spte, keep_bits, shadow_dirty_mask)))
>> +		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
>> +}
> 
> This is much more confusing than previously, please drop it.
> 

What about remove "always_track" parameter? After that, the code should be clear.

