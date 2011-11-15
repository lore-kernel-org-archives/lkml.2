Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab1KOVtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:49:46 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60081 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab1KOVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:49:45 -0500
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.15.19
Date: Tue, 15 Nov 2011 13:49:32 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 3/9] rcu: Control rcutorture startup from
 kernel boot parameters
Message-ID: <20111115214932.GE31473@leaf>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
 <1321388885-11211-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321388885-11211-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 12:27:59PM -0800, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Currently, if rcutorture is built into the kernel, it must be manually
> started or started from an init script.  This is inconvenient for
> automated KVM testing, where it is good to be able to fully control
> rcutorture execution from the kernel parameters.  This patch therefore
> adds a module parameter named "rcutorture_runnable" that defaults
> to zero ("don't start automatically"), but which can be set to one
> to cause rcutorture to start up immediately during boot.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutorture.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 41802be..fd7a0e6 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -164,6 +164,8 @@ static int stutter_pause_test;
>  #define RCUTORTURE_RUNNABLE_INIT 0
>  #endif
>  int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
> +module_param(rcutorture_runnable, int, 0444);
> +MODULE_PARM_DESC(rcutorture_runnable, "Start rcutorture at boot");

Perhaps this should become a bool rather than an int, so that the kernel
would recognize various variations on the parameter value, such as "on"
or "true".

- Josh Triplett
