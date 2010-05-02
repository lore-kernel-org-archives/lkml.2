Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0EBNt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 09:49:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab0EBNtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 09:49:55 -0400
Message-ID: <4BDD82EA.7060308@redhat.com>
Date: Sun, 02 May 2010 16:49:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Shane Wang <shane.wang@intel.com>
CC: hpa@zytor.com, mingo@elte.hu, joseph.cihula@intel.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] intel_txt: enable VMXON check with SMX in KVM
References: <1272557341-3777-1-git-send-email-shane.wang@intel.com>
In-Reply-To: <1272557341-3777-1-git-send-email-shane.wang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2010 07:09 PM, Shane Wang wrote:
> Per document, for feature control MSR
> Bit 1 enables VMXON in SMX operation. If the bit is clear, execution of VMXON in SMX operation causes a general-protection exception.
> Bit 2 enables VMXON outside SMX operation. If the bit is clear, execution of VMXON outside SMX operation causes a general-protection exception.
>
> This patch is to enable this kind of check with SMX for VMXON in KVM.
>
>    

Looks good.

> @@ -1176,9 +1177,16 @@ static __init int vmx_disabled_by_bios(v
>   	u64 msr;
>
>   	rdmsrl(MSR_IA32_FEATURE_CONTROL, msr);
> -	return (msr&  (FEATURE_CONTROL_LOCKED |
> -		       FEATURE_CONTROL_VMXON_ENABLED))
> -	    == FEATURE_CONTROL_LOCKED;
> +	if (!!(msr&  FEATURE_CONTROL_LOCKED)) {
>    

!! not really necessary here (no need to resend, we can fix while applying).

-- 
error compiling committee.c: too many arguments to function

