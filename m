Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1LLQBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:01:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab1LLQB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:01:29 -0500
Date: Mon, 12 Dec 2011 11:01:07 -0500
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v3 1/3] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Message-ID: <20111212160107.GS1669@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D0F@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D0F@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 05:09:32PM -0500, Seiji Aguchi wrote:
> This patch just moves kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop
> for serializing logging process via smp_send_stop.
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

This is a useful first step towards serializing the kmsg_dump framework.
It takes a similar approach to kdump and makes writing code here easier.

Acked-by: Don Zickus <dzickus@redhat.com>

> 
> ---
>  kernel/panic.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index b265936..c8e0ae8 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -88,8 +88,6 @@ NORET_TYPE void panic(const char * fmt, ...)
>  	 */
>  	crash_kexec(NULL);
>  
> -	kmsg_dump(KMSG_DUMP_PANIC);
> -
>  	/*
>  	 * Note smp_send_stop is the usual smp shutdown function, which
>  	 * unfortunately means it may not be hardened to work in a panic
> @@ -97,6 +95,8 @@ NORET_TYPE void panic(const char * fmt, ...)
>  	 */
>  	smp_send_stop();
>  
> +	kmsg_dump(KMSG_DUMP_PANIC);
> +
>  	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>  
>  	bust_spinlocks(0);
> -- 1.7.1
