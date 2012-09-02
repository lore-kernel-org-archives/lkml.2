Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab2IBGGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 02:06:06 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50240 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab2IBGGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 02:06:03 -0400
X-Originating-IP: 217.70.178.150
X-Originating-IP: 50.43.46.74
Date: Sat, 1 Sep 2012 23:05:54 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 11/23] rcu: Adjust debugfs tracing for
 kthread-based quiescent-state forcing
Message-ID: <20120902060554.GC7767@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-11-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-11-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:26AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Moving quiescent-state forcing into a kthread dispenses with the need
> for the ->n_rp_need_fqs field, so this commit removes it.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  Documentation/RCU/trace.txt |   43 ++++++++++++++++---------------------------
>  kernel/rcutree.h            |    1 -
>  kernel/rcutree_trace.c      |    3 +--
>  3 files changed, 17 insertions(+), 30 deletions(-)
> 
> diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
> index f6f15ce..672d190 100644
> --- a/Documentation/RCU/trace.txt
> +++ b/Documentation/RCU/trace.txt
> @@ -333,23 +333,23 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
>  The output of "cat rcu/rcu_pending" looks as follows:
>  
>  rcu_sched:
> -  0 np=255892 qsp=53936 rpq=85 cbr=0 cng=14417 gpc=10033 gps=24320 nf=6445 nn=146741
> -  1 np=261224 qsp=54638 rpq=33 cbr=0 cng=25723 gpc=16310 gps=2849 nf=5912 nn=155792
> -  2 np=237496 qsp=49664 rpq=23 cbr=0 cng=2762 gpc=45478 gps=1762 nf=1201 nn=136629
> -  3 np=236249 qsp=48766 rpq=98 cbr=0 cng=286 gpc=48049 gps=1218 nf=207 nn=137723
> -  4 np=221310 qsp=46850 rpq=7 cbr=0 cng=26 gpc=43161 gps=4634 nf=3529 nn=123110
> -  5 np=237332 qsp=48449 rpq=9 cbr=0 cng=54 gpc=47920 gps=3252 nf=201 nn=137456
> -  6 np=219995 qsp=46718 rpq=12 cbr=0 cng=50 gpc=42098 gps=6093 nf=4202 nn=120834
> -  7 np=249893 qsp=49390 rpq=42 cbr=0 cng=72 gpc=38400 gps=17102 nf=41 nn=144888
> +  0 np=255892 qsp=53936 rpq=85 cbr=0 cng=14417 gpc=10033 gps=24320 nn=146741
> +  1 np=261224 qsp=54638 rpq=33 cbr=0 cng=25723 gpc=16310 gps=2849 nn=155792
> +  2 np=237496 qsp=49664 rpq=23 cbr=0 cng=2762 gpc=45478 gps=1762 nn=136629
> +  3 np=236249 qsp=48766 rpq=98 cbr=0 cng=286 gpc=48049 gps=1218 nn=137723
> +  4 np=221310 qsp=46850 rpq=7 cbr=0 cng=26 gpc=43161 gps=4634 nn=123110
> +  5 np=237332 qsp=48449 rpq=9 cbr=0 cng=54 gpc=47920 gps=3252 nn=137456
> +  6 np=219995 qsp=46718 rpq=12 cbr=0 cng=50 gpc=42098 gps=6093 nn=120834
> +  7 np=249893 qsp=49390 rpq=42 cbr=0 cng=72 gpc=38400 gps=17102 nn=144888
>  rcu_bh:
> -  0 np=146741 qsp=1419 rpq=6 cbr=0 cng=6 gpc=0 gps=0 nf=2 nn=145314
> -  1 np=155792 qsp=12597 rpq=3 cbr=0 cng=0 gpc=4 gps=8 nf=3 nn=143180
> -  2 np=136629 qsp=18680 rpq=1 cbr=0 cng=0 gpc=7 gps=6 nf=0 nn=117936
> -  3 np=137723 qsp=2843 rpq=0 cbr=0 cng=0 gpc=10 gps=7 nf=0 nn=134863
> -  4 np=123110 qsp=12433 rpq=0 cbr=0 cng=0 gpc=4 gps=2 nf=0 nn=110671
> -  5 np=137456 qsp=4210 rpq=1 cbr=0 cng=0 gpc=6 gps=5 nf=0 nn=133235
> -  6 np=120834 qsp=9902 rpq=2 cbr=0 cng=0 gpc=6 gps=3 nf=2 nn=110921
> -  7 np=144888 qsp=26336 rpq=0 cbr=0 cng=0 gpc=8 gps=2 nf=0 nn=118542
> +  0 np=146741 qsp=1419 rpq=6 cbr=0 cng=6 gpc=0 gps=0 nn=145314
> +  1 np=155792 qsp=12597 rpq=3 cbr=0 cng=0 gpc=4 gps=8 nn=143180
> +  2 np=136629 qsp=18680 rpq=1 cbr=0 cng=0 gpc=7 gps=6 nn=117936
> +  3 np=137723 qsp=2843 rpq=0 cbr=0 cng=0 gpc=10 gps=7 nn=134863
> +  4 np=123110 qsp=12433 rpq=0 cbr=0 cng=0 gpc=4 gps=2 nn=110671
> +  5 np=137456 qsp=4210 rpq=1 cbr=0 cng=0 gpc=6 gps=5 nn=133235
> +  6 np=120834 qsp=9902 rpq=2 cbr=0 cng=0 gpc=6 gps=3 nn=110921
> +  7 np=144888 qsp=26336 rpq=0 cbr=0 cng=0 gpc=8 gps=2 nn=118542
>  
>  As always, this is once again split into "rcu_sched" and "rcu_bh"
>  portions, with CONFIG_TREE_PREEMPT_RCU kernels having an additional
> @@ -377,17 +377,6 @@ o	"gpc" is the number of times that an old grace period had
>  o	"gps" is the number of times that a new grace period had started,
>  	but this CPU was not yet aware of it.
>  
> -o	"nf" is the number of times that this CPU suspected that the
> -	current grace period had run for too long, and thus needed to
> -	be forced.
> -
> -	Please note that "forcing" consists of sending resched IPIs
> -	to holdout CPUs.  If that CPU really still is in an old RCU
> -	read-side critical section, then we really do have to wait for it.
> -	The assumption behing "forcing" is that the CPU is not still in
> -	an old RCU read-side critical section, but has not yet responded
> -	for some other reason.
> -
>  o	"nn" is the number of times that this CPU needed nothing.  Alert
>  	readers will note that the rcu "nn" number for a given CPU very
>  	closely matches the rcu_bh "np" number for that same CPU.  This
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 1f26b1f..36916df 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -312,7 +312,6 @@ struct rcu_data {
>  	unsigned long n_rp_cpu_needs_gp;
>  	unsigned long n_rp_gp_completed;
>  	unsigned long n_rp_gp_started;
> -	unsigned long n_rp_need_fqs;
>  	unsigned long n_rp_need_nothing;
>  
>  	/* 6) _rcu_barrier() and OOM callbacks. */
> diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> index abffb48..f54f0ce 100644
> --- a/kernel/rcutree_trace.c
> +++ b/kernel/rcutree_trace.c
> @@ -386,10 +386,9 @@ static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
>  		   rdp->n_rp_report_qs,
>  		   rdp->n_rp_cb_ready,
>  		   rdp->n_rp_cpu_needs_gp);
> -	seq_printf(m, "gpc=%ld gps=%ld nf=%ld nn=%ld\n",
> +	seq_printf(m, "gpc=%ld gps=%ld nn=%ld\n",
>  		   rdp->n_rp_gp_completed,
>  		   rdp->n_rp_gp_started,
> -		   rdp->n_rp_need_fqs,
>  		   rdp->n_rp_need_nothing);
>  }
>  
> -- 
> 1.7.8
> 
