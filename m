Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1JQBvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:51:18 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52680 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1JQBvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:51:17 -0400
X-Originating-IP: 217.70.178.129
X-Originating-IP: 50.43.15.19
Date: Sun, 16 Oct 2011 18:51:02 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 38/55] rcu: Prohibit grace periods during
 early boot
Message-ID: <20111017015101.GF19421@leaf>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-38-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315332049-2604-38-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 11:00:32AM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Greater use of RCU during early boot (before the scheduler is operating)
> is causing RCU to attempt to start grace periods during that time, which
> in turn is resulting in both RCU and the callback functions attempting
> to use the scheduler before it is ready.
> 
> This commit prevents these problems by prohibiting RCU grace periods
> until after the scheduler has spawned the first non-idle task.

As with patch 36, this seems like a good candidate for jump labels.

- Josh Triplett
