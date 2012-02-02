Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2BBQzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:55:09 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:54079 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752874Ab2BBQzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:55:07 -0500
Message-ID: <4F2ACD7F.2020506@xenotime.net>
Date: Thu, 02 Feb 2012 09:53:03 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-edac@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 1 (mce_amd.c)
References: <20120201171643.cbf8263eded709a75e92f4ad@canb.auug.org.au> <4F298A6C.6010101@xenotime.net> <20120202142628.GA1052@aftab>
In-Reply-To: <20120202142628.GA1052@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 06:26 AM, Borislav Petkov wrote:
> On Wed, Feb 01, 2012 at 10:54:36AM -0800, Randy Dunlap wrote:
>> On 01/31/2012 10:16 PM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20120131:
>>
>>
>> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_shared_map'
> 
> Yeah, -rc2 has that problem too with your randconfig. The issue is with
> CONFIG_SMP not being set.
> 
> The following chunk should cure it:


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> --
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5bed94e..63fcb8a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -897,7 +897,7 @@ config X86_MCE_INTEL
>  config X86_MCE_AMD
>  	def_bool y
>  	prompt "AMD MCE features"
> -	depends on X86_MCE && X86_LOCAL_APIC
> +	depends on X86_MCE && X86_LOCAL_APIC && SMP
>  	---help---
>  	   Additional support for AMD specific MCE features such as
>  	   the DRAM Error Threshold.
> --
> 
> Thanks.
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
