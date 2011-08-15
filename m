Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1HOUoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:44:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60327 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1HOUoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:44:38 -0400
MIME-Version: 1.0
In-Reply-To: <201108151604.54251.tim.sander@hbm.com>
References: <201108151604.54251.tim.sander@hbm.com>
Date: Mon, 15 Aug 2011 22:44:36 +0200
X-Google-Sender-Auth: WtHnUDFVFN9hFsr3szMNf0BhZCo
Message-ID: <CANqCtQJ-f4iWhLb3dPMVtt9sOm6+KBnS3ijEPfxOiE2_11BZDg@mail.gmail.com>
Subject: Re: CONFIG_PEEMPT_RT_FULL vs. CONFIG_PREEMPT_RTB
From: Remy Bohmer <linux@bohmer.net>
To: Tim Sander <tim.sander@hbm.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Besides of the cpu load i also found out that with rt11 i can again wake up
> usermode from a IRQF_NO_THREAD waiting on a waitqueue. So the steps outlined
> in this mail http://www.spinics.net/lists/linux-rt-users/msg06834.html do not
> seem to be neccessary anymore? Or does this create an error and than some high
> load?

Try running with CONFIG_DEBUG_SPINLOCK_SLEEP and you would probably
see some errors...

If you have CONFIG_PREEMPT_RT_FULL set, then the __wake_up function of
the waitqueue runs into a spinlock. This spinlock will be converted to
a mutex since it is a regular spinlock, not a raw_spinlock. A
mutex-lock might sleep. Calling sleeping functions from hard-irq
context is illegal.

Kind regards,

Remy
