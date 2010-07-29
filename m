Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0G2INY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:13:24 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:44160 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab0G2INT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:13:19 -0400
Date: Thu, 29 Jul 2010 10:13:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Aristeu Rozanski <aris@redhat.com>
Subject: Re: [RFC PATCH] kconfig: use long options in conf
Message-ID: <20100729081316.GA4990@merkur.ravnborg.org>
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728203622.GA32086@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 10:36:22PM +0200, Sam Ravnborg wrote:
> Hi Michal.
> 
> I cooked up the following to introduce long options in conf.
> But in the process I dropped the short options. Is this OK?

On top of this patch I did another two.
They fixup the *nonint_oldconfig targets:

nonint_oldconfig:
- renamed to listnewconfig
- print new options to stdout (to better support redirect)
- no longer saves a new configuration
- does ot exist with a failure code if there is new options

loose_noninit_oldconfig:
- renamed to oldnoconfig
- does ot exist with a failure code if there is new options

This is a lot cleaner and much more sensible names.
And they still support the suecase where they
list new options and can set them to n per default.

[cc: list trimmed on patches]

	Sam

Sam Ravnborg (2):
      kconfig: rename loose_nonint_oldconfig => oldnoconfig
      kconfig: change nonint_oldconfig to listnewconfig

 scripts/kconfig/Makefile |   12 +++++-------
 scripts/kconfig/conf.c   |   46 +++++++++++++++++-----------------------------
 2 files changed, 22 insertions(+), 36 deletions(-)

