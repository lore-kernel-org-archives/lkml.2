Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1FCPHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:07:40 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:33813 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1FCPHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:07:38 -0400
X-Greylist: delayed 1731 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jun 2011 11:07:38 EDT
Date: Fri, 3 Jun 2011 10:38:24 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Waldo Bastian <bastian@kde.org>, Ryan Lortie <desrt@desrt.ca>,
        Lennart Poettering <lennart@poettering.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Heads-up: Linux make menuconfig .config vs. XDG_CONFIG_HOME
 ~/.config/ clash - perhaps resolve it while 3.0 appears?
Message-ID: <20110603143824.GA3138@elliptictech.com>
References: <20110602182431.GA26282@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602182431.GA26282@rhlx01.hs-esslingen.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-02 20:24 +0200, Andreas Mohr wrote:
> "$XDG_CONFIG_HOME defines the base directory relative to which user
> specific configuration files should be stored. If $XDG_CONFIG_HOME is
> either not set or empty, a default equal to $HOME/.config should be
> used."
[...]
> It may thus be strongly advisable to rename the default name of the
> make menuconfig kernel .config file (perhaps .config_lx / .config_linux ?)
> to completely sidestep such a (mostly user-triggered)
> problematic clash in future.

If a program can't create its config directory or file(s), presumably it
will display an error message to that effect and the user can correct the
problem: after all, this scenario only occurs when the user puts a
kernel .config file in their home directory.  I imagine that a user
which is capable of doing such a thing is also capable of deleting
files.

Furthermore, Once the ~/.config directory has been created (by running
any program that does so), this problem cannot occur.

There are many other reasons that a program might fail to access its
configuration data.  I suspect that "no space remaining" or "read-only
filesystem" are more likely than "oops, I managed to put a .config file
in my home directory before running a single program that created
~/.config/".

Administrators can prevent hapless users from accidentally putting a
.config file in their home directory by creating a .config directory by
default.  Distros could help here by putting an empty .config directory
in /etc/skel.

Renaming the .config file is obviously going to cause a lot of pain, and
there seems to be very little gain.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
