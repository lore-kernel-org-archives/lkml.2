Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab0GNLbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:31:36 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40307 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945Ab0GNLbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:31:35 -0400
Date: Wed, 14 Jul 2010 13:31:29 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Russell King <linux@arm.linux.org.uk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Eric Miao <eric.y.miao@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
        Tejun Heo <tj@kernel.org>, Mike Frysinger <vapier@gentoo.org>,
        Lothar Wassmann <LW@KARO-electronics.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Bryan Wu <cooloney@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 0/3] Removing dead code
Message-ID: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
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

        I've been running a check on the drivers/usb sourcetree for
config Items not defined in Kconfig and found 3 such cases. Sourcecode
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
  usb/gadget: Remove dead CONFIG_USB_LANGWELL_OTG
  usb/{gadget,host}: Remove dead CONFIG_CPU_PXA27x
  usb/host || arch/arm: Remove dead CONFIG_ARCH_KARO

 arch/arm/tools/mach-types         |    1 -
 drivers/usb/gadget/langwell_udc.c |   84 +------------------------------------
 drivers/usb/gadget/langwell_udc.h |    5 --
 drivers/usb/gadget/pxa27x_udc.c   |   16 -------
 drivers/usb/host/isp1362.h        |   24 +----------
 drivers/usb/host/ohci-pxa27x.c    |    8 ----
 6 files changed, 2 insertions(+), 136 deletions(-)

