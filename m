Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2DXMyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:54:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37905 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab2DXMyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:54:08 -0400
Message-ID: <1335272025.28150.193.camel@twins>
Subject: Re: [RFC/PATCH] Prevent wasting time to find out get_parent_ip
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Minho Ban <mhban@samsung.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Date: Tue, 24 Apr 2012 14:53:45 +0200
In-Reply-To: <4F969E53.9080307@samsung.com>
References: <4F969E53.9080307@samsung.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 21:36 +0900, Minho Ban wrote:
> trace_preempt_on/off looks empty if PREEMPT_TRACER is off. But actually it is
> spending time to find out get_parent_ip(even CALLER_ADDR for some ARCH) which is
> in argument. This seems not fair for those who expect to do nothing but increase
> or decrease count.

You can do the same by making them CPP macros and adding a comment as to
why they're macros instead of inlines..
