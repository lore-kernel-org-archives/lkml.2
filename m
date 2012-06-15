Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab2FOUvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:51:09 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56876 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab2FOUvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:51:08 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 13:50:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 07/14] key: Remove extraneous parentheses
 from rcu_assign_keypointer()
Message-ID: <20120615205055.GK31184@leaf>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339791195-26389-7-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339791195-26389-7-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 01:13:08PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit removes the extraneous parentheses from rcu_assign_keypointer()
> so that rcu_assign_pointer() can be wrapped in do-while.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  include/linux/key.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/key.h b/include/linux/key.h
> index 4cd22ed..6fafcf4 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -303,7 +303,7 @@ static inline bool key_is_instantiated(const struct key *key)
>  				   rwsem_is_locked(&((struct key *)(KEY))->sem)))
>  
>  #define rcu_assign_keypointer(KEY, PAYLOAD)				\
> -	(rcu_assign_pointer((KEY)->payload.rcudata, PAYLOAD))
> +	rcu_assign_pointer((KEY)->payload.rcudata, PAYLOAD)
>  
>  #ifdef CONFIG_SYSCTL
>  extern ctl_table key_sysctls[];
> -- 
> 1.7.8
> 
