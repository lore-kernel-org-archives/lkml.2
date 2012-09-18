Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2IRAg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 20:36:29 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46836 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2IRAg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 20:36:28 -0400
From: John Stultz <john.stultz@linaro.org>
To: stable@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] 2.6.35-stable timekeeping fixes merged in 3.6
Date: Mon, 17 Sep 2012 20:36:17 -0400
Message-Id: <1347928580-22833-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091800-5406-0000-0000-00000060FE67
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
  2.6.35.y: time: Improve sanity checking of timekeeping inputs
  2.6.35.y: time: Avoid making adjustments if we haven't accumulated
    anything
  2.6.35.y: time: Move ktime_t overflow checking into
    timespec_valid_strict

 include/linux/ktime.h     |    7 -------
 include/linux/time.h      |   29 +++++++++++++++++++++++++++--
 kernel/time/timekeeping.c |   19 ++++++++++++++++++-
 3 files changed, 45 insertions(+), 10 deletions(-)

-- 
1.7.9.5

