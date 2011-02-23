Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab1BWTYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:24:41 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:32713 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932483Ab1BWTYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:24:40 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: q1BRFaIVM1lrcIamv1Cj8TB35s1dSTrNII3K0Gy5nL462kP
 EUsfumCgbgz1iAdwreK6msGbqfCUiyTPa4lIyQGLAgvfSLCXrTiTSYyjyouu
 oSKzQecBv5bFzdxgnCj.5vIdqDzJGCP.cQggFwsODNiB4D8gL6fKO_BvdTN.
 nMCwXj7R4Qtyb7t13RWDsZTZ4Dyi3I66l2mLD9Ij2I7.eyb01vh9W2A_pDY9
 3YeSMoB2Wt7RrQPoepDTs7TB7nvwW.jzN4f8-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 23 Feb 2011 13:24:34 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
In-Reply-To: <20110223191658.GV2163@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1102231323140.4823@router.home>
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com> <20110223161645.GA1819@nowhere> <1298479302.7666.94.camel@gandalf.stny.rr.com> <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
 <alpine.DEB.2.00.1102231132140.562@router.home> <1298485027.7666.98.camel@gandalf.stny.rr.com> <alpine.DEB.2.00.1102231225330.3906@router.home> <20110223191658.GV2163@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Paul E. McKenney wrote:

> Reschedules can happen in this case due to CPU hotplug events.  :-(

Lockout cpu hotplug instead of disabling interrupts? Systems that support
cpu hotplug in hardware are rare and so the cpu hotplug locking may be
become noop.


