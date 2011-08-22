Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab1HVPro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:47:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1HVPrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:47:41 -0400
Date: Mon, 22 Aug 2011 11:47:26 -0400
From: Don Zickus <dzickus@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: trigger_all_cpu_backtrace() has no generic implementation (was
 Re: [regression, 3.1, rcu] rcu_sched_state detected stall on CPU 8 (t=15000
 jiffies))
Message-ID: <20110822154726.GA12139@redhat.com>
References: <20110803022857.GH12870@dastard>
 <20110803025222.GI12870@dastard>
 <20110803063049.GD13065@linux.vnet.ibm.com>
 <20110805003316.GA3162@dastard>
 <20110805064119.GB13065@linux.vnet.ibm.com>
 <20110805084839.GB3162@dastard>
 <20110805112429.GM13065@linux.vnet.ibm.com>
 <20110806002056.GC3162@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806002056.GC3162@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 10:20:56AM +1000, Dave Chinner wrote:
> 
> It would appear to be because include/linux/nmi.h does not do
> #include <asm/nmi.h> where arch_trigger_all_cpu_backtrace is
> defined.
> 
> I think this is the case from looking at the build deps for
> rcutree.h: I see include/linux/nmi.h but no asm/nmi.h. It appears
> that asm/nmi.h is only included if this config ifdef is true:

*sigh*.  It seems as though I broke this with commit
4a7863cc2eb5f9804f1c4e9156619a801cd7f14f when I tried to cleanup
the namespace a little bit.

I am going to have to find a file to move the #define arch_trigger_* stuff
to.  Forcing it to include the asm/nmi.h file with the LOCKUP_DETECTOR
config option disabled screws up all the touch_nmi_watchdog logic.

Maybe I can stick it in an asm/irq.h header file or something that gets
included from a top level linux/*.h file.  Dunno.

Sorry about that.

Cheers,
Don
