Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1LFT0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:26:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56929 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1LFT0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:26:03 -0500
MIME-Version: 1.0
In-Reply-To: <20111206190648.GB20445@aftab>
References: <1321305082-31310-1-git-send-email-fenghua.yu@intel.com>
	<20111205131825.GA31275@gere.osrc.amd.com>
	<0207C53569FE594381A4F2EB66570B2A018EE61884@orsmsx508.amr.corp.intel.com>
	<20111206153108.GD28735@gere.osrc.amd.com>
	<43F901BD926A4E43B106BF17856F075501A22B5365@orsmsx508.amr.corp.intel.com>
	<20111206190648.GB20445@aftab>
Date: Tue, 6 Dec 2011 11:26:03 -0800
X-Google-Sender-Auth: 9vHvexcYxZFvWqZFqCHBzCr1YnQ
Message-ID: <CA+8MBb+v_HJ=odHMTZUP_LuNkAj=dHPC28i3HWAkemW7CN=hMw@mail.gmail.com>
Subject: Re: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and
 package level thermal throttle event in mce log
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 11:06 AM, Borislav Petkov <bp@amd64.org> wrote:
> I can see all that. Still, I'm questioning the need for those printks. A
> user application polling the counters is a much better solution, IMHO,
> than spamming the logs. IOW, is there a strong reason to have this -
> even ratelimited - information in the logs and unnerve users, or, would
> it be better to collect this info somewhere queitly and present it only
> when something requests it?

Striking the right balance here is hard - if one has a BIOS that set the
thresholds at "interesting" values - then you certainly don't want to the
console to be spammed with a lot of useless junk.

But if there is a real problem - then having someone tell you later that
you should have been checking some obscure file in /sys to see that
some thermal/power limit events were being seen may not go over very
well.

When we have some comprehensive system health monitoring daemon
that does check these files, and can be configured to raise suitable alerts,
then the printks can go away.

-Tony
