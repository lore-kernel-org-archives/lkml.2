Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1BCUJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:09:47 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48817 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342Ab1BCUJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:09:46 -0500
Date: Thu, 3 Feb 2011 12:09:42 -0800
From: Andres Salomon <dilinger@queued.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Daniel Drake <dsd@laptop.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: Re: [sodaville] [PATCH v2 01/15] x86/e820: remove conditional early
 mapping in parse_e820_ext
Message-ID: <20110203120942.1a8fc98c@queued.net>
In-Reply-To: <4D4B058F.9030208@linux.intel.com>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
	<1292600033-12271-2-git-send-email-bigeasy@linutronix.de>
	<20101230083745.GC11721@angua.secretlab.ca>
	<20110104130839.GA21359@www.tglx.de>
	<20110114081446.GC21832@angua.secretlab.ca>
	<20110114105709.GA7562@www.tglx.de>
	<20110114134345.712e2e29@queued.net>
	<AANLkTimyrGkqtjo99+aV+N4KcrC2_3PprpRD2tRo_NtC@mail.gmail.com>
	<4D4808D2.3080701@linutronix.de>
	<20110201103617.2c3aa118@debxo>
	<AANLkTi=kXaD0qhpHx30tFKN92pmAESSrXE1mz_55yuQO@mail.gmail.com>
	<20110203104051.12cdfbe5@queued.net>
	<4D4B058F.9030208@linux.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Feb 2011 11:44:15 -0800
"H. Peter Anvin" <hpa@linux.intel.com> wrote:

> On 02/03/2011 10:40 AM, Andres Salomon wrote:
> > 
> > That's actually what the plan is; the code just depends on PM
> > features, which is still being worked on.
> > 
> 
> I really don't understand what this is supposed to mean in this
> context at all.
> 
> 	-hpa


Daniel has a patch set that includes the following:

0010-OLPC-add-XO-1-rtc-driver.patch

+++ b/arch/x86/platform/olpc/olpc.c
@@ -311,6 +311,8 @@ static int __init add_xo1_platform_devices(void)
 {
        struct platform_device *pdev;

+       olpc_xo1_rtc_init();
+
        pdev = platform_device_register_simple("xo1-rfkill", -1, NULL,
  0);


This registers a specific rtc device for XO-1 machines (using the
CS5536 RTC).  XO-1.5 uses ACPI and a Via-based board, so the RTC device
should be handled there automatically.  The corner case is for machines
where the OLPC DT is enabled, but OLPC_XO1_RTC is not enabled.  We
still need to figure out what to do in that case, but I think it's more
appropriate to focus on getting the PM and XO1_RTC stuff upstream
first.  As of right now, it's the *only* case.  We'll change that, by
getting OLPC_XO1_RTC upstream.
