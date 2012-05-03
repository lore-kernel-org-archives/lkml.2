Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab2ECT2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:28:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47184 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2ECT2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:28:35 -0400
Date: Thu, 3 May 2012 21:28:24 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
Message-ID: <20120503192823.GA5711@netboy.at.omicron.at>
References: <cover.1335510125.git.richardcochran@gmail.com>
 <4F9B228F.90903@linaro.org>
 <20120503182128.GB2254@netboy.at.omicron.at>
 <4FA2D21D.6010805@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA2D21D.6010805@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 11:44:45AM -0700, John Stultz wrote:
> But the changes you make to getnstimeofday() still needs to happen
> in the vDSO code. The vDSO code basically implements
> getnstimeofday() in userland.
> 
> If you're code is trying to make it so that the leap-second is
> properly handled at the second boundary instead of the tick
> boundary, there must me some change needed to the vDSO, since the
> vDSO code is updated only each tick. Otherwise how can you enforce
> the leap after the second boundary but before the tick?

Yeah, so the vDSO does the sub-tick interpolation, and this can easily
miss an inserted leap second for a while (just like the current code).

So, this patch series as it stands improves the users of the
traditional syscalls without hurting the superduper vDSO performance
at all. The vDSO leap second time errors are not fixed, but they are
also no worse than today, either.

I am try to say that, even if there is resistance to adding code in
the vDSO path for reasons of performance, that doesn't necessarily
mean that we cannot fix the leap second for the tradition syscall
case.

Richard
