Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab2BBAsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:48:51 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42728 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab2BBAsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:48:50 -0500
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 16:48:29 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC idle] Make arm, sh, and x86 stop using RCU when idle
Message-ID: <20120202004828.GC29058@leaf>
References: <20120202004253.GA10946@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202004253.GA10946@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 04:42:53PM -0800, Paul E. McKenney wrote:
> RCU's shiny new diagnostics (thank you, Frederic!) for using RCU when idle
> located a few problems in arm, sh, and x86.  This patch series contains
> alleged fixes for these problems.  And they are real problems -- if RCU
> believes that the CPU is idle, it is ignoring it.  Which means that the
> idle CPU can say "rcu_read_lock()" all it like, but there will be no
> useful effect.

Having to put these calls down in every idle driver seems like such an
ugly layering violation.  Not that I have a better alternative to
suggest...

- Josh Triplett
