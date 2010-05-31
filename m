Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0EaC5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 22:57:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:4094 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab0EaC5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 22:57:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,330,1272870000"; 
   d="scan'208";a="571878657"
Subject: Re: [BUG] kacpi_notify goes into an infinite loop (luckly it calls
 cond_resched)
From: Zhang Rui <rui.zhang@intel.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Renninger <trenn@suse.de>,
       "clarkt@cnsp.com" <clarkt@cnsp.com>, "Brown, Len" <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1275094882.22648.607.camel@gandalf.stny.rr.com>
References: <1275094882.22648.607.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 10:57:50 +0800
Message-ID: <1275274670.9119.4419.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steve,

On Sat, 2010-05-29 at 09:01 +0800, Steven Rostedt wrote:
> I just replaced Windows with F12 on my wife's computer, to have nothing
> but issues. But anyway, one of the issues I had on this box was in
> vanilla linux kernel 2.6.34 (all the fedora kernels had other issues),
> the kacpi_notify would go into an infinite loop.
> 
> I debugged it a bit with ftrace and saw that the kacpi_notify workqueue
> was constantly requeuing itself (thanks to the workqueue trace events).
> 
> I bisected this, and it came down to this change:
> 
> commit fa80945269f312bc609e8384302f58b03c916e12
> Author: Thomas Renninger <trenn@suse.de>
> Date:   Sat Feb 20 11:44:27 2010 +0100
> 
>     ACPI thermal: Don't invalidate thermal zone if critical trip point is bad
> 
> 
This patch enables the ACPI thermal control which is used to be disabled
on some laptops.

Maybe this triggers an interrupt storm on this box.

please attach the output of "grep . /sys/firmware/acpi/interrupts/*".
please attach the acpidump output of your laptop as well.

thanks,
rui


