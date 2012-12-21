Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab2LUOGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:06:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:52719 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2LUOGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:06:44 -0500
From: Torben Hohn <torbenh@linutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Marek Vasut <marex@denx.de>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Improve timer Resolution on imx28
Date: Fri, 21 Dec 2012 15:06:14 +0100
Message-Id: <1356098776-10498-1-git-send-email-torbenh@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this Series increases the timer frequency and decreases min_delta_ns.
I saw pretty high max latencies with cyclictest: ~600us.

The cause was the min_delta_ns value of 0xf 32kHz clockcycles.
But with the 32kHz Clock, the period is still around 30us.
So we just increase the clock freqeuncy driving the timers
here.


