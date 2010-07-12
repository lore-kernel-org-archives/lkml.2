Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0GLUAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:00:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53183 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab0GLUAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:00:21 -0400
Date: Mon, 12 Jul 2010 21:59:56 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100712195956.GC14425@pengutronix.de>
References: <20100614083214.GA2104@pengutronix.de> <20100630104043.GG11746@pengutronix.de> <20100712155518.GA24144@pengutronix.de> <AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com> <20100712173228.GC9897@n2100.arm.linux.org.uk> <AANLkTinxUqzxClVDTyruJ6kzFTganXUGJJHJ5wRi9Iak@mail.gmail.com> <20100712185029.GB14425@pengutronix.de> <AANLkTinOuU-VVXaMwMp69CBp2Y4wxpoWybEQ34H5j0lJ@mail.gmail.com> <alpine.LFD.2.00.1007121510260.10598@xanadu.home> <AANLkTim-O00n9YPv7w4VCKjN-ETLijyTHomWUn4mZtTV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim-O00n9YPv7w4VCKjN-ETLijyTHomWUn4mZtTV@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Linus,

On Mon, Jul 12, 2010 at 12:34:59PM -0700, Linus Torvalds wrote:
> On Mon, Jul 12, 2010 at 12:17 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> >>
> >>    Put another way: I realize that fairly late in the -rc series is
> >> actually a really good time to do this, rather than during the merge
> >> window itself when things are in flux. However, while it would be a
> >> good time to pull this for that reason, it's also a _horrible_ time to
> >> pull if it then regresses the defconfig uses, or if it causes horrible
> >> problems for linux-next merging etc.
> >
> > This cannot be any worse than wholesale removal of those files as you
> > were contemplating at some point.  Furthermore, on ARM we have someone
> > providing automatic rebuild of all defconfigs already, so any serious
> > issue should be noticed right away.
> 
> You aren't really answering the question. The thing is, the wholesale
> removal wouldn't happen during the late -rc anyway, and it wouldn't
> cause any merge issues (merge conflicts where the file is just to be
> removed are trivial to take care of).
> 
> So I'm really asking about the issue of "how does this work during the
> late -rc phase". Where the _timing_ is the important thing.
> 
> Because I could as easily pull after 2.6.35 is out. That has it's own
> downsides (with all the merging going on), but at the same time, it's
> clearly the right time for a large change.
I hoped you to pull this in during the merge window, but doing it now is
OK for me, too.
 
> So when I ask about timing and "how does this work in late -rc", it's
> really about how safe it is to do now. Because if it isn't very
> obviously safe, I can't pull it.
> 
> One part of the "obviously safe" thing is verification for each
> defconfig file that the end result is identical with the reduced
> version. Uwe implied that it was, and that was clearly the intention,
> but was there some explicit verification that yes, the
> before-and-after configurations are 100% the same?
I'm pretty sure it's 100% save as I only kick a line in the defconfig if
the result doesn't change.  Well, modulo bugs in my script.  But now
that it's public you can convince yourself it's (hopefully) correct.
 
> Also, I assume that while it's _mostly_ a transparent change to users,
> it does require that people do "make oldconfig" with the reduced
> defconfig file first, in order to avoid having to answer with the
> defaults. No?
No, $(make ..._defconfig) is enough to get the full .config.

>               And the reduced defconfig files obviously do depend on
> the default in the Kconfig files themselves, so it does have that kind
> of fairly subtle semantic change that may not be entirely obvious or
> easy to notice.
Right.

> So from a timing standpoint, I just want to be convinced that "late
> -rc" really is the right thing. I'm not entirely sure it is, even
> though I do see advantages.
> 
> > I think Uwe could provide his script and add it to the kernel tree.
> > Then all architectures could benefit from it.  Having the defconfig
> > files contain only those options which are different from the defaults
> > is certainly more readable, even on x86.
> 
> Quite possible. But maintainers would need to be on the lookout of
> people actually using the script, and refusing to apply patches that
> re-introduce the whole big thing.
> 
> I also haven't actually seen the script - I don't think Uwe ever
> posted it - so maybe it's some very fragile thing. Hard to judge on no
> real information ;^p
See attachment.  It's just:

	for each line:
		kick $line if $(make ..._defconfig) results in the same config without $line
		
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=reduce_defconfig
Content-Transfer-Encoding: 8bit

#! /usr/bin/env python
# vim: set fileencoding=utf-8 :
# Copyright (C) 2010 by Uwe Kleine-KÃ¶nig <u.kleine-koenig@pengutronix.de>

import re
import subprocess
import os
import sys

# This prevents including a timestamp in the .config which makes comparing a
# bit easier.
os.environ['KCONFIG_NOTIMESTAMP'] = 'Yes, please'

# XXX: get these using getopt
kernel_tree = '' # os.path.join(os.environ['HOME'], 'gsrc', 'linux-2.6')
arch = 'arm'
target = sys.argv[1]
defconfig_src = os.path.join(kernel_tree, 'arch/%s/configs/%s' % (arch, target))

subprocess.check_call(['make', '-s', 'ARCH=%s' % arch, target])
origconfig = list(open('.config'))
config = list(origconfig)
config_size = os.stat('.config').st_size

i = 0

while i < len(config):
    print 'test for %r' % config[i]
    defconfig = open(defconfig_src, 'w')
    defconfig.writelines(config[:i])
    defconfig.writelines(config[i + 1:])
    defconfig.close()
    subprocess.check_call(['make', '-s', 'ARCH=%s' % arch, target])
    if os.stat('.config').st_size == config_size and list(open('.config')) == origconfig:
        del config[i]
    else:
        i += 1

defconfig = open(defconfig_src, 'w')
defconfig.writelines(config)
defconfig.close()

--Kj7319i9nmIyA2yE--
