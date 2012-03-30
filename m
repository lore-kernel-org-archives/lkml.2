Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab2C3NjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:39:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:37958 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933689Ab2C3NjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:39:10 -0400
Date: Fri, 30 Mar 2012 15:39:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arun Raghavan <arun.raghavan@collabora.co.uk>
cc: LKML <linux-kernel@vger.kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] [RESEND] rlimits: Print more information when limits
 are exceeded
In-Reply-To: <1330025378-26075-1-git-send-email-arun.raghavan@collabora.co.uk>
Message-ID: <alpine.LFD.2.02.1203301455360.2542@ionos>
References: <1330025378-26075-1-git-send-email-arun.raghavan@collabora.co.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Arun Raghavan wrote:

> This dumps some information in logs when a process exceeds its CPU or RT
> limits (soft and hard). Makes debugging easier when userspace triggers
> these limits.

Why do we need to spam the logs with such information?

SIGXCPU is only ever sent by this code. If there is a signal handler
in the application it's easy to debug. If not it's even easier, the
thing will simply be killed and you get the reason printed.

For the SIGKILL case there only a limited number of reasons why a
SIGKILL is sent. So no, I rather commit a patch which removes that
ugly printk which is already there instead of adding more of them.

Thanks,

	tglx

