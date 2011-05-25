Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab1EYX6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:58:34 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:47464 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754349Ab1EYX6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:58:33 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-c5-4ddd97a295f3
Message-ID: <4DDD97A2.5030304@mit.edu>
Date: Wed, 25 May 2011 19:58:26 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision v2
References: <1306351948-23382-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1306351948-23382-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42IR4hTV1l00/a6vwaqXEhbHJ1haHLn2nd3i
	8q45bBY/NjxmdWDxmL/zI6PHplWdbB7zTgZ6fN4kF8ASxWWTkpqTWZZapG+XwJUx6+wk5oJH
	rBXnjy9ib2CcytLFyMkhIWAiseLmAWYIW0ziwr31bF2MXBxCAvsYJebs2sIM4WxglJi0/SsL
	hHOBSaJl/2ZWkBZeATWJ/o8PmEBsFgFVif3Pe8HibAIqEh1LIeKiApUS79ZsYYeoF5Q4OfMJ
	0CAODhGgmuOn+EDCzAJREhcufmUHCQsLOEpsnq0CYgoJOEv8fu4PUsEp4CJx9Op3JpAws4C1
	xLfdRRCN8hLb385hnsAoOAvJ+FkIVbOQVC1gZF7FKJuSW6Wbm5iZU5yarFucnJiXl1qka6yX
	m1mil5pSuokRHNqSfDsYvx5UOsQowMGoxMPbqHDXV4g1say4MvcQoyQHk5Io74WpQCG+pPyU
	yozE4oz4otKc1OJDjBIczEoivE0sQDnelMTKqtSifJiUNAeLkjjvTEl1XyGB9MSS1OzU1ILU
	IpisDAeHkgQvIzCGhQSLUtNTK9Iyc0oQ0kwcnCDDeYCG75sGMry4IDG3ODMdIn+KUVFKnJcT
	pFkAJJFRmgfXC0s9rxjFgV4R5hUCaecBpi247ldAg5mABkv8vQkyuCQRISXVwFi7tpSlIWlJ
	vlPyDLeVemyqPmKb/7xz1uf7Ixw7JSQmoiF77kyOLk1tZ76Poqf+vzcqPLsma3nSZJeJP7+8
	1T4Rvtr71FmdjlNTWNlF1T5q/4i5+pNrbsOnUwmV+3+na+w1qO2KO6EuYXdMSeleIANXd4pL
	XiBfufuWwmctbV9j1U+ovZy2WYmlOCPRUIu5qDgRAPKtscgYAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 03:32 PM, Andi Kleen wrote:
> From: Andi Kleen<ak@linux.intel.com>
>

[...]

>
> I had to add a memory barrier to native_cpuid to prevent it being
> optimized away when the result is not used.
>

[...]

> @@ -179,7 +181,8 @@ static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
>   	      "=b" (*ebx),
>   	      "=c" (*ecx),
>   	      "=d" (*edx)
> -	    : "0" (*eax), "2" (*ecx));
> +	    : "0" (*eax), "2" (*ecx)
> +	    : "memory");
>   }
>

[...]

> +		cpuid_eax(1);

I'm confused.  Doesn't "asm volatile" (in native_cpuid) mean "don't 
optimize me out"?

I can't reproduce the disappearance of the cpuid instruction when I 
copied and pasted all the macros.

--Andy
