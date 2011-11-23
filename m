Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1KWOMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:12:21 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:43521 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab1KWOMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:12:19 -0500
Date: Wed, 23 Nov 2011 15:12:15 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: mad_soft@inbox.ru
Cc: wim@iguana.be, w.sang@pengutronix.de, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, HaraldWelte@viatech.com,
        broonie@opensource.wolfsonmicro.com
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <4eccff3f.MbLR7E9v8jus19P8%marc.vertes@sigfox.com>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
 <20111122173029.GA14349@pengutronix.de>
 <4ecbe56d.0B7WEVDKkK1s88MJ%marc.vertes@sigfox.com>
 <4ecbf011.dZASXe6D5kH4Uxve%marc.vertes@sigfox.com>
 <20111123121051.GA18320@rainbow>
In-Reply-To: <20111123121051.GA18320@rainbow>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 18392700878907557679
X-Ovh-Remote: 92.103.90.130 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 10
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrtdehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -90
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Artamonow <mad_soft@inbox.ru> wrote:

> "via_wdt" seems to be a too generic name. What if someone will want to
> write driver for some incompatible watchdog also made by VIA?
> Maybe it's worth to use something more specific - say, "via_vx8xx_wdt"?
>
According to Harald, it is the same watchdog on all via chipsets and
back to Athlon chipsets. But why not.

> Why is to rely on BIOS setup? Is there really no information on what
> registers to write to start watchdog? Or you was just lazy to find it?
> It took me less than a minute to google up a datasheet[1] on VX800/VX820
> and it seems to have all needed information to implement proper start()
> and stop() functions. I suppose info on watchdog registers should be
> applicable to VX855 as well - but it's better to check on your hardware
> anyway.
>
> [1] http://linux.via.com.tw/support/beginDownload.action?eleid=161&fid=241
>
I rely on BIOS setup because it is the only working method on the
hardware I could test on. This watchdog stuff exists on VIA cpus for
years (back to Athlon chipsets) and still no working open
source driver. Wonder why?

Of course I read the datasheet of the VX855 southbridge prior to
write this driver. And the VX800 one, the CX700 one. Unfortunately,
the instructions to start, stop, get and set counters simply
do not work. The doc is false and/or incomplete. Harald
already implemented a full version of this driver back in 2009
(http://git.gnumonks.org/cgi-bin/gitweb.cgi?p=linux-2.6-via.git;a=shortlog;     h=refs/heads/via-wdt),
but not working. Questions to VIA remain unanswered.

So I decided to keep in the source code only what really works, and not
the well documented but non functional stuff. If you can test or find
hardware where those instructions work as advertised, I will be happy
to expose them again in an updated driver.

The current result, in addition of actually working, is safe,
simple, and compatible with potential "correct" configurations.

Regards,
--
Marc
