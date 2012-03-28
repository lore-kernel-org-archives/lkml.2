Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab2C1PvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:51:12 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:37626 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab2C1PvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:51:09 -0400
Message-ID: <4F73336C.3020603@tilera.com>
Date: Wed, 28 Mar 2012 11:51:08 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <linaro-sched-sig@lists.linaro.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>,
        Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 08/32] nohz: Try not to give the timekeeping duty to an
 adaptive tickless cpu
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>  <1332338318-5958-10-git-send-email-fweisbec@gmail.com>  <alpine.DEB.2.00.1203210950500.20482@router.home>  <20120327105034.GA13196@somewhere>  <alpine.DEB.2.00.1203271106130.1170@router.home>  <1332866823.16159.246.camel@twins>  <alpine.DEB.2.00.1203271943320.11825@router.home> <1332923983.2528.12.camel@twins>
In-Reply-To: <1332923983.2528.12.camel@twins>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/2012 4:39 AM, Peter Zijlstra wrote:
>> It would seem that the nohz patches would be much simpler if it would not
>> > require cpusets to administer. The only thing that would be needed is to
>> > have one cpu that is not subject to nohz. The logical choice is a
>> > timekeeper cpu (which is usually cpu 0). Having that configurable would be
>> > an extra bonus.
> Like Frederic has been telling, the nohz stuff adds syscall overhead, it
> needs to timestamp on kernel entry/exit etc.. Making it unconditional
> will add this overhead to everybody and this might not be acceptable.

And more generally, some kind of configuration step is important so the
kernel knows what userspace wants to have happen there.  On a nohz cpu the
kernel will try to optimize for running a single task with no OS overhead. 
On a default cpu the kernel will be trying to use the cpu as part of a pool
for optimizing the overall system experience, including work stealing,
background threads, etc.  This could be a per-process thing, or it could be
a per-core thing, but either way, the kernel can't really guess effectively.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

