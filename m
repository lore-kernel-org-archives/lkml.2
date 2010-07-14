Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab0GNNVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:21:12 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:45153 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754734Ab0GNNVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:21:10 -0400
Date: Wed, 14 Jul 2010 15:21:06 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        Olivier Grenie <Olivier.Grenie@dibcom.fr>,
        =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        Tejun Heo <tj@kernel.org>,
        Muralidharan Karicheri <mkaricheri@gmail.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Julia Lawall <julia@diku.dk>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 0/4] Removing dead code
Message-ID: <cover.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
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

        I've been running a check on the drivers/media sourcetree for
config Items not defined in Kconfig and found 4 such cases. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

        There were also CONFIG_ options set within a source file. This
created code blocks which were always selected and compiled.

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

Christian Dietrich (4):
  drivers/media/dvb: Remove dead Configs
  drivers/media/dvb: Remove undead configs
  drivers/media/video: Remove dead CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE
  drivers/media/video: Remove dead CONFIG_OLPC_X0_1

 drivers/media/dvb/frontends/dib0090.c |  126 ---------------------------------
 drivers/media/video/omap/omap_vout.c  |    8 --
 drivers/media/video/ov7670.c          |   37 ----------
 3 files changed, 0 insertions(+), 171 deletions(-)

