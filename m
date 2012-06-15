Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab2FOUsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:48:30 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54000 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab2FOUs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:48:29 -0400
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 13:48:14 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 04/14] rcu: Add a gcc-style structure
 initializer for RCU pointers
Message-ID: <20120615204813.GI31184@leaf>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339791195-26389-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339791195-26389-4-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 01:13:05PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> RCU_INIT_POINTER() returns a value that is never used, and which should
> be abolished due to terminal ugliness:
> 
> 	q = RCU_INIT_POINTER(global_p, p);
> 
> However, there are two uses that cannot be handled by a do-while
> formulation because they do gcc-style initialization:
> 
> 	RCU_INIT_POINTER(.real_cred, &init_cred),
> 	RCU_INIT_POINTER(.cred, &init_cred),
> 
> This usage is clever, but not necessarily the nicest approach.  This
> commit therefore creates an INIT_RCU_POINTER() macro that is specifically
> designed for gcc-style initialization.

The concept seems fine, but the names seem entirely non-obvious.
RCU_INIT_POINTER versus INIT_RCU_POINTER?

- Josh Triplett
