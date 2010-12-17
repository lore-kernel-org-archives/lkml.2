Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0LQXu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:50:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979Ab0LQXu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:50:58 -0500
Date: Fri, 17 Dec 2010 15:49:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] delay.h: add __must_check to msleep_interruptible
Message-Id: <20101217154947.3e95488c.akpm@linux-foundation.org>
In-Reply-To: <aed7ab07576c307653723b9bea04516879b3a3ed.1288860894.git.baruch@tkos.co.il>
References: <aed7ab07576c307653723b9bea04516879b3a3ed.1288860894.git.baruch@tkos.co.il>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Nov 2010 10:55:41 +0200
Baruch Siach <baruch@tkos.co.il> wrote:

> Code calling msleep_interruptible() must be aware that sleep time might be
> shorter than intended as a result of a signal being caught. Code not checking
> the return value of msleep_interruptible() is probably buggy, unless it's doing
> the signal_pending() check itself, which is redundant.
> 

True.  But there are around 250 callsites which don't check the
msleep_interruptible() return value.

I don't think I want to add 250 new warnings to the kernel build -
it'll take *years* to get them all weeded out and meanwhile it will
cause people to miss other warnings while they're ignoring the
msleep_interruptible() warnings.

So.  Some lucky duck needs to get down and start fixing all these
things first, please.  Meanwhile, a checkpatch rule which prevents new
occurrences would be good.

Except lots of developers and maintainers can't be assed running
checkpatch, so a volunteer who regularly runs linux-next.patch and
patch-2.6.Y-rcY through checkpatch and then hassles people would also be
good.

