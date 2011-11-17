Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1KQWFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:05:34 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60477 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab1KQWFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:05:33 -0500
Message-ID: <1321567402.25715.35.camel@work-vm>
Subject: Re: [PATCH 15/16] time: Update tiemkeeper structure using a local
 shadow
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Date: Thu, 17 Nov 2011 14:03:22 -0800
In-Reply-To: <1321329846-14755-16-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
	 <1321329846-14755-16-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11111722-9360-0000-0000-000000B5C909
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 20:04 -0800, John Stultz wrote:
> Uses a local shadow structure to update the timekeeper. This
> reduces the timekeeper.lock hold time.
> 
> WARNING: This introduces a race, but the window might be provably
> so small as to not be observable. This patch needs lots more math
> and comments to validate that assumption.

Bah. After thinking about it, this patch won't work, since it would
possibly lose updates via settimeofday(), etc.

So I'm coming around to Thomas' double lock reader-seq/writer-lock
method.

thanks
-john

