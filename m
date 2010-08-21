Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0HUJvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:51:44 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48743 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750994Ab0HUJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:51:41 -0400
Date: Sat, 21 Aug 2010 11:51:37 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Robert Hancock <hancockrwd@gmail.com>, Tejun Heo <tj@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jeff Garzik <jgarzik@pobox.com>, pavel@ucw.cz, rpurdie@rpsys.net,
        lenz@cs.wisc.edu, arminlitzel@web.de, thommycheck@gmail.com,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>
Subject: Re: zaurus pata_pcmcia corrupted filesystem
Message-ID: <20100821095137.GA22301@atrey.karlin.mff.cuni.cz>
References: <20100811144410.GA12029@atrey.karlin.mff.cuni.cz> <20100814094353.GB926@boggieman.bredbandsbolaget.se> <1281782580.6707.1.camel@utx.lan> <20100814113937.GB9346@atrey.karlin.mff.cuni.cz> <1281795351.15157.3.camel@utx.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281795351.15157.3.camel@utx.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > These seems to be different, at least it newer occured so often to me. Now
> > installing debian packages often fails because it cannot remove temporary
> > files, the filesystem worked reasonably good before.
> > 
> > The usecase is to unpack archive with a lot rather small files somewhere deeper
> > to the filesystem tree. Eg. installing gtk2-devel failed miserably when trying
> > to move all the header files from *.h.dpkg-new to *.h, this works rather good
> > with old driver.
> 
> Well, I remember opkg crashes while installing emacs (many small files)
> and file system corruption as well. Both with kernel 2.6.26.
>

The main difference is that now it's 100% reproducible and I've never seen
corruption bad enough so I could not delete files without doing fsck first.

Here is pseudo output from fsck on ext3 filesystem after these problems
appeared:

Pass 2:

Bunch of these:

Invalid HTREE directory inode $NUMBER
$PATH/$FILE
Clear HTree index<y>?

and these:

Problem in HTree directory inode $NUMBER: block #$NR has bad max hash

Pass 3:

Bunch of:

Entry '$FILE in $PATH ($NUMBER) has a non-unique filename.
Rename to $FILE~0<y>?

Happily the files/directories affected was only the recently written from the
kernel from marex tree.  I haven't seen file content to be corrupted (that
doesn't mean there weren't any corruptions) but it seems they are not so likely
as directory tree corruption.

-- 
metan
