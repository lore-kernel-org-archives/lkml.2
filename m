Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab1GYQ2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 12:28:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43149 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1GYQ2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 12:28:53 -0400
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
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
In-Reply-To: <20110725162133.GI2327@linux.vnet.ibm.com>
References: <20110721164325.231521704@google.com>
	 <1311605881.24752.2.camel@twins> <1311606041.24752.3.camel@twins>
	 <20110725162133.GI2327@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 25 Jul 2011 18:28:31 +0200
Message-ID: <1311611311.24752.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 09:21 -0700, Paul E. McKenney wrote:
> On Mon, Jul 25, 2011 at 05:00:41PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-07-25 at 16:58 +0200, Peter Zijlstra wrote:
> > > +               rcu_read_lock();
> > > +               ret = walk_tg_tree_from(tg, tg_set_cfs_period_down, NULL, &period);
> > > +               rcu_read_unlock(); 
> > 
> > rcu over a mutex doesn't really work in mainline, bah.. 
> 
> SRCU can handle that situation, FWIW.  But yes, blocking in an RCU
> read-side critical section is a no-no.

Yeah, I know, but didn't notice until after I sent.. SRCU isn't useful
though, way too slow due to lacking srcu_call().
