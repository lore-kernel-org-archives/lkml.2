Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab2ILAuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 20:50:02 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51688 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab2ILAuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 20:50:00 -0400
From: John Stultz <john.stultz@linaro.org>
To: stable@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] 3.0-stable timekeeping fixes merged in 3.6
Date: Tue, 11 Sep 2012 20:49:50 -0400
Message-Id: <1347410993-19004-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091200-5930-0000-0000-00000BF2CA49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wanted to send out a few timekeeping fixes that were merged
in 3.6 which are appropriate for -stable.

This queue backports the following fixes:
-----------------------------------------
cee58483cf56e0ba355fdd97ff5e8925329aa936    time: Move ktime_t overflow checking into timespec_valid_strict
bf2ac312195155511a0f79325515cbb61929898a    time: Avoid making adjustments if we haven't accumulated anything
4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b    time: Improve sanity checking of timekeeping inputs

I've run these through my timetest suite w/ kvm on both i386
& x86_64. But more testing would be of course appreciated.
	https://github.com/johnstultz-work/timetests

I also have patch queues for all the -stable trees that I'll be
sending out as my testing completes for those trees.

Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>

John Stultz (3):
  3.0.y: time: Improve sanity checking of timekeeping inputs
  3.0.y: time: Avoid making adjustments if we haven't accumulated
    anything
  3.0.y: time: Move ktime_t overflow checking into
    timespec_valid_strict

 include/linux/ktime.h     |    7 -------
 include/linux/time.h      |   29 +++++++++++++++++++++++++++--
 kernel/time/timekeeping.c |   36 ++++++++++++++++++++++++++++++++++--
 3 files changed, 61 insertions(+), 11 deletions(-)

-- 
1.7.9.5

