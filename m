Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0GUPXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:23:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab0GUPXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:23:30 -0400
Subject: Re: CONFIG_SCSI_G_NCR5380_MEM dead?
From: James Bottomley <James.Bottomley@suse.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
In-Reply-To: <201007211512.03147.linux@rainbow-software.org>
References: <86pqyhhtut.fsf@peer.zerties.org>
	 <201007211512.03147.linux@rainbow-software.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 08:23:22 -0700
Message-ID: <1279725802.20250.33.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 15:12 +0200, Ondrej Zary wrote:
> On Wednesday 21 July 2010, Christian Dietrich wrote:
> > Hi all!
> >
> >         As part of the VAMOS[0] research project at the University of
> > Erlangen we are looking at multiple integrity errors in linux'
> > configuration system.
> >
> >         I've been running a check on the drivers/scsi sourcetree for
> > config Items not defined in Kconfig and found such a case. Sourcecode
> > blocks depending on these Items are not reachable from a vanilla
> > kernel -- dead code. I've seen such dead blocks made on purpose
> > e.g. while integrating new features into the kernel but generally
> > they're just useless.
> >
> > I encountered, that the CONFIG_SCSI_G_NCR5380_MEM symbol in
> > drivers/scsi/g_NCR5380.c isn't defined anywhere. So this codeblocks
> > seems to be unreachable. But there is a define in g_NCR5380_mmio.c for
> > SCSI_G_NCR5380_MEM with an include of g_NCR5380.c. So i think this is a
> > typo-bug and it should be a CONFIG_ define. The code wasn't changed since
> > linux is in git, so probably no one has used the mmio module, cause
> > there can't be a difference to the normal pio module. If you think this
> > ifdefs should be removed, i can send a patch.
> 
> I fixed this some time ago but the patches are still not in mainline. You can 
> find them in -mm tree: http://userweb.kernel.org/~akpm/mmotm/

So you made me rather reluctant by reporting that the rewrite didn't
actually work for you.  I'm rather wary of transforming non-compiled
code into non-working code in case we lose some clue in the process.
However, if you can get it working, I'll be delighted to apply it.

James



