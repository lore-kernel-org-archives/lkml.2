Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1JQBoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:44:09 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56920 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1JQBoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:44:07 -0400
X-Originating-IP: 217.70.178.137
X-Originating-IP: 50.43.15.19
Date: Sun, 16 Oct 2011 18:43:50 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 31/55] rcu: Make rcu_implicit_dynticks_qs()
 locals be correct size
Message-ID: <20111017014350.GD19421@leaf>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-31-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315332049-2604-31-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 11:00:25AM -0700, Paul E. McKenney wrote:
> When the ->dynticks field in the rcu_dynticks structure changed to an
> atomic_t, its size on 64-bit systems changed from 64 bits to 32 bits.
> The local variables in rcu_implicit_dynticks_qs() need to change as
> well, hence this commit.

If an atomic_t always holds 32-bits, which it appears to, then shouldn't
this use u32 rather than unsigned int?

- Josh Triplett
