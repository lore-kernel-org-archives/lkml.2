Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1DOQ5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:57:41 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58866 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752947Ab1DOQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:57:39 -0400
Date: Fri, 15 Apr 2011 18:57:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [uclinux-dist-devel] [linux-pm] freezer: should barriers be
 smp ?
Message-ID: <20110415165737.GA23812@elf.ucw.cz>
References: <BANLkTinj3y+-VhzFAPz8Gzb5vAbtUFU6Aw@mail.gmail.com>
 <Pine.LNX.4.44L0.1104131757430.2005-100000@iolanthe.rowland.org>
 <20110415162938.GA11454@atrey.karlin.mff.cuni.cz>
 <BANLkTikaymG-5-YoTnG2SPJCnBtXPpfHBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikaymG-5-YoTnG2SPJCnBtXPpfHBQ@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> The existing code is correct but it isn't optimal.
> >>
> >> wmb() and rmb() are heavy-duty operations, and you don't want to call
> >> them when they aren't needed.  That's exactly what smp_wmb() and
> >> smp_rmb() are for -- they call wmb() and rmb(), but only in SMP
> >> kernels.
> >>
> >> Unless you need to synchronize with another processor (not necessarily
> >> a CPU, it could be something embedded within a device), you should
> >> always use smp_wmb() and smp_rmb() rather than wmb() and rmb().
> >
> > Maybe; but this code is not performance critical and I believe being
> > obvious here is better...
> 
> isnt it though ?  especially when we talk about suspending/resuming on
> embedded systems to get more savings over just cpu idle ?  we want
> that latency to be as low as possible.

Feel free to measure the difference. I bet it is lost in noise,
freezer just is not _that_ hot path.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
