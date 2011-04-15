Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1DOQ3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:29:40 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36050 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751306Ab1DOQ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:29:39 -0400
Date: Fri, 15 Apr 2011 18:29:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [uclinux-dist-devel] freezer: should barriers be
	smp ?
Message-ID: <20110415162938.GA11454@atrey.karlin.mff.cuni.cz>
References: <BANLkTinj3y+-VhzFAPz8Gzb5vAbtUFU6Aw@mail.gmail.com> <Pine.LNX.4.44L0.1104131757430.2005-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104131757430.2005-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I believe the code is correct as is.
> > 
> > that isnt what the code / documentation says.  unless i'm reading them
> > wrong, both seem to indicate that the proposed patch is what we
> > actually want.
> 
> The existing code is correct but it isn't optimal.
> 
> wmb() and rmb() are heavy-duty operations, and you don't want to call
> them when they aren't needed.  That's exactly what smp_wmb() and
> smp_rmb() are for -- they call wmb() and rmb(), but only in SMP 
> kernels.
> 
> Unless you need to synchronize with another processor (not necessarily 
> a CPU, it could be something embedded within a device), you should 
> always use smp_wmb() and smp_rmb() rather than wmb() and rmb().

Maybe; but this code is not performance critical and I believe being
obvious here is better...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
