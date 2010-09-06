Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0IFBor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 21:44:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51546 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab0IFBoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 21:44:46 -0400
Message-ID: <4C844887.9090802@cn.fujitsu.com>
Date: Mon, 06 Sep 2010 09:48:55 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: don't sent IPI if the vcpu is not online
References: <4C807593.1050903@cn.fujitsu.com> <4C83445B.4020103@redhat.com>
In-Reply-To: <4C83445B.4020103@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2010 03:18 PM, Avi Kivity wrote:
>  On 09/03/2010 07:12 AM, Xiao Guangrong wrote:
>> It's no need sent IPI to the vcpu which is schedule out
>>
>>
>> @@ -86,6 +86,7 @@ struct kvm_vcpu {
>>       unsigned long requests;
>>       unsigned long guest_debug;
>>       int srcu_idx;
>> +    bool online;
> 
> Why not check for guest_mode instead?
> 

Oh, i forget it...but 'vcpu->guest_mode' is only used in x86 platform,
and make_all_cpus_request() is a common function.

So, maybe it's better use 'vcpu->online' here, and move 'guest_mode' into
'vcpu->arch' ?
