Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab1GKBYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 21:24:43 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:51760 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab1GKBYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 21:24:39 -0400
Date: Sun, 10 Jul 2011 21:24:29 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] jbd2,rcu: correctly use RCU
Message-ID: <20110711012429.GD28763@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ec67960d0864680d18a43ec5275baba3f6e1dd94.1308131436.git.laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec67960d0864680d18a43ec5275baba3f6e1dd94.1308131436.git.laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 09:47:04AM +0800, Lai Jiangshan wrote:
> In read site, we need to use local_ptr = rcu_dereference(),
> and then use this local_ptr to read the content.
> 
> In update site, we should assign/publish the new object/pointer after
> the content of the new object/pointer is fully initialized,
> and we can't not touch the object after the pointer assignment.
> rcu_assign_pointer() is need for the assignement.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Actually, after thinking about this some more, I think I'm going to
just change the jbd2 events to simply print MAJOR(__entry->dev) and
MINOR(__entry->dev).  Otherwise, the perf tool stops dies and stops
interpreting the trace points when it tries to interpret
"jbd2_dev_to_name(REC->dev)" in the print format.

So I'll just drop jbd2_dev_to_name() completely for the jbd2
tracepoints.  It's not worth it.

	      				- Ted
