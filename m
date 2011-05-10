Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab1EJU6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:58:38 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40864 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750750Ab1EJU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:58:36 -0400
Date: Tue, 10 May 2011 22:58:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andrew Lutomirski <luto@mit.edu>, Anton Vorontsov <cbou@mail.ru>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [ibm-acpi-devel] [RFC] Controlling the ThinkPad battery charger
Message-ID: <20110510205832.GC7485@elf.ucw.cz>
References: <BANLkTinWna2sDDjbNC5xyGX3ELROs=Wd0w@mail.gmail.com>
 <20110509144546.GB13275@khazad-dum.debian.net>
 <BANLkTikB2TFF12vdwLqV9NRw4meEyDjvdA@mail.gmail.com>
 <20110509152941.GD13275@khazad-dum.debian.net>
 <20110510184302.GA15631@localhost.ucw.cz>
 <20110510195753.GA5850@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510195753.GA5850@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Hmm, I jave a battery pack with reasonably good cells, but firmware killed
> > it. IOW available for testing.
> 
> That is likely a problem with the battery pack uC, we cannot override that
> using any know firmware path in the ThinkPad.
> 
> Does the thinkpad recognizes the presence of the battery pack?  If it
> doesn't, the pack uC is probably dead or in safe mode, and you'd need to
> hardware-hack it.

Yes, it does, and it reports everything ok... (Battery 100% full
IIRC). Its just that machine dies immediately when AC is removed.

> > (And who know, perhaps recalibrate command would bring it back to life?)
> 
> AFAIK, the recalibrate command really just does this:
> 
> 1. sets 'force discharge' flag on EC so that it starts discharging the
>    battery pack.  Discharging stops when cell voltage drops close to the
>    minimum safety level.
> 
> 2. sets stop threshold to 0 (100%) for that battery pack.
> 
> That way, the box will fully-drain the pack, and then charge it to full. At
> that point, the recalibration is complete (the battery pack uC will
> auto-calibrate itself when it notices it has hit the fully-drained and
> fully-charged points).
> 
> You can monitor per-cell-group voltages through tp_smapi on a original IBM
> battery pack, that functionality should still be around on the Lenovos.
> Since this is not standard SBS functionality, it might not work on
> non-original battery packs.

IIRC I tried playing with tp_smapi and did not get anything
useful. The pack should be original, and I guess I should try again.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
