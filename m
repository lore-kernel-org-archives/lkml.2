Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1DGOx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:53:27 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:44847 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1DGOx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:53:26 -0400
Message-Id: <4D9DEC01020000A1000059B5@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 07 Apr 2011 16:53:21 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Bug in cpufreq-utils
 (/sys/devices/system/cpu/cpu*/cpufreq/affected_cpus)?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I found this for cpufrequtils-004-35.20 on SLES11 SP1 (plus updates) for a HP DL380 G7 server with two 6-core Xeon X5650 CPUs:

...
analyzing CPU 23:
  driver: pcc-cpufreq
  CPUs which need to switch frequency at the same time: 23
  hardware limits: 1.60 GHz - 2.67 GHz
  available cpufreq governors: conservative, userspace, powersave, ondemand, performance
  current policy: frequency should be within 1.60 GHz and 2.67 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 1.57 GHz (asserted by call to hardware).

To my understanding "cpu23" in Linux is "package 1 (2nd CPU), core 9 (actually 4/6 or 6/6), ACPI ID 51". As each core is featuring hyper-theading I wonder whether two threads may actually be clocked individually. If not, "cpu11" (package 1 (2nd CPU), core 9 (actually 4/6 or 6/6), ACPI ID 50) should need to switch frequency, too.

# cat /sys/devices/system/cpu/cpu23/cpufreq/affected_cpus
23
# cat /proc/version
Linux version 2.6.32.29-0.3-default (geeko@buildhost) (gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #1 SMP 2011-02-25 13:36:59 +0100

Regards,
Ulrich
P.S. I'm not subscribed to this list, so maybe CC: your answers - thanks!

