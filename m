Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab1CUP6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:58:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46400 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753104Ab1CUP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:58:39 -0400
Date: Mon, 21 Mar 2011 15:58:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        Zeng Zhaoming <b32542@freescale.com>
Subject: Re: [build failure] Re: [GIT PULL] sound updates for 2.6.39-rc1
Message-ID: <20110321155836.GE2570@opensource.wolfsonmicro.com>
References: <s5hr5a4ttfi.wl%tiwai@suse.de>
 <20110321153719.GA12325@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321153719.GA12325@elte.hu>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 04:37:19PM +0100, Ingo Molnar wrote:

> has been pushed upstream - although the build breakage was reported against 
> linux-next two weeks ago, with fix provided, in this lkml thread:
> 
>   [PATCH -next] soc: sgtl5000 uses regulator interfaces

Zheng, you said you'd provide a better patch for this but I've heard
nothing since?  It's a trivial change you need to make...

> Please do not push known-broken code upstream.

That seems like an overreaction, it'll only show up in fairly unrealstic
randconfigs and can be trivially avoided by anyone who actually needs
the driver - core things like all*config won't be affected, and right
now it'll only come up at all if you enable SND_SOC_ALL_CODECS which is
purely about build coverage.

> Randy's fix below resolved the bug for me.

As indicated that's not a good fix since the affected code is all
runtime conditional already.  It'd be more likely to impede than help
the sort of build coverage tests where one would encounter it.
