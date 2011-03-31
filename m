Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab1CaP4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:56:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39172 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507Ab1CaP4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:56:43 -0400
Message-ID: <4D94A417.80508@kernel.org>
Date: Thu, 31 Mar 2011 08:56:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip:x86/mm] x86-64, NUMA: Remove custom phys_to_nid()
 implementation
References: <20110331135744.GE3385@htj.dyndns.org>
In-Reply-To: <20110331135744.GE3385@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D94A426.007D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 06:57 AM, Tejun Heo wrote:
> phys_to_nid() maps physical address to NUMA node id.  This is
> implemented by building perfect hash in compute_hash_shift() during
> initialization.
>
> However, with SPARSE memory model, the nid is encoded in page flags.
> The perfect hash implementation was for DISCONTIG memory model which
> got removed years ago by b263295dbf (x86: 64-bit, make sparsemem
> vmemmap the only memory model).
>
> So, the perfect hash ends up being used only during initialization
> when the core SPARSE code already provides perfectly acceptable
> generic early_pfn_to_nid() implementation.
>
> Drop phys_to_nid() and use the generic ealry_pfn_to_nid() instead.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Christoph Lameter<cl@linux-foundation.org>
> Cc: Ingo Molnar<mingo@redhat.com>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> ---
> If no one objects, will route through x86-mm.  Thanks.
>
>   arch/x86/Kconfig                 |    4 -
>   arch/x86/include/asm/mmzone_64.h |   23 -------
>   arch/x86/mm/numa_64.c            |  123 ---------------------------------------
>   3 files changed, 1 insertion(+), 149 deletions(-)

good finding.

Acked-by: Yinghai Lu <yinghai@kernel.org>
