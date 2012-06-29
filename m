Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab2F2ORF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:17:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab2F2ORD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:17:03 -0400
Message-ID: <4FEDB8AC.4000209@redhat.com>
Date: Fri, 29 Jun 2012 10:16:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 04/40] xen: document Xen is using an unused bit for the
 pagetables
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-5-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-5-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:55 AM, Andrea Arcangeli wrote:
> Xen has taken over the last reserved bit available for the pagetables
> which is set through ioremap, this documents it and makes the code
> more readable.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>
> ---
>   arch/x86/include/asm/pgtable_types.h |   11 +++++++++--
>   1 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index 013286a..b74cac9 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -17,7 +17,7 @@
>   #define _PAGE_BIT_PAT		7	/* on 4KB pages */
>   #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
>   #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
> -#define _PAGE_BIT_IOMAP		10	/* flag used to indicate IO mapping */
> +#define _PAGE_BIT_UNUSED2	10

Considering that Xen is using it, it is not really
unused, is it?

Not that I can think of a better name, considering
you are using this bit for something else at the PMD
level...

-- 
All rights reversed
