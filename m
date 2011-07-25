Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab1GYQVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 12:21:55 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42434 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1GYQVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 12:21:53 -0400
Date: Mon, 25 Jul 2011 09:21:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
Message-ID: <20110725162133.GI2327@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110721164325.231521704@google.com>
 <1311605881.24752.2.camel@twins>
 <1311606041.24752.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311606041.24752.3.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 05:00:41PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-07-25 at 16:58 +0200, Peter Zijlstra wrote:
> > +               rcu_read_lock();
> > +               ret = walk_tg_tree_from(tg, tg_set_cfs_period_down, NULL, &period);
> > +               rcu_read_unlock(); 
> 
> rcu over a mutex doesn't really work in mainline, bah.. 

SRCU can handle that situation, FWIW.  But yes, blocking in an RCU
read-side critical section is a no-no.

							Thanx, Paul
