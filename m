Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab1K1UPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:15:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35994 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab1K1UPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:15:23 -0500
Message-ID: <1322511307.2921.173.camel@twins>
Subject: Re: [PATCH 4/9] ftrace: Add enable/disable ftrace_ops control
 interface
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 21:15:07 +0100
In-Reply-To: <1322511125.17003.21.camel@frodo>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-5-git-send-email-jolsa@redhat.com>
	 <1322508398.17003.9.camel@frodo>  <1322510552.2921.167.camel@twins>
	 <1322511125.17003.21.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 15:12 -0500, Steven Rostedt wrote:
> Actually, from what I've been told, x86 seems to be the only arch that
> does crazy things with NMIs. Most the other archs do NMI when the system
> is dead. That is, there's no return to normal system processing once an
> NMI is hit. 

Sparc64 implements effective NMIs by playing games with their interrupt
priority levels. local_irq_disable() disable the lower 15 (0-14) levels
only, and their PMU interrupts at level 15.

That generates an effective NMI (interrupt not blocked by
local_irq_disable()).
