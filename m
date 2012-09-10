Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2IJVf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 17:35:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51972 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab2IJVf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 17:35:27 -0400
Date: Mon, 10 Sep 2012 23:35:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: Re: [PATCH tip/core/rcu 04/26] rcu: Settle config for userspace
 extended quiescent state
Message-ID: <20120910213506.GC21277@somewhere.redhat.com>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831234401.GB11771@jtriplet-mobl1>
 <20120905003459.GA2593@linux.vnet.ibm.com>
 <20120905004619.GB12373@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905004619.GB12373@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 05:46:19PM -0700, Josh Triplett wrote:
> > It actually does depend on SMP.  There has to be at least one CPU taking
> > scheduling-clock interrupts in order to keep time computation accurate,
> > so a de-facto UP system cannot adaptive-dynticks its sole CPU.
> 
> Ah.  That seems like a removable limitation, albeit a difficult one.
> Nonetheless, it makes sense to avoid providing the option when it won't
> help.
> 
> However, once a config symbol for adaptive dynticks exists, perhaps that
> symbol should depend on SMP and RCU_USER_QS should depend on that
> instead, documenting the limitation in the right place and making it
> easier to find and change eventually.

Right! And in fact CONFIG_RCU_USER_QS is a temporary config. Once we'll have
CONFIG_NO_HZ_FULL, we won't need intermediate configs like this.
And CONFIG_NO_HZ_FULL will depend on SMP anyway.
