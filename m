Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0GNMjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 08:39:37 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:43507 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553Ab0GNMjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 08:39:35 -0400
Date: Wed, 14 Jul 2010 14:39:29 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>, Jiri Pirko <jpirko@redhat.com>,
        Joe Perches <joe@perches.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Tejun Heo <tj@kernel.org>,
        Dongdong Deng <dongdong.deng@windriver.com>,
        Jiri Kosina <jkosina@suse.cz>, Samuel Ortiz <samuel@sortiz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roel Kluin <roel.kluin@gmail.com>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Alessandro Rubini <rubini@unipv.it>, Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 00/11] Removing dead code
Message-ID: <cover.1279110894.git.siccegge@cs.fau.de>
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

        I've been running a check on the drivers/net sourcetree for
config Items not defined in Kconfig and found 11 such
cases. Sourcecode blocks depending on these Items are not reachable
from a vanilla kernel -- dead code. I've seen such dead blocks made on
purpose e.g. while integrating new features into the kernel but
generally they're just useless.

        Each of the patches in this patchset removes on such dead
config Item, I'd be glad if you consider applying them. I've been
doing deeper analysis of such issues before and can do so again but
I'm not so sure they were fastly usefull.

        I build the patches against a vanilla kernel in order to
try if the kernel compiles with this patches

        Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

        Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

Christoph Egger (11):
  Removing dead RT2800PCI_SOC
  Removing dead {AR,WAVE}LAN
  Removing dead CASSINI_QGE_DEBUG
  Removing dead CASSINI_MULTICAST_REG_WRITE
  Removing dead CASSINI_NAPI
  Removing dead CHELSIO_T1_COUGAR
  Removing dead ARCH_PNX010X
  Removing dead SH_HICOSH4
  Removing dead ETRAX_NETWORK_RED_ON_NO_CONNECTION
  Removing dead NETWINDER_{T,R}X_DMA_PROBLEMS
  Removing dead REDWOOD_{5,6}

 drivers/net/Space.c                     |    6 --
 drivers/net/cassini.c                   |   25 +--------
 drivers/net/cassini.h                   |    4 -
 drivers/net/chelsio/subr.c              |   48 +---------------
 drivers/net/cris/eth_v10.c              |    4 -
 drivers/net/cs89x0.c                    |   96 +------------------------------
 drivers/net/cs89x0.h                    |    4 -
 drivers/net/irda/w83977af_ir.c          |   33 +---------
 drivers/net/smc91x.h                    |   37 ------------
 drivers/net/wireless/rt2x00/Kconfig     |    5 --
 drivers/net/wireless/rt2x00/rt2800pci.c |   39 -------------
 11 files changed, 9 insertions(+), 292 deletions(-)

