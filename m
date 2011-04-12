Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1DLUkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:40:06 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:34692 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757353Ab1DLUkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:40:00 -0400
Date: Tue, 12 Apr 2011 22:39:15 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>, mjg@redhat.com,
        nagananda.chumbalkar@hp.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: pcc-cpufreq bug [Was: Bug in cpufreq-utils
 (/sys/devices/system/cpu/cpu*/cpufreq/affected_cpus)?]
Message-ID: <20110412203915.GB12827@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>, mjg@redhat.com,
	nagananda.chumbalkar@hp.com, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org
References: <4D9DEC01020000A1000059B5@gwsmtp1.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9DEC01020000A1000059B5@gwsmtp1.uni-regensburg.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Apr 07, 2011 at 04:53:21PM +0200, Ulrich Windl wrote:
> Hello,
> 
> I found this for cpufrequtils-004-35.20 on SLES11 SP1 (plus updates) for a HP DL380 G7 server with two 6-core Xeon X5650 CPUs:
> 
> ...
> analyzing CPU 23:
>   driver: pcc-cpufreq
>   CPUs which need to switch frequency at the same time: 23
>   hardware limits: 1.60 GHz - 2.67 GHz
>   available cpufreq governors: conservative, userspace, powersave, ondemand, performance
>   current policy: frequency should be within 1.60 GHz and 2.67 GHz.
>                   The governor "ondemand" may decide which speed to use
>                   within this range.
>   current CPU frequency is 1.57 GHz (asserted by call to hardware).
> 
> To my understanding "cpu23" in Linux is "package 1 (2nd CPU), core 9 (actually 4/6 or 6/6), ACPI ID 51". As each core is featuring hyper-theading I wonder whether two threads may actually be clocked individually. If not, "cpu11" (package 1 (2nd CPU), core 9 (actually 4/6 or 6/6), ACPI ID 50) should need to switch frequency, too.
> 
> # cat /sys/devices/system/cpu/cpu23/cpufreq/affected_cpus
> 23

Thanks for reporting this issue. However, cpufrequtils is rather dumb in
this regard, and just makes use of the values reported by the kernel. And
the kernel reports that changing the frequency of CPU 23 only affects CPU
23... Which is obviously wrong.

To the pcc-cpufreq.c driver developers & maintainers: Is there _any_ way to
properly set

	(struct cpufreq_policy *) -> cpus
				  -> related_cpus

in this driver?

Best,
	Dominik
