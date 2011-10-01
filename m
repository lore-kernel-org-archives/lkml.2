Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1JANEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 09:04:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:34090 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1JANER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 09:04:17 -0400
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <htejun@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 01 Oct 2011 15:03:29 +0200
In-Reply-To: <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <20110930165206.GA22048@redhat.com>
	 <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110930235625.GD2658@mtj.dyndns.org>
	 <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317474209.12973.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-01 at 11:16 +0100, Matt Fleming wrote:
> I also think Thomas/Peter mentioned something about latency in
> delivering timer signals because of contention on the per-process
> siglock. They might have some more details on that. 

Right, so signal delivery is O(nr_threads), which precludes being able
to deliver signals from hardirq context, leading to lots of ugly in -rt.

The hope is that this work is a stepping stone to O(1) signal delivery.

Breaking up the multitude of uses of siglock certainly seems worthwhile
esp. if it also allows for a cleanup of the horrid mess called
signal_struct (which really should be called process_struct or so).

And yes, aside from that the siglock can be quite contended because its
pretty much the one lock serializing all of the process wide state.
