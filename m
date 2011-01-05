Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab1AEODT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 09:03:19 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:61863 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026Ab1AEODS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 09:03:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPAEJE1GNBQZ/2dsb2JhbACkJ3S/FIVMBIRoi0o
Date: Wed, 5 Jan 2011 08:57:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracepoint: add __rcu annotation
Message-ID: <20110105135731.GA19922@Krystal>
References: <4D22D4F1.50505@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4D22D4F1.50505@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:57:04 up 272 days, 23:47,  4 users,  load average: 0.54, 0.46,
	0.30
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Add __rcu annotation to :
> 	(struct tracepoint)->funcs
> 
> signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Yep, makes sense!

Thanks,

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> ---
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index d3e4f87..e0e400d 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -32,7 +32,7 @@ struct tracepoint {
>  	int state;			/* State. */
>  	void (*regfunc)(void);
>  	void (*unregfunc)(void);
> -	struct tracepoint_func *funcs;
> +	struct tracepoint_func __rcu *funcs;
>  } __attribute__((aligned(32)));		/*
>  					 * Aligned on 32 bytes because it is
>  					 * globally visible and gcc happily

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
