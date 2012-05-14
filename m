Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab2ENVIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:08:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64045 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab2ENVIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:08:09 -0400
Subject: Re: [PATCH] net: codel: fix build errors
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: edumazet@google.com, dave.taht@bufferbloat.net, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1337015687-17693-1-git-send-email-levinsasha928@gmail.com>
References: <1337015687-17693-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 May 2012 23:08:03 +0200
Message-ID: <1337029683.8512.626.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 19:14 +0200, Sasha Levin wrote:
> Fix the following build error:
> 
> net/sched/sch_fq_codel.c: In function 'fq_codel_dump_stats':
> net/sched/sch_fq_codel.c:464:3: error: unknown field 'qdisc_stats' specified in initializer
> net/sched/sch_fq_codel.c:464:3: warning: missing braces around initializer
> net/sched/sch_fq_codel.c:464:3: warning: (near initialization for 'st.<anonymous>')
> net/sched/sch_fq_codel.c:465:3: error: unknown field 'qdisc_stats' specified in initializer
> net/sched/sch_fq_codel.c:465:3: warning: excess elements in struct initializer
> net/sched/sch_fq_codel.c:465:3: warning: (near initialization for 'st')
> net/sched/sch_fq_codel.c:466:3: error: unknown field 'qdisc_stats' specified in initializer
> net/sched/sch_fq_codel.c:466:3: warning: excess elements in struct initializer
> net/sched/sch_fq_codel.c:466:3: warning: (near initialization for 'st')
> net/sched/sch_fq_codel.c:467:3: error: unknown field 'qdisc_stats' specified in initializer
> net/sched/sch_fq_codel.c:467:3: warning: excess elements in struct initializer
> net/sched/sch_fq_codel.c:467:3: warning: (near initialization for 'st')
> make[1]: *** [net/sched/sch_fq_codel.o] Error 1
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  include/linux/pkt_sched.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/pkt_sched.h b/include/linux/pkt_sched.h
> index 32aef0a..c304eda 100644
> --- a/include/linux/pkt_sched.h
> +++ b/include/linux/pkt_sched.h
> @@ -732,7 +732,9 @@ struct tc_fq_codel_xstats {
>  	union {
>  		struct tc_fq_codel_qd_stats qdisc_stats;
>  		struct tc_fq_codel_cl_stats class_stats;
> -	};
> +	} u;
> +#define qdisc_stats u.qdisc_stats
> +#define class_stats u.class_stats
>  };
>  

Anonymous unions are fine, we use them a lot in kernel.

Please fix the initializers instead in fq_codel_dump_stats(), because
these two #define are not very nice.




