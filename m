Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0DVNUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:20:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab0DVNUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:20:33 -0400
X-Authority-Analysis: v=1.1 cv=ZUag8tkj9kgmNMrzofuoEsXxpG43g9sRv4eUZcQ4+as= c=1 sm=0 a=eOOYVsMsLpwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=T1qvVmCMXHU_hkTaPgUA:9 a=RWnJd-SjZLEOXN8BOBGL-6yI-zIA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Considerations on sched APIs under RT patch
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Primiano Tucci <p.tucci@gmail.com>, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>
In-Reply-To: <1271883496.1776.263.camel@laptop>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271755208.1676.422.camel@laptop>
	 <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
	 <1271804453.10448.168.camel@gandalf.stny.rr.com>
	 <t2nc5b2c05b1004202216pd159c9b4mbfc1dc7658fc20e7@mail.gmail.com>
	 <1271839772.1776.58.camel@laptop>
	 <1271854016.10448.172.camel@gandalf.stny.rr.com>
	 <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com>
	 <1271879833.1776.186.camel@laptop>
	 <s2tc5b2c05b1004211338y814bc3b2o547a6eecdf64ca7f@mail.gmail.com>
	 <1271883496.1776.263.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 22 Apr 2010 09:20:30 -0400
Message-ID: <1271942430.10448.196.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 22:58 +0200, Peter Zijlstra wrote:

> > P.S. It actually does not happen in other RTOSes, e.g., VxWorks SMP
> 
> I don't know any of those, but its impossible to migrate tasks from one
> cpu to another without creating cross-cpu dependencies.
> 
> Whether locks are preemptible or not doesn't make them any less
> analyzable, if you use system-calls in your RT program, their
> implementation needs to be considered

It's been a while since I've used SMP VxWorks, but back then what it did
was to copy an image for ever CPU separately. It was not really SMP but
instead a separate OS for each CPU. Things may have changed since then
(it was around 2002 when I saw this).

There's projects to do the same for Linux, and I feel it may give you
the most control of the system. But the hardware is still shared, so the
contention does not go away, it just gets moved to the hardware
resources.

-- Steve


