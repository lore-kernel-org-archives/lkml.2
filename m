Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab2CWKZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 06:25:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:54240 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab2CWKZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 06:25:43 -0400
Message-ID: <1332498333.16159.9.camel@twins>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 23 Mar 2012 11:25:33 +0100
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A05C092@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
	 <1331808391.18960.160.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
	 <1331891364.18960.221.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com>
	 <1332151397.18960.252.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com>
	 <1332245842.18960.413.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05B485@SHSMSX101.ccr.corp.intel.com>
	 <1332332739.18960.488.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05C092@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 00:59 +0000, Liu, Chuansheng wrote:
> Below is the complete test patch. Just run the simpl_loop_onoffline.sh
> and simpl_loop_smpcalling.sh concurrently
> to reproduce the race.
> 
What I did was:

for i in {2..23} ; do echo 0 > /sys/devices/system/cpu/cpu${i}/online ; done
while usleep 50000 ; do echo 1 > /debug/smp_call_test ; done &
while :; do echo $i > /sys/devices/system/cpu/cpu1/online ; let i^=1 ; done

and this has been running for well over 30 minutes.. is there anything
else one needs to do?


