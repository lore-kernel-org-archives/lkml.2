Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1C3Nln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:41:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:47714 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab1C3Nlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:41:42 -0400
Date: Wed, 30 Mar 2011 15:41:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] posix clocks: replace mutex with reader/writer
 semaphore
In-Reply-To: <20110330132421.GA31771@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1103301541000.22418@localhost6.localdomain6>
References: <20110330132421.GA31771@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Richard Cochran wrote:

> A dynamic posix clock is protected from asynchronous removal by a mutex.
> However, using a mutex has the unwanted effect that a long running clock
> operation in one process will unnecessarily block other processes.
> 
> For example, one process might call read() to get an external time stamp
> coming in at one pulse per second. A second process calling clock_gettime
> would have to wait for almost a whole second.
> 
> This patch fixes the issue by using a reader/writer semaphore instead of
> a mutex.

Yuck. /me wonders why we did not see that during the review :)
 
