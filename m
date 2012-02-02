Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2BBFxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 00:53:36 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46259 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2BBFxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 00:53:35 -0500
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 21:53:11 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH RFC tip/core/rcu 31/41] rcu: Add CPU-stall capability to
 rcutorture
Message-ID: <20120202055310.GR29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-31-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-31-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:49AM -0800, Paul E. McKenney wrote:
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> +/* Spawn CPU-stall kthread, if stall_cpu specified. */
> +static int __init rcu_torture_stall_init(void)
> +{
> +	if (stall_cpu <= 0)
> +		return 0;
> +	stall_task = kthread_run(rcu_torture_stall, NULL, "rcu_torture_stall");
> +	if (IS_ERR(stall_task)) {
> +		stall_task = NULL;
> +		return PTR_ERR(stall_task);

This seems...unlikely to produce the desired result. :)

A quick check turns up the same bug in rcutorture_onoff_init.

This suggests a possible Coccinelle check, for uses of PTR_ERR(foo) after
foo = (any constant other than ERR_PTR(foo)).

- Josh Triplett
