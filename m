Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab0GUN5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:57:40 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:61997 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719Ab0GUN5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:57:38 -0400
Date: Wed, 21 Jul 2010 15:57:35 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Vasu Dev <vasu.dev@intel.com>, Nick Cheng <nick.cheng@areca.com.tw>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 0/3] Removing dead code (also drivers/scsi/arm/acornsci.c)
Message-ID: <cover.1279719754.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
       
        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

        I've been running a check on the drivers/scsi sourcetree for
config Items not defined in Kconfig and found  3 such cases. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

        Each of the patches in this patchset removes on such dead
config Item, I'd be glad if you consider applying them. I've been
doing deeper analysis of such issues before and can do so again but
I'm not so sure they were fastly usefull.

        I build the patches against a vanilla kernel in order to
try if the kernel compiles with this patches

        Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

        Christian Dietrich

[0] http://vamos1.informatik.uni-erlangen.de/

Christian Dietrich (3):
  drivers/scsi: Remove dead CONFIG_WD33C93_PIO
  drivers/scsi/arcmsr: Remove dead CONFIG_SCSI_ARCMSR_RESET
  drivers/scsi: Removing dead CONFIG_AIC7XXX_PROC_STATS

 drivers/scsi/aic7xxx/aic7xxx_osm.c |   10 ----
 drivers/scsi/arcmsr/arcmsr_hba.c   |   80 ------------------------------------
 drivers/scsi/wd33c93.c             |   60 ---------------------------
 drivers/scsi/wd33c93.h             |    5 --
 4 files changed, 0 insertions(+), 155 deletions(-)

