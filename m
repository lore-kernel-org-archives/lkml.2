Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab0JRQuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:50:16 -0400
Received: from smtp.srv.ualberta.ca ([129.128.5.19]:53609 "EHLO
	mail2.srv.ualberta.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752771Ab0JRQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:50:13 -0400
Date: Mon, 18 Oct 2010 10:46:25 -0600 (Mountain Daylight Time)
From: Marc Aurele La France <tsi@ualberta.ca>
Reply-To: linux-kernel@vger.kernel.org, tsi@ualberta.ca
To: Len Brown <lenb@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: x86_64 2.6.35.* kernels and Intel Xeon X5550
In-Reply-To: <alpine.LFD.2.00.1010160338280.2238@localhost.localdomain>
Message-ID: <alpine.WNT.2.00.1010181043550.1696@cluij.ucs.ualberta.ca>
References: <alpine.WNT.2.00.1010071055420.1672@cluij.ucs.ualberta.ca> <alpine.WNT.1.10.1010152030320.280@tsi> <alpine.LFD.2.00.1010160338280.2238@localhost.localdomain>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010, Len Brown wrote:

>>> On the Xeon's, 2.6.35 hangs early on, upon the first test of trace events
>>> (in kernel/trace/trace_events.c:event_trace_self_tests()).  When disabling
>>> all tracing, debugging, etc., it still hangs but slightly later.  The
>>> megaraid_sas module is loaded, detects the adapter, but never gets around to
>>> registering it with the SCSI layer.

>> This is due to "CONFIG_INTEL_IDLE=y".

> Please file a bug report at bugzilla.kernel.org and assign it to me.

> Please reproduce using an upstream 2.6.36-rc8 kernel.

> Boot a CONFIG_INTEL_IDLE=n kernel and to the bug report...

> attach the output from acpidump
> 'cat /proc/cpuinfo'
> 'grep . /sys/devices/system/cpu/cpu*/cpuidle/*/*'
> 'lspci'

> Then boot a CONFIG_INTEL_IDLE=y kernel and see what is the highest N that
> boots when you boot with "intel_idle.max_cstate=N"  (0 will disable
> the driver completely) and if any of them boot, for the highest N,
> attach to the bug report the complete dmesg and the output from
> 'grep . /sys/devices/system/cpu/cpu*/cpuidle/*/*'

I've gathered all the data, but the kernel's BZ is borked at the moment, 
so this'll have to wait.

Marc.

+----------------------------------+----------------------------------+
|  Marc Aurele La France           |  work:   1-780-492-9310          |
|  Academic Information and        |  fax:    1-780-492-1729          |
|    Communications Technologies   |  email:  tsi@ualberta.ca         |
|  352 General Services Building   +----------------------------------+
|  University of Alberta           |                                  |
|  Edmonton, Alberta               |    Standard disclaimers apply    |
|  T6G 2H1                         |                                  |
|  CANADA                          |                                  |
+----------------------------------+----------------------------------+
