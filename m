Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0JPHqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:46:53 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:48533 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0JPHqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:46:52 -0400
Date: Sat, 16 Oct 2010 03:46:46 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: linux-kernel@vger.kernel.org, tsi@ualberta.ca
Subject: Re: x86_64 2.6.35.* kernels and Intel Xeon X5550
In-reply-to: <alpine.WNT.1.10.1010152030320.280@tsi>
Message-id: <alpine.LFD.2.00.1010160338280.2238@localhost.localdomain>
References: <alpine.WNT.2.00.1010071055420.1672@cluij.ucs.ualberta.ca>
 <alpine.WNT.1.10.1010152030320.280@tsi>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > On the Xeon's, 2.6.35 hangs early on, upon the first test of trace events
> > (in kernel/trace/trace_events.c:event_trace_self_tests()).  When disabling
> > all tracing, debugging, etc., it still hangs but slightly later.  The
> > megaraid_sas module is loaded, detects the adapter, but never gets around to
> > registering it with the SCSI layer.

> This is due to "CONFIG_INTEL_IDLE=y".

Please file a bug report at bugzilla.kernel.org and assign it to me.

Please reproduce using an upstream 2.6.36-rc8 kernel.

Boot a CONFIG_INTEL_IDLE=n kernel and to the bug report...

attach the output from acpidump
'cat /proc/cpuinfo'
'grep . /sys/devices/system/cpu/cpu*/cpuidle/*/*'
'lspci'

Then boot a CONFIG_INTEL_IDLE=y kernel and see what is the highest N that
boots when you boot with "intel_idle.max_cstate=N"  (0 will disable
the driver completely) and if any of them boot, for the highest N,
attach to the bug report the complete dmesg and the output from
'grep . /sys/devices/system/cpu/cpu*/cpuidle/*/*'

thanks,
-Len Brown, Intel Open Source Technology Center
