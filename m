Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab2FOWuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:50:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48506 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab2FOWuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:50:06 -0400
Date: Fri, 15 Jun 2012 15:47:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 04/14] rcu: Add a gcc-style structure
 initializer for RCU pointers
Message-ID: <20120615224741.GP2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339791195-26389-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615204813.GI31184@leaf>
 <20120615215021.GV31184@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615215021.GV31184@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061522-6148-0000-0000-000006BE0B89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:50:21PM -0700, Josh Triplett wrote:
> On Fri, Jun 15, 2012 at 01:48:13PM -0700, Josh Triplett wrote:
> > On Fri, Jun 15, 2012 at 01:13:05PM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > RCU_INIT_POINTER() returns a value that is never used, and which should
> > > be abolished due to terminal ugliness:
> > > 
> > > 	q = RCU_INIT_POINTER(global_p, p);
> > > 
> > > However, there are two uses that cannot be handled by a do-while
> > > formulation because they do gcc-style initialization:
> > > 
> > > 	RCU_INIT_POINTER(.real_cred, &init_cred),
> > > 	RCU_INIT_POINTER(.cred, &init_cred),
> > > 
> > > This usage is clever, but not necessarily the nicest approach.  This
> > > commit therefore creates an INIT_RCU_POINTER() macro that is specifically
> > > designed for gcc-style initialization.
> > 
> > The concept seems fine, but the names seem entirely non-obvious.
> > RCU_INIT_POINTER versus INIT_RCU_POINTER?
> 
> Suggestion: RCU_POINTER_INITIALIZER, following the example of many other
> *_INITIALIZER macros elsewhere in the kernel.

Sold!

							Thanx, Paul

