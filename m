Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0EGIpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:45:46 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:45416 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0EGIpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:45:44 -0400
Date: Fri, 7 May 2010 10:46:31 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk, ysato@users.sourceforge.jp, tony.luck@intel.com,
       dhowells@redhat.com, kyle@mcmartin.ca, benh@kernel.crashing.org,
       schwidefsky@de.ibm.com, jgarzik@pobox.com, hare@suse.de,
       felipe.balbi@nokia.com
Subject: Re: [PATCH 05/13] s390: removing redundant ifdefs
Message-ID: <20100507084631.GA2442@osiris.boeblingen.de.ibm.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
 <1273167377-14270-6-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273167377-14270-6-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 07:36:09PM +0200, Jiri Olsa wrote:
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  arch/s390/include/asm/processor.h |    5 -----
>  arch/s390/kernel/vdso.c           |    4 ----
>  2 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
> index 73e2598..ced1714 100644
> --- a/arch/s390/include/asm/processor.h
> +++ b/arch/s390/include/asm/processor.h
> @@ -52,8 +52,6 @@ extern int get_cpu_capability(unsigned int *);
> 
>  #endif /* __s390x__ */
> 
> -#ifdef __KERNEL__
> -
>  #ifndef __s390x__
>  #define STACK_TOP		(1UL << 31)
>  #define STACK_TOP_MAX		(1UL << 31)
> @@ -62,9 +60,6 @@ extern int get_cpu_capability(unsigned int *);
>  #define STACK_TOP_MAX		(1UL << 42)
>  #endif /* __s390x__ */
> 
> -
> -#endif
> -

Dunno. This looks a bit pointless. After all any ifdef __KERNEL__ is not
needed for this header file since its not exported.
So removing this ifdef and keep the other one doesn't make too much sense.

> diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
> index 6bc9c19..6b83870 100644
> --- a/arch/s390/kernel/vdso.c
> +++ b/arch/s390/kernel/vdso.c
> @@ -102,11 +102,7 @@ static void vdso_init_per_cpu_data(int cpu, struct vdso_per_cpu_data *vpcd)
>  /*
>   * Allocate/free per cpu vdso data.
>   */
> -#ifdef CONFIG_64BIT
>  #define SEGMENT_ORDER	2
> -#else
> -#define SEGMENT_ORDER	1
> -#endif

An identical patch for this hunk is alread pending in the git s390 tree.
