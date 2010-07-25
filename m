Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0GYWU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 18:20:28 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:43639 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0GYWUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 18:20:25 -0400
X-Greylist: delayed 2534 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jul 2010 18:20:25 EDT
Date: Mon, 26 Jul 2010 00:20:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] kconfig: introduce alldefconfig + savedefconfig
Message-ID: <20100725222023.GA9835@merkur.ravnborg.org>
References: <20100725213808.GA5814@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100725213808.GA5814@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> in kconfig is preferable.
> 
> This patch set introduce "alldefconfig".
> alldefconfig create a configuration with all values set
> to default values.
> This can be usefull when we check if we do have a sane
> set of default values. Rhe config can be inspected
> using menuconfig.
> 
> The patches also introduce "savedefconfig" which
> reads the current configuration and save it
> as a minimal configuration.

A funny detail that I used in my testing.

If we create a config based solely on default values like this:

   make alldefconfig

then when we later save the minimal config like this:

    make savedefconfig

then the resulting defconfig file is empty.
This is as expected because all symbols has default values
so there is no need to save the value of any symbol.

	Sam
