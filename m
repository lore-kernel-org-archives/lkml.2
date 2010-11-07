Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0KGVUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:20:49 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49703 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab0KGVUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:20:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e6sFfNRYcy/yoasvlONVkVMrC5G/YwQyVuv1BoJqVnSlk9aw+Wzv73kqA+jC3gmWtv
         7E7wBJKCYEln/RH2/R8vU522xSTW2Er60x7srogUVHWUKYqzdWArCYq3186SWqAe+N9k
         lm9V8GJheOe8a/APpUct38Jv/EACGsuRTRrR0=
Date: Mon, 8 Nov 2010 00:20:45 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: Re: [PATCH] x86: fix apic.h unused but set warnings
Message-ID: <20101107212045.GC13175@lenovo>
References: <1289159606-17417-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289159606-17417-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 08:53:26PM +0100, Andi Kleen wrote:
... 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 286de34..9c4e06b 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -141,12 +141,12 @@ static inline void native_apic_msr_write(u32 reg, u32 v)
>  
>  static inline u32 native_apic_msr_read(u32 reg)
>  {
> -	u32 low, high;
> +	u32 low;
>  
>  	if (reg == APIC_DFR)
>  		return -1;
>  
> -	rdmsr(APIC_BASE_MSR + (reg >> 4), low, high);
> +	rdmsrl(APIC_BASE_MSR + (reg >> 4), low);
>  	return low;
>  }

 At least the former code _didn't_ hide the details of which
part of 'long long' value we need. Would not

 u64 val;
 rdmsrl(APIC_BASE_MSR + (reg >> 4), val);
 return (u32)val;

be more clear?

 Cyrill
