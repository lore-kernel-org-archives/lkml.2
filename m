Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0HNLjk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 07:39:40 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51651 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755951Ab0HNLjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 07:39:39 -0400
Date: Sat, 14 Aug 2010 13:39:38 +0200
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
Message-ID: <20100814113937.GB9346@atrey.karlin.mff.cuni.cz>
References: <20100811144410.GA12029@atrey.karlin.mff.cuni.cz> <20100814094353.GB926@boggieman.bredbandsbolaget.se> <1281782580.6707.1.camel@utx.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281782580.6707.1.camel@utx.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > > Marek Vasut ported deprecated zaurus pcmcia disk driver to the pata_pcmcia
> > > interface, sources are here:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/marex/pxa-linux-2.6.git;a=shortlog;h=refs/heads/zaurus-haxing
> > > 
> > > Everythig seems to be fine at the first look but sometimes the filesystem gets
> > > unconsistent. Typical example is extracting tar archive with big number of
> > > files and directories (I used ltp-full archive from
> > > http://www.sf.net/projects/ltp/). After doing that, some files or directories
> > > are present in the filesystem, eg. you can see them in directory listing but
> > > open or fstat returns ENOENT.
> > > 
> > > Extracting to SD card seems to work without any problems.
> > > 
> > > Anybody has idea what went wrong?
> > 
> > What kind of number of files (in tar archive) are we talking about in round
> > figures? Does the files it affect differ in size (large fail, small doesnt)..?
> > Its hard to say without having more data (as always).
> 
> These mysterious failures were discussed several times before in
> zaurus-devel[1][2][3][4][5][6]. We suspected PCMCIA code, RAM errors or
> bad voltage.
> 
> Typical reproducers:
> 
> git status on kernel tree (false result)
> copy files from CF to SD or USB (errors in files)
> gcc while using CF WLAN or CF Bluetooth (segfault)
> 
> It happened in all kernels at least since 2.6.26, but probably in all
> 2.6 kernels.
>

These seems to be different, at least it newer occured so often to me. Now
installing debian packages often fails because it cannot remove temporary
files, the filesystem worked reasonably good before.

The usecase is to unpack archive with a lot rather small files somewhere deeper
to the filesystem tree. Eg. installing gtk2-devel failed miserably when trying
to move all the header files from *.h.dpkg-new to *.h, this works rather good
with old driver.

-- 
Cyril Hrubis
