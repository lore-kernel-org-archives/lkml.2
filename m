Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1GFR6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:58:14 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:41750 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753567Ab1GFR6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:58:11 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: WQkW4QUVM1nEXnHUGwbUqDFSDTYkVRNPV.S_QWvzkBDaMYp
 LkcfE3wTsO132LpEmRoaXYJhEZnaZS2FEwgv_V8h16bGak6TwtQHk.fqjhU6
 H4r5KZK5ULuTxflHFCrOjofWU.uXZpEqm67ehbtBU4NMi0HS8nvoKQm89eba
 gTHPJAzUDpyeSiP42QxEuQ1BGfbLWvDXyV5DqSMb_8HO22OHrYElbZh_4f.Y
 Hbrc.KTHRveCo2dX9P_cZN1UZ_vxCxUE5q7edY8icwNRbTnIqp5K7S73_W3i
 s8riyCFjzTgPqokkkWYo0B8GEOD7Z5CqqHJjSvdYSJX.uj0jOmxlA3CyHFgi
 LywWWnCTnc2bR9A7Up11mO3Qc
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Jul 2011 12:58:08 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: percpu: Fixup __this_cpu_xchg* operations
In-Reply-To: <alpine.DEB.2.00.1105201027000.5610@router.home>
Message-ID: <alpine.DEB.2.00.1107061257330.17624@router.home>
References: <alpine.DEB.2.00.1105201027000.5610@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you pick up this patch? Have not gotten a reply so far.

On Fri, 20 May 2011, Christoph Lameter wrote:

> Subject: percpu: Fixup __this_cpu_xchg* operations
>
> Somehow we got into a situation where the __this_cpu_xchg() operations were
> not defined in the same way as this_cpu_xchg() and friends. I had some build
> failures under 32 bit that were addressed by these fixes.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
>
> ---
>  arch/x86/include/asm/percpu.h |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> Index: linux-2.6/arch/x86/include/asm/percpu.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/percpu.h	2011-03-30 14:09:28.000000000 -0500
> +++ linux-2.6/arch/x86/include/asm/percpu.h	2011-03-30 14:10:16.000000000 -0500
> @@ -388,12 +388,9 @@ do {									\
>  #define __this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
>  #define __this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
>  #define __this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
> -/*
> - * Generic fallback operations for __this_cpu_xchg_[1-4] are okay and much
> - * faster than an xchg with forced lock semantics.
> - */
> -#define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
> -#define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
> +#define __this_cpu_xchg_1(pcp, val)	percpu_xchg_op(pcp, val)
> +#define __this_cpu_xchg_2(pcp, val)	percpu_xchg_op(pcp, val)
> +#define __this_cpu_xchg_4(pcp, val)	percpu_xchg_op(pcp, val)
>
>  #define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
>  #define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
> @@ -471,6 +468,7 @@ do {									\
>  #define __this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
>  #define this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
>  #define irqsafe_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
> +
>  #endif /* CONFIG_X86_CMPXCHG64 */
>
>  /*
> @@ -485,6 +483,8 @@ do {									\
>  #define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
>  #define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
>  #define __this_cpu_add_return_8(pcp, val) percpu_add_return_op(pcp, val)
> +#define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
> +#define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
>
>  #define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
>  #define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
>
