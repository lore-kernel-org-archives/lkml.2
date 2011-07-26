Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1GZR7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:59:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab1GZR7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:59:43 -0400
Message-ID: <4E2F0068.1080001@redhat.com>
Date: Tue, 26 Jul 2011 20:59:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andre Przywara <andre.przywara@amd.com>,
        Martin Pohlack <martin.pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
In-Reply-To: <1311340547-7861-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2011 04:15 PM, Borislav Petkov wrote:
> From: Borislav Petkov<borislav.petkov@amd.com>
>
> This patch provides performance tuning for the "Bulldozer" CPU. With its
> shared instruction cache there is a chance of generating an excessive
> number of cache cross-invalidates when running specific workloads on the
> cores of a compute module.
>
> This excessive amount of cross-invalidations can be observed if cache
> lines backed by shared physical memory alias in bits [14:12] of their
> virtual addresses, as those bits are used for the index generation.
>
> This patch addresses the issue by zeroing out the slice [14:12] of
> the file mapping's virtual address at generation time, thus forcing
> those bits the same for all mappings of a single shared library across
> processes and, in doing so, avoids instruction cache aliases.
>
> It also adds the kernel command line option
> "unalias_va_addr=(32|64|off)" with which virtual address unaliasing
> can be enabled for 32-bit or 64-bit x86 individually, or be completely
> disabled.
>
> This change leaves virtual region address allocation on other families
> and/or vendors unaffected.
>

Is it possible to derive the bit positions (and the need to mask them) 
from the cpuid description of the cache topology and sizes?

-- 
error compiling committee.c: too many arguments to function

