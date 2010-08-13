Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923Ab0HMBU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 21:20:56 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:36144 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab0HMBUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 21:20:53 -0400
Date: Fri, 13 Aug 2010 03:20:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Cloning arch-independant KConfig
Message-ID: <20100813012052.GA2079@merkur.ravnborg.org>
References: <20100812233837.GG22777@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100812233837.GG22777@mail.oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 04:38:37PM -0700, Joel Becker wrote:
> Sam,
> 	I guess this is either a feature request or just wondering
> whether KConfig supports this idea.
> 	Often I have a wonderful minimal .config that builds a test
> kernel.  It only compiles the things I want in my kernel and modules,
> nothing more.  Usually I start from a distro kernel and then keep
> turning things off until I reach some minimum.
> 	However, when I get a new machine of a different architecture, I
> can't bring that work forward.  If I take this .config to that arch, the
> oldconfig just breaks.  I don't get good defaults for the arch-specific
> stuff.  Conversely, if I start from a distro .config for the new arch, I
> have to repeat all the whittle-down work.
> 	Is there any way to "extract" the non-arch-specific config
> values?  Essentially, all the "use USB, build ext3, give me these
> network cards" fields should be kept, but I want to start from a default
> architecture config.

Today there are a few ways you can do so already.
Say that you have saved away the known good one as "good", which is
a direct copy of your .config.

Then you can do for example:
KCONFIG_ALLCONFIG=good make alldefconfig

This will produce a config wich is almost equal to what you had before,
and with defaults for all new stuff.
I tested it where I used a sparc defconfig as input to a i386
config and it just worked.

Another possibility:
If you already have configured your kernel, but want to use
"good" but keep the settings for all the new stuff.
Then you can do:

cat .config good > new
mv new .config
make menuconfig

This will trigger a lot of override warnings - which you just ignore.
Resulting config is then mostly from "good".

We do not have a way to say "copy only non-arch specific settings".
So I hope the above is OK.

	Sam
