Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0KIOc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:32:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab0KIOc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:32:56 -0500
Message-ID: <4CD95B93.70607@redhat.com>
Date: Tue, 09 Nov 2010 16:32:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: andre@bsrsoft.com.br
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] virt: ack_flush() function removed for lack of apparent
 use 2.6.37-rc1
References: <516164.25539.qm@web110514.mail.gq1.yahoo.com>
In-Reply-To: <516164.25539.qm@web110514.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2010 07:01 AM, André Luis Pereira dos Santos - BSRSoft wrote:
> Hello
>
> Ack_flush function () is not used anywhere in the code and apparently has no function currently defined.
>
> Unless there are plans to use it in the future, I took it out via this patch code for readability.
>
>
>
> Signed-off-by: Andre Luis Pereira dos Santos<andre@bsrsoft.com.br>
> ---
> Signed-off-by: Andre Luis Pereira dos Santos<andre@bsrsoft.com.br>
> --- linux-2.6.37-rc1/virt/kvm/kvm_main.c	2010-11-01 09:54:12.000000000 -0200
> +++ linux-2.6.37-rc1-patched/virt/kvm/kvm_main.c	2010-11-06 02:43:56.000000000 -0200
> @@ -132,9 +132,6 @@ void vcpu_put(struct kvm_vcpu *vcpu)
>   	mutex_unlock(&vcpu->mutex);
>   }
>
> -static void ack_flush(void *_completed)
> -{
> -}
>

It is in use:
> upstream:virt/kvm/kvm_main.c:static void ack_flush(void *_completed)
> upstream:virt/kvm/kvm_main.c:           
> smp_call_function_many(cpu_online_mask, ack_flush, NULL, 1);
> upstream:virt/kvm/kvm_main.c:           smp_call_function_many(cpus, 
> ack_flush, NULL, 1);


-- 
error compiling committee.c: too many arguments to function

