Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1LFTHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:07:01 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59237 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1LFTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:07:00 -0500
Date: Tue, 6 Dec 2011 20:06:48 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and
 package level thermal throttle event in mce log
Message-ID: <20111206190648.GB20445@aftab>
References: <1321305082-31310-1-git-send-email-fenghua.yu@intel.com>
 <20111205131825.GA31275@gere.osrc.amd.com>
 <0207C53569FE594381A4F2EB66570B2A018EE61884@orsmsx508.amr.corp.intel.com>
 <20111206153108.GD28735@gere.osrc.amd.com>
 <43F901BD926A4E43B106BF17856F075501A22B5365@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F075501A22B5365@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 09:48:41AM -0800, Yu, Fenghua wrote:

> The printk is one way to notify users about the power limit and
> thermal throttle. The printk only dumps the events in an interval
> (300*HZ).
>
> Another way is to count the events in
> /sys/devices/system/cpu/cpu#/thermal_throttle. In this way, kernel
> logs every interrupt on any cpu into respective counters. User
> application can poll the counters and get more accurate and timely
> information for the events.
>
> As explained in this patch, core level thermal throttle is still
> logged in mcelog for legacy reason after this patch is applied.

I can see all that. Still, I'm questioning the need for those printks. A
user application polling the counters is a much better solution, IMHO,
than spamming the logs. IOW, is there a strong reason to have this -
even ratelimited - information in the logs and unnerve users, or, would
it be better to collect this info somewhere queitly and present it only
when something requests it?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
