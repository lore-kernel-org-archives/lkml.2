Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab0LJVOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:14:50 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:60460 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0LJVOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:14:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D2Sv6ZX5Ad6R098sUkNp+6T5cIoTt2TyEjYuBzIjvEHZJ6bNyncDTlcDtcI7gYcYwJ
         y+qcbWwZlReelxo7IXVV2jYPx0iioFR2IxAYJi2U2oyNDghy9EMaJ+7tANQG+jik8RI5
         607N1U1xQTAxTbQSgvz7vmO/pz1pnN0GVtbSQ=
Date: Fri, 10 Dec 2010 22:14:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/2 v2] rcu: Fix series of spurious RCU softirqs
Message-ID: <20101210211439.GA1713@nowhere>
References: <1292015471-19227-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292015471-19227-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Lai in Cc, I forgot my script doesn't handle Suggested-by: tags :)

On Fri, Dec 10, 2010 at 10:11:09PM +0100, Frederic Weisbecker wrote:
> Hi,
> 
> Following Lai's idea.
> 
> An example of such series of spurious softirqs:
> 
> http://tglx.de/~fweisbec/trace_rcu_softirq.txt
> 
> In that example, the rcu softirq is raised at every tick
> during 20 secs (was perhaps more, but the trace snapshot happened
> during 20 secs). It happens randomly.
> 
> Ah and it survived several hours of rcutorture (with rcu cpu stall
> detection).
> 
> Thanks.
> 
> Frederic Weisbecker (2):
>   rcu: Stop chasing QS if another CPU did it for us
>   rcu: Keep gpnum and completed fields synchronized
> 
>  kernel/rcutree.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> -- 
> 1.7.3.2
> 
