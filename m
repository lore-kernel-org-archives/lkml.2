Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab1BWTWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:22:09 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:48801 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752252Ab1BWTWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:22:08 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Wp7klwkVM1lheoudyrZ8k1djuH.ZQ64OC6354leuchmX8Tf
 A.6Jyt4ai2AKzbSn3Kg22eZNWZPD0LeDWWG6AeKZCg2_g5TNVKuBZ8ngXIfV
 F.rlMIsvzPb9KHeYdtPNwu8JMLIQj.ukfZj80L4Cf8QgFYiIULu1JnUbCFz4
 FICb8R0Gp7KkY4eFeeWL9mpIIHt0CtAg3yNv44nH_0mTt7V57LRtgFAxoHhl
 q10IVpbB0uYm3r8unqUe0l1MQhd17ZQlwbTonIiiR5c2wl9T45U_A8peru9S
 wfCHMSgb2fxES7DA5M8AmzZ4WHeQ7bk9DVXvKG46rVJNvZVA-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 23 Feb 2011 13:22:02 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
In-Reply-To: <20110223191043.GU2163@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1102231320050.4823@router.home>
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com> <20110223161645.GA1819@nowhere> <1298479302.7666.94.camel@gandalf.stny.rr.com> <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
 <alpine.DEB.2.00.1102231132140.562@router.home> <20110223191043.GU2163@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Paul E. McKenney wrote:

> These do introduce redundant preempt_disable()/preempt_enable() calls, but
> this is not on a fastpath, so should be OK, and the improved readability
> is certainly nice.  The read and the write do need to happen on the same
> CPU, FWIW.

this_cpu_xxx only use preempt_enable/disable() on platforms that do not
support per cpu atomic instructions. On x86 no preempt enable/disable will
be inserted.

You can also use the __this_cpu_xxx operations which never add preempt
disable/enable because they expect the caller to deal with preemption.
