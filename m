Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0JNP4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:56:44 -0400
Received: from mailhost-r6-m2.nerim.net ([78.40.49.196]:54059 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755342Ab0JNP4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:56:43 -0400
From: Damien Wyart <damien.wyart@free.fr>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        tmhikaru@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
References: <20101014145813.GA2185@brouette> <1287070161.31864.243.camel@mini>
Date: Thu, 14 Oct 2010 17:56:16 +0200
In-Reply-To: <1287070161.31864.243.camel@mini> (Chase Douglas's message of
	"Thu, 14 Oct 2010 11:29:21 -0400")
Message-ID: <87vd54u5sv.fsf@free.fr>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chase Douglas <chase.douglas@canonical.com> [101014 17:29]:
> My biggest testing concern is that in reality, load on a normal
> desktop machine (i.e. not some stripped down machine disconnected from
> network or any other input running nothing but busybox) should not be
> 0.00. Maybe load on a server doing absolutely nothing could be 0.00,
> but there's usually something going on that should bump it up to a few
> hundredths. Watch top, and if you see at least 1% constant cpu usage
> there, your load average should be at least 0.01. That said, there
> does seem to be a bug somewhere as a load of 0.60 on an idle machine
> seems high.

FWIW, I'm using htop which maybe behaves differently than top, but after
a few seconds or tens of seconds, values are really stabilizing at 0.00
(displaying 0.01 from time to time, but quite rarely). I also get 0.00
through calling "uptime".

These tests have been done on a big desktop machine accessed remotely
through ssh, so the usual graphical environment eyecandy and Web browser
are not running at all, and I have been careful not to run heavy
processes in parallel, so reaching 0.00 doesn't seem abnormal in that
case.

As you wrote, the "bad" case with the commit applied and nohz=yes really
seems wrong because in the same conditions, idle load is several tens
orders of magnitude larger.

-- 
Damien
