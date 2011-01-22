Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1AVKgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 05:36:55 -0500
Received: from www.tglx.de ([62.245.132.106]:53835 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab1AVKgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 05:36:53 -0500
Date: Sat, 22 Jan 2011 11:36:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torben Hohn <torbenh@gmx.de>
cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com
Subject: Re: [PATCH 02/18] provide xtime_update() which does not require
 holding xtime_lock like do_timer()
In-Reply-To: <1295651224-29823-3-git-send-email-torbenh@gmx.de>
Message-ID: <alpine.LFD.2.00.1101221131000.2971@localhost6.localdomain6>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de> <1295651224-29823-3-git-send-email-torbenh@gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011, Torben Hohn wrote:

> some arch code failed to lock the xtime_lock.
> and some code looks like its using the xtime_lock to protect
> other stuff.

That's not a good argument for creating xtime_update().

The point is that do_timer() needs to write lock xtime_lock and we
want to avoid the duplicated code all over the place.

The fact that some of the architectures have other code in the
xtime_lock protected region is completely irrelevant for this
change. That needs to be addressed by the arch specific patches.

> +
> +/* xtime_update - updates the timer infrastructure.

Please use proper kernel doc style. Also it does not update the timer
infrastructure, it's the timekeeping update.

The comment should also document, that this code needs to be called
with interrupts disabled.

Thanks,

	tglx
