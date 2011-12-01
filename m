Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1LAHU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:20:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41670 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1LAHUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:20:25 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3] Patches focus on clocksource_calc_mult_shift()
Date: Thu,  1 Dec 2011 15:20:13 +0800
Message-Id: <1322724016-9770-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas/John,

When I was tring to apply commit d65670a7 to old kernel, I found
it's hard to apply, the reason is we only provide
clockevents_calc_mult_shift() for a period of time. And going
through the latest kernel, there is still the user of that
function. So I think we still need the ->maxadj tweak in
clockevents_calc_mult_shift(), this is the aim of patch#1.

And to loose the burden of you, I convert the only user of
clockevents_calc_mult_shift()/clocksource_register() to
clocksour_register_hz() (patch#2), and then get rid of
clockevents_calc_mult_shift() (patch#3).

IMHO, patch#1 will be more conservative and safe, and patch#3
is a little aggressive. I will let you decide to pick which one ;-)

Thanks,
Yong


Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>

Yong Zhang (3):
  clocksource: Also tweak ->maxadj in clocksource_calc_mult_shift()
  clocksource: dbx500: convert to clocksource_register_hz()
  clocksource: get rid of clocksource_calc_mult_shift()

 drivers/clocksource/clksrc-dbx500-prcmu.c |    5 +----
 include/linux/clocksource.h               |    7 -------
 kernel/time/clocksource.c                 |    1 -
 3 files changed, 1 insertions(+), 12 deletions(-)

-- 
1.7.5.4

