Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348Ab2B1TqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:46:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:52200 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965081Ab2B1TqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:46:04 -0500
Message-Id: <20120228194200.180923135@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 28 Feb 2012 19:46:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [patch 0/4] time/timekeeping: Simplify vsyscall locking
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vsyscall updates have a separate seqlock which nests into
xtime_lock. There is no point to grab another lock for nothing. All it
needs is to update the seqcount which is user space visible.

The following series cleans that up.

Thanks,

	tglx

