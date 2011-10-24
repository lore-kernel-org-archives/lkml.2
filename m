Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab1JXMHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:07:45 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47884 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130Ab1JXMHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:07:44 -0400
Date: Mon, 24 Oct 2011 05:00:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 31/55] rcu: Make
 rcu_implicit_dynticks_qs() locals be correct size
Message-ID: <20111024120032.GB2273@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-31-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111017014350.GD19421@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017014350.GD19421@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11102412-8974-0000-0000-0000010E0980
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 06:43:50PM -0700, Josh Triplett wrote:
> On Tue, Sep 06, 2011 at 11:00:25AM -0700, Paul E. McKenney wrote:
> > When the ->dynticks field in the rcu_dynticks structure changed to an
> > atomic_t, its size on 64-bit systems changed from 64 bits to 32 bits.
> > The local variables in rcu_implicit_dynticks_qs() need to change as
> > well, hence this commit.
> 
> If an atomic_t always holds 32-bits, which it appears to, then shouldn't
> this use u32 rather than unsigned int?

The atomic_t definition is "int", and I need "unsigned int" to avoid
integer overflow.

But it might make sense to make atomic_t s32, in which case I would
use u32.  I don't feel very strongly about it either way, because "int"
is also defined to be 32 bits.  Maybe I should put such a patch forward
later on.

							Thanx, Paul

