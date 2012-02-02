Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab2BBPyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:54:23 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:38185 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2BBPyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:54:22 -0500
Date: Thu, 2 Feb 2012 07:53:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Josh Triplett <josh@freedesktop.org>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 v2] kernel/rcutorture.c: Move call to PTR_ERR after
 reassignment
Message-ID: <20120202155338.GF2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1328194382-32465-1-git-send-email-Julia.Lawall@lip6.fr>
 <1328194382-32465-4-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328194382-32465-4-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020215-7282-0000-0000-000006257FE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Queued, thank you both!

							Thanx, Paul

On Thu, Feb 02, 2012 at 03:53:02PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> PTR_ERR should be called before its argument is cleared.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e,e1;
> constant c;
> @@
> 
> *e = c
> ... when != e = e1
>     when != &e
>     when != true IS_ERR(e)
> *PTR_ERR(e)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> Reported-by: Josh Triplett <josh@joshtriplett.org>
> 
> ---
> v2: correct commit message.
> 
>  kernel/rcutorture.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index a58ac28..4b3cd87 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -1450,12 +1450,15 @@ rcu_torture_onoff(void *arg)
>  static int __cpuinit
>  rcu_torture_onoff_init(void)
>  {
> +	int ret;
> +
>  	if (onoff_interval <= 0)
>  		return 0;
>  	onoff_task = kthread_run(rcu_torture_onoff, NULL, "rcu_torture_onoff");
>  	if (IS_ERR(onoff_task)) {
> +		ret = PTR_ERR(onoff_task);
>  		onoff_task = NULL;
> -		return PTR_ERR(onoff_task);
> +		return ret;
>  	}
>  	return 0;
>  }
> 

