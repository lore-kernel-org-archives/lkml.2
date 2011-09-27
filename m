Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1I0KVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:21:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1I0KVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:21:32 -0400
MIME-Version: 1.0
In-Reply-To: <1316832094.6387.11.camel@gandalf.stny.rr.com>
References: <1316825684.6387.5.camel@gandalf.stny.rr.com>
	<CAHH2K0Z_MsVceOjoFwT=qORSsKrFWjs_V602NMtPBysasJLEww@mail.gmail.com>
	<CAHH2K0agLygD6cREazsTquCT=Whx97RxxhOneWpVF1cHwMwp3A@mail.gmail.com>
	<1316832094.6387.11.camel@gandalf.stny.rr.com>
Date: Tue, 27 Sep 2011 15:51:31 +0530
Message-ID: <CAKTCnznH1WWsVaPQfRF5u9VKvOL6D8cxP0239XhKe8_mG4J35w@mail.gmail.com>
Subject: Re: [PATCH] memcg: Fix race condition in memcg_check_events() with
 this_cpu usage
From: Balbir Singh <bsingharora@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Thelen <gthelen@google.com>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        PeterZijlstra <peterz@infradead.org>, ChristophLameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 8:11 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-09-23 at 19:39 -0700, Greg Thelen wrote:
>> cc: updated Balbir Singh email address
>>
>> On Fri, Sep 23, 2011 at 7:34 PM, Greg Thelen <gthelen@google.com> wrote:
>> > On Fri, Sep 23, 2011 at 5:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >> From: Steven Rostedt <srostedt@redhat.com>
>> >>
>> >> The code in memcg_check_events() calls this_cpu_read() on
>> >> different variables without disabling preemption, and can cause
>> >> the calculations to be done from two different CPU variables.
>> >>
>> >> Disable preemption throughout the check to keep apples and oranges
>> >> from becoming a mixed drink.
>> >>
>> >> [ Added this_cpu to __this_cpu conversion by Johannes ]
>> >>
>> >> Cc: Greg Thelen <gthelen@google.com>
>> >> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
>>
>> Correction:
>> Cc: Balbir Singh <bsingharora@gmail.com>
>
> Thanks, I was starting to hate that "return mail to sender" thing.
>

Thanks for the correction. The change looks good to me

Acked-by: Balbir Singh <bsingharora@gmail.com>

Balbir


Balbir Singh
