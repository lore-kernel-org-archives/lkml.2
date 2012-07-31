Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2GaMvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:51:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183Ab2GaMu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:50:59 -0400
Message-ID: <5017D4AB.3090107@redhat.com>
Date: Tue, 31 Jul 2012 15:50:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <srostedt@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Testing tracer wakeup_rt: .. no entries found ..FAILED!
References: <20120724090330.GA9830@localhost>  <20120724090720.GA10434@localhost> <1343663105.3847.7.camel@fedora>  <20120731121759.GA17822@localhost> <5017D19B.5080806@redhat.com> <1343738627.27983.30.camel@gandalf.stny.rr.com>
In-Reply-To: <1343738627.27983.30.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 03:43 PM, Steven Rostedt wrote:
> On Tue, 2012-07-31 at 15:37 +0300, Avi Kivity wrote:
>> On 07/31/2012 03:17 PM, Fengguang Wu wrote:
>> > 
>> > It's good to quickly get to the root cause :) Can we possibly detect
>> > whether we are in a virtual machine and hence skip this particular
>> > test case?
>> 
>> cpu_has(&boot_cpu, X86_FEATURE_HYPERVISOR)
>> 
> 
> Yeah, but then it is still broken on non-x86 code (the test lives in
> core kernel).
> 
> As it is just testing the events for wakeup, I could probably just add a
> completion and force the other thread to just wait for it. I'll write up
> a patch. But it wont make it in till 3.7.

That would be better.  A hypervisor might be real-time capable (with
some effort kvm can do this), so we don't want to turn off real time
features just based on that.


-- 
error compiling committee.c: too many arguments to function


