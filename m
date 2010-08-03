Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0HCE4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:56:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39264 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0HCE4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:56:11 -0400
MIME-Version: 1.0
In-Reply-To: <20100802011006.GS2470@linux.vnet.ibm.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100731215214.2543c07e@infradead.org>
	<20100801054816.GI2470@linux.vnet.ibm.com>
	<20100731230101.7cc1d8c7@infradead.org>
	<20100801191228.GL2470@linux.vnet.ibm.com>
	<20100801154708.19817b75@infradead.org>
	<20100802011006.GS2470@linux.vnet.ibm.com>
Date: Mon, 2 Aug 2010 21:56:10 -0700
Message-ID: <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: paulmck@linux.vnet.ibm.com
Cc: Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 1, 2010 at 6:10 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Sun, Aug 01, 2010 at 03:47:08PM -0700, Arjan van de Ven wrote:
...
>> Another one: freezing whole cgroups..... we have that today. it
>> actually works quite well.... of course the hard part is the decision
>> what to put in which cgroup, and at what frequency and duration you let
>> cgroups run.
>
> Indeed, the Android guys seemed to be quite excited by cgroup freezing
> until they thought about the application-classification problem.
> Seems like it should be easy for some types of applications, but I do
> admit that apps can have non-trivial and non-obvious dependencies.
>

The dependencies is what made this solution uninteresting to us. For
instance, we currently use cgroup scheduling to reduce the impact of
some background tasks, but we occasionally saw a watchdog restart of
the system process were critical services were waiting on a kernel
mutex owned by a background task for more than 20 seconds. If we froze
a cgroup instead, we would not hit this particular problem since tasks
cannot be frozen while executing kernel code the same way they can be
preempted, but nothing prevents a task from being frozen while holding
a user-space resource.

-- 
Arve Hjønnevåg
