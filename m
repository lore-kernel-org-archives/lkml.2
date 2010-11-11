Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab0KKJMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:12:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:40283 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab0KKJMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:12:30 -0500
Message-ID: <4CDBB309.9020406@kernel.org>
Date: Thu, 11 Nov 2010 10:10:33 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 11/12] rcu: fix race condition in synchronize_sched_expedited()
References: <20101107020507.GA4974@linux.vnet.ibm.com> <1289095532-5398-11-git-send-email-paulmck@linux.vnet.ibm.com> <4CD94C0D.3030007@kernel.org> <4CDA5E40.3080205@cn.fujitsu.com> <20101111042014.GE3134@linux.vnet.ibm.com>
In-Reply-To: <20101111042014.GE3134@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Nov 2010 09:10:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul, Lai.

On 11/11/2010 05:20 AM, Paul E. McKenney wrote:
> On Wed, Nov 10, 2010 at 04:56:32PM +0800, Lai Jiangshan wrote:
>> On 11/09/2010 09:26 PM, Tejun Heo wrote:
>>> Hello, Paul.
>>>
>>>
>>> How about something like the following?  It's slightly bigger but I
>>> think it's a bit easier to understand.  Thanks.
>>
>> Hello, Paul, Tejun,
>>
>> I think this approach is good and much better when several tasks
>> call synchronize_sched_expedited() at the same time.
> 
> I am becoming more comfortable with it as well.  Tejun, what kind of
> testing did you do?  Lai, could you please run it on your systems?

I just compile tested it (so no SOB).  Please feel free to take it and
shape it into a proper patch.  Oh, I think we can drop both mb()'s at
the top and bottom as both atomic_inc_return() and atomic_cmpxchg()
imply full memory barrier.

Thanks.

-- 
tejun
