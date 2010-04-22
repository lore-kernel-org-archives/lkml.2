Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab0DVN5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:57:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:42765 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab0DVN5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:57:05 -0400
Subject: Re: Considerations on sched APIs under RT patch
From: Peter Zijlstra <peterz@infradead.org>
To: Primiano Tucci <p.tucci@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>
In-Reply-To: <x2hc5b2c05b1004220650w53919f62hf3daedb822755bf4@mail.gmail.com>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271804453.10448.168.camel@gandalf.stny.rr.com>
	 <t2nc5b2c05b1004202216pd159c9b4mbfc1dc7658fc20e7@mail.gmail.com>
	 <1271839772.1776.58.camel@laptop>
	 <1271854016.10448.172.camel@gandalf.stny.rr.com>
	 <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com>
	 <1271879833.1776.186.camel@laptop>
	 <s2tc5b2c05b1004211338y814bc3b2o547a6eecdf64ca7f@mail.gmail.com>
	 <1271883496.1776.263.camel@laptop>
	 <1271942430.10448.196.camel@gandalf.stny.rr.com>
	 <x2hc5b2c05b1004220650w53919f62hf3daedb822755bf4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 15:57:02 +0200
Message-ID: <1271944622.1776.349.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 15:50 +0200, Primiano Tucci wrote:
> I knew this kind of solution based on OS-partitioning, but my group
> and I are currently working on a Global-EDF scheduler, a unique
> scheduler (and therefore a unique OS/Kernel) that is able to migrate
> tasks between CPUs in order to maximize the global CPU usage.

I would hardly call a global-edf scheduler unique. Its a well studied
algorithm and even available in commercial SMP operating systems
(hopefully soon Linux too, see SCHED_DEADLINE, which will approximate
global-edf, much like the current SCHED_FIFO approximates global-fifo).

> In order to to this we have a unique "super"-process (a
> Meta-Scheduler) that needs to be able to control priority and affinity
> of the managed tasks, without losing the control while doing this. 

Implementing this as userspace/middleware seems daft. But if your
controlling process has a global affinity mask and runs as the highest
available userspace process priority its still all valid.



