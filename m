Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab2IKTEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:04:45 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60563 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab2IKTEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:04:43 -0400
From: John Stultz <john.stultz@linaro.org>
To: stable@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] 3.4-stable timekeeping fixes merged in 3.6
Date: Tue, 11 Sep 2012 15:04:16 -0400
Message-Id: <1347390259-54838-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091119-7182-0000-0000-000002970BC3
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
  3.4.y: time: Improve sanity checking of timekeeping inputs
  3.4.y: time: Avoid making adjustments if we haven't accumulated
    anything
  3.4.y: time: Move ktime_t overflow checking into
    timespec_valid_strict

 include/linux/ktime.h     |    7 -------
 include/linux/time.h      |   29 +++++++++++++++++++++++++++--
 kernel/time/timekeeping.c |   33 +++++++++++++++++++++++++++++----
 3 files changed, 56 insertions(+), 13 deletions(-)

-- 
1.7.9.5

