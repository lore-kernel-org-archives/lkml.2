Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965358Ab0CPGPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:15:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936261Ab0CPGPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:15:38 -0400
Message-ID: <4B9F2204.7050302@redhat.com>
Date: Tue, 16 Mar 2010 08:15:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Sheng Yang <sheng@linux.intel.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM MMU: check reserved bits only if CR4.PSE=1 or CR4.PAE=1
References: <4B9FCC42.2080709@cn.fujitsu.com> <4B9F17BC.50108@redhat.com> <4B9F1F47.2040700@cn.fujitsu.com>
In-Reply-To: <4B9F1F47.2040700@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 08:03 AM, Xiao Guangrong wrote:
>
>> I think the only change is that is !is_pse(vcpu) we ignore bit 7?
>>      
> If the vcpu is in PT32E_ROOT_LEVEL/PT64_ROOT_LEVEL mode, CR4.PAE
> is aways enabled, so what we need do is ignore bit7 if !is_pse(vcpu)
> under PT32_ROOT_LEVEL mode, right?
>    

I think PAE will fault if bit7 is set and !is_pse(vcpu), but not sure.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

