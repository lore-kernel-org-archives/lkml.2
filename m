Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2GHPzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 11:55:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab2GHPzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 11:55:03 -0400
Message-ID: <4FF9AD2A.1000901@redhat.com>
Date: Sun, 08 Jul 2012 18:54:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/6] rcu: Allow rcu_user_enter()/exit() to nest
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com> <1341576018-10721-3-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1341576018-10721-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 03:00 PM, Frederic Weisbecker wrote:
> Allow calls to rcu_user_enter() even if we are already
> in userspace (as seen by RCU) and allow calls to rcu_user_exit()
> even if we are already in the kernel.
> 
> This makes the APIs more flexible to be called from architectures.
> Exception entries for example won't need to know if they come from
> userspace before calling rcu_user_exit().

I guess I should switch kvm to rcu_user_enter() and co, so we can
disable the tick while running in a guest.  But where are those
functions?  What are the rules for calling them?

-- 
error compiling committee.c: too many arguments to function


