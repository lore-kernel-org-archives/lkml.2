Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab1AFKEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:04:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44402 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1AFKEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:04:21 -0500
Date: Thu, 6 Jan 2011 11:04:16 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH 4/9] fb: export fb mode db table
Message-ID: <20110106100416.GD26009@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
 <1291902441-24712-5-git-send-email-s.hauer@pengutronix.de>
 <20110106072658.GB15914@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106072658.GB15914@linux-sh.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:54:07 up 2 days, 18:01, 21 users,  load average: 0.05, 0.08,
 0.08
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 04:26:58PM +0900, Paul Mundt wrote:
> On Thu, Dec 09, 2010 at 02:47:16PM +0100, Sascha Hauer wrote:
> > The different modes can be useful for drivers. Currently there is
> > no way to expose the modes to sysfs, so export them.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> I'll admit I don't really like the idea of exposing the modedb to drivers
> in this way, but given that we're already doing it for the vesa and cea
> modes, allowing drivers to copy ranges in to their modelist from the
> standard db is probably something we can live with.
> 
> The mode list dumping is basically a blatant sysfs abuse already though,

You mean the available modes should not be exposed to sysfs? I found it
quite convenient to have during development. Exporting the modedb seemed
to be the only way to populate sysfs with a sane set of modes.

> and it would be much cleaner simply to back the mode store with an
> fb_find/try_mode() pair that grovels all the right places in addition to
> doing a pass over the fb_info's modelist.

The kernel provides no way to query the modelist other than sysfs. So
when the modelist dumping is a sysfs abuse, what purpose does the
modelist have anyway?

Right now the behaviour is quite strange. Each time a new (formerly
unknown) mode is selected the modelist magically gets a new entry. So
the kernel normally starts with an empty (or one entry from startup)
modelist and gets populated over time with the modes the user used.

I could understand when we say: "We do not keep the modelist in kernel,
do this in userspace". I could also understand when we say "we keep a
list of sane modes in the kernel, use fbset to switch to exotic modes".
ATM we do the worst of both: We keep a list but we do not populate it
with sane modes. Even worse, we use it to store the history of modes.

I know much of this comes from the fact that the fb subsystem does not
have a maintainer and nowadays the big desktop guys are not using the fb
subsystem at all, but it's really hard to find a way through and every
driver seems to have it's own idea of how things should work.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
