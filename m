Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab2ADRGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:06:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab2ADRGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:06:02 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QcgJSxWpgi8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=kRHqAyIto0Tgq_i4W-EA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325696759.12696.24.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 04 Jan 2012 12:05:59 -0500
In-Reply-To: <20120104141107.GA24770@elte.hu>
References: <20111221123624.193898256@goodmis.org>
	 <20120101180949.GA25066@elte.hu> <20120102105856.GA6661@elte.hu>
	 <20120102134856.GA32673@elte.hu>
	 <1325635373.12696.4.camel@gandalf.stny.rr.com>
	 <1325635922.12696.8.camel@gandalf.stny.rr.com>
	 <1325653301.12696.20.camel@gandalf.stny.rr.com>
	 <20120104141107.GA24770@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 15:11 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > My mistake, I forgot to add the "minimum config" for booting 
> > the box. When I did that, it booted fine. I kicked off the 
> > bisect again, and lets see what happens.
> 
> Okay.
> 
> I too did a lot of testing, breaking my promise to do other 
> stuff ;-)
> 
> *Both* of your trees [the NMI and the cleanup/fixes tree], when 
> merged produced hangs or spontaneous reboots, within 5 
> iterations typically.

I actually haven't looked at the NMI branch yet. I'm still trying to
figure out why the ftrace one would lockup. I'll try another box to see
if that one also locks up on tip/master with your config.

> 
> The failure modes were different: the NMI tree tended to do the 
> spontaneous reboot thing, the fixes tree produced the soft 
> hangs.

Did you just merge in the branches, or do you see the same problem if
you test the head of the branch itself?

In other words, did the branch have the issue, or is the branch causing
an issue with something already in tip?

> 
> I'm now re-testing pristine -tip again - which did the 50 and 70 
> series of successful bootups ...

BTW, I did a make oldconfig with the config you gave me, and the result
is a bit different:

diffconfig your-config .config

-BOOTPARAM_SUPPORT_NOT_WANTED y
-BROKEN_BOOT_ALLOWED2 y
-BROKEN_BOOT_ALLOWED3 y
-BROKEN_BOOT_ALLOWED4 y
-BROKEN_BOOT_DISALLOWED y
-BROKEN_BOOT_EUROPE n
-BROKEN_BOOT_TITAN n
-FORCE_MINIMAL_CONFIG y
-FORCE_MINIMAL_CONFIG_64 y
-FORCE_MINIMAL_CONFIG_PHYS y
-FORCE_SUCCESSFUL_BUILD y
-SMP_SUPPORT y
-UP_WANTED y
-UP_WANTED_1 y
-UP_WANTED_2 y
-USB_MOUSE y
+CMDLINE_OVERRIDE n
+DEBUG_BLOCK_EXT_DEVT n
+DEBUG_INFO n
+DEBUG_KOBJECT n
+EUROTECH_WDT n
+FB_ASILIANT n
+FB_CIRRUS n
+FB_RADEON n
+FB_VESA n
+FB_VGA16 n
+FB_VIRTUAL n
+FRAMEBUFFER_CONSOLE n
+FTRACE_STARTUP_TEST n
+IDE n
+KGDB_TESTS_ON_BOOT n
+KPROBES_SANITY_TEST n
+MTD n
+PARIDE n
+PM_TEST_SUSPEND n
+PROFILE_ALL_BRANCHES n
+PROFILE_ANNOTATED_BRANCHES n
+RING_BUFFER_BENCHMARK n
+SECURITY_SELINUX_POLICYDB_VERSION_MAX n
+SECURITY_SMACK n
+SECURITY_TOMOYO_OMIT_USERSPACE_LOADER n
+SENSORS_LM90 n
+SENSORS_LM92 n
+SENSORS_LM93 n
+SENSORS_W83627HF n
+SENSORS_W83793 n
+STAGING n
+W83697HF_WDT n
+W83697UG_WDT n

Was the config based off of tip/master? I'm a missing a branch?

Thanks,

-- Steve


