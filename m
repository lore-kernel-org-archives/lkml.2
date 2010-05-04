Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab0EDUgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:36:21 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36161 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab0EDUgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:36:16 -0400
Date: Tue, 4 May 2010 13:36:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       "David S. Miller" <davem@davemloft.net>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH tip/core/rcu 21/48] remove all rcu head
 initializations, except on_stack initializations
Message-ID: <20100504203609.GF2639@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100504201934.GA19234@linux.vnet.ibm.com>
 <1273004398-19760-21-git-send-email-paulmck@linux.vnet.ibm.com>
 <1273004823.21962.2278.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273004823.21962.2278.camel@calx>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 03:27:03PM -0500, Matt Mackall wrote:
> On Tue, 2010-05-04 at 13:19 -0700, Paul E. McKenney wrote:
> > From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > 
> > Remove all rcu head inits. We don't care about the RCU head state before passing
> > it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
> > keep track of objects on stack.
> 
> Please document that distinction at the definition of INIT_RCU_HEADS,
> otherwise we're sure to see creep.

Hello, Matt,

RCU_HEAD_INIT() is no more.  Or will be no more after this patchset.
However, now that you mention it, we do need docbook comments for
init_rcu_head_on_stack() and friends.  I will fix that.

							Thanx, Paul
