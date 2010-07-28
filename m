Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0G1Pr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:47:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53094 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0G1Pr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:47:26 -0400
Message-ID: <4C5050F9.9080001@oracle.com>
Date: Wed, 28 Jul 2010 08:47:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: linux-next: Tree for July 27 (xen)
References: <20100727160708.722c39c1.sfr@canb.auug.org.au> <4C4F27A3.5040109@oracle.com> <alpine.DEB.2.00.1007281410030.19809@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1007281410030.19809@kaball-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C505105.0192:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/10 06:11, Stefano Stabellini wrote:
> On Tue, 27 Jul 2010, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20100726:
>>>
>>>
>>> The xen tree lost its build problems but gained a conflict against Linus'
>>> tree.
>>
>> when X86_32=y, SMP=n, X86_LOCAL_APIC=n:
>>
>> drivers/built-in.o: In function `xen_callback_vector':
>> (.text+0x41238): undefined reference to `first_system_vector'
>>
>> alloc_intr_gate() calls alloc_system_vector(), which uses first_system_vector.
> 
> this patch should solve the issue:

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
> 
> alloc_system_vector: access first_system_vector when X86_LOCAL_APIC=y
> 
> Currently alloc_system_vector reads and writes first_system_vector
> unconditionally while first_system_vector is only defined when
> CONFIG_X86_LOCAL_APIC=y.
> This patch makes sure first_system_vector is accessed only in that case.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
> index 617bd56..f83e055 100644
> --- a/arch/x86/include/asm/desc.h
> +++ b/arch/x86/include/asm/desc.h
> @@ -341,8 +341,10 @@ static inline void alloc_system_vector(int vector)
>  {
>  	if (!test_bit(vector, used_vectors)) {
>  		set_bit(vector, used_vectors);
> +#if defined(CONFIG_X86_LOCAL_APIC)
>  		if (first_system_vector > vector)
>  			first_system_vector = vector;
> +#endif
>  	} else
>  		BUG();
>  }


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
