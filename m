Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab1J1S20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 14:28:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab1J1S2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 14:28:24 -0400
Date: Fri, 28 Oct 2011 14:27:47 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Chen, Gong" <gong.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v2 -next 1/2] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Message-ID: <20111028182747.GD3452@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C576122A8@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C576122A8@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 05:20:07PM -0400, Seiji Aguchi wrote:
> This patch is just moving kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop
> for serializing logging process via smp_send_stop.

I feel it is good to always serialize the logging when we are panic'ing.
So this patch is a step in the right direction.

Acked-by: Don Zickus <dzickus@redhat.com>

> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> 
> ---
>  kernel/panic.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index d7bb697..41bf6ad 100644
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
