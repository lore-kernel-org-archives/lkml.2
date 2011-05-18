Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1ERVdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:33:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:54544 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab1ERVdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:33:41 -0400
Message-Id: <20110518205713.947614271@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 21:33:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>
Subject: [patch 0/7] clocksources/clockevents improvements
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series provides a few improvements to the core code of
clocksources and clockevents.

1) Better layout and cacheline alignment of the hotpath data in both
   data structures

2) Get rid of the hardcoded 5 seconds sleep limit in clocksources

3) Provide a generic configuration and registration interface for
   clockevents which does all the common math tasks so we can remove
   copied code all over the place

4) Provide a function to reconfigure an active clock event
   device. Needed by devices which are affected by frequency scaling.

The last two patches are x86 specific and make use of the new
config_register() functions.

Thanks,

	tglx

