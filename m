Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1K3F7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 00:59:49 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37372 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1K3F7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 00:59:48 -0500
Message-ID: <4ED5C640.8030102@linux.vnet.ibm.com>
Date: Wed, 30 Nov 2011 11:29:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: 3.2-rc2 freezes on boot for AMD K6 - bisected to commit bcb80e53877c2045d9e52f4a71372c3fe6501f6f
References: <4ED5B70F.606@lwfinger.net>
In-Reply-To: <4ED5B70F.606@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11113005-8256-0000-0000-00000054AD9F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2011 10:24 AM, Larry Finger wrote:

> I have an ancient laptop with an AMD-K6 CPU that freezes on boot with
> 3.2-rc2. The problem was bisected to commit bcb80e53877c2.
> 
> The cpuinfo for this box is:
> 
>>> cpu.1: cpuinfo
> ----- /proc/cpuinfo -----
>   processor     : 0
>   vendor_id     : AuthenticAMD
>   cpu family    : 5
>   model         : 8
>   model name    : AMD-K6(tm) 3D processor
>   stepping      : 12
>   cpu MHz               : 428.804
>   cache size    : 64 KB
>   fdiv_bug      : no
>   hlt_bug               : no
>   f00f_bug      : no
>   coma_bug      : no
>   fpu           : yes
>   fpu_exception : yes
>   cpuid level   : 1
>   wp            : yes
>   flags         : fpu vme de pse tsc msr cx8 pge mmx syscall 3dnow
> k6_mtrr up
>   bogomips      : 857.60
>   clflush size  : 32
>   cache_alignment       : 32
>   address sizes : 32 bits physical, 32 bits virtual
>   power management:
> 
> ----- /proc/cpuinfo end -----
> 
> This patch is quite simple, thus it appears that rdmsr() is OK, but that
> rdmsr_safe() is not.
> 
> I am happy to provide any other info regarding this box.
> 
 

Hi Larry,

Can you please try out the patch posted in
https://lkml.org/lkml/2011/11/28/178 ?

This patch will be available in mainline kernel from -rc4.
https://lkml.org/lkml/2011/11/28/457

-- 
Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

