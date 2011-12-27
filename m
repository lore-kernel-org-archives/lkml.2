Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1L0RaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 12:30:18 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57724 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab1L0RaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 12:30:16 -0500
Date: Tue, 27 Dec 2011 09:29:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] rcu: add missing __cpuinit annotation in
 rcutorture code
Message-ID: <20111227172951.GC2889@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1324994666-4080-1-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324994666-4080-1-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11122717-6078-0000-0000-00000615B201
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 03:04:26PM +0100, Heiko Carstens wrote:
> "rcu: Add rcutorture CPU-hotplug capability" adds cpu hotplug operations
> to the rcutorture code but produces a false positive warning about section
> mismatches:
> 
> WARNING: vmlinux.o(.text+0x1e420c): Section mismatch in reference from the
> 	 function rcu_torture_onoff() to the function .cpuinit.text:cpu_up()
> 	 The function rcu_torture_onoff() references
> 	 the function __cpuinit cpu_up().
> 	 This is often because rcu_torture_onoff lacks a __cpuinit
> 	 annotation or the annotation of cpu_up is wrong.
> 
> Just add a __cpuinit annotation so the warning goes away.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Thank you -- queued on my local -rcu tree.

							Thanx, Paul

> ---
>  kernel/rcutorture.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index e29edc3..a58ac28 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -1399,7 +1399,7 @@ rcu_torture_shutdown(void *arg)
>   * Execute random CPU-hotplug operations at the interval specified
>   * by the onoff_interval.
>   */
> -static int
> +static int __cpuinit
>  rcu_torture_onoff(void *arg)
>  {
>  	int cpu;
> @@ -1447,7 +1447,7 @@ rcu_torture_onoff(void *arg)
>  	return 0;
>  }
> 
> -static int
> +static int __cpuinit
>  rcu_torture_onoff_init(void)
>  {
>  	if (onoff_interval <= 0)
> -- 
> 1.7.7.3
> 

