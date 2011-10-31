Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab1JaRda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:33:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47914 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab1JaRd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:33:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 31 Oct 2011 18:32:59 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post 3.1
Message-ID: <20111031183259.4427c1e6@stein>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9VHXdTZ009428

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git for-linus

    head sha1: a572e688cf5d99d2382016c7241ec37b523b0137

to receive the following updates for the IEEE 1394 (FireWire) subsystem.
We have got
  - some janitorial work,
  - support for the TI TSB41BA3D S400beta phy as local phy,
  - bandwidth improvement of IPv4-over-1394 between 2%...30%
    (depending on particular hardware; the gains are apparently at the
    lower end of this range in case of typical PC hardware),
  - a fix for certain topology scanning border cases,
  - DMA mapping fixes.

The latter fix introduces false runtime warnings from the DMA debug
facility.  Clemens posted a fix for that in
https://lkml.org/lkml/2011/10/15/104 and I will keep any eye on it
making its way into your tree eventually.

Everything has been in linux-next for a while, also during the
kernel.org downtime.  Since most or all of the patches were not Cc'd
to LKML, I will post the full log and diff in a follow-up.

Clemens Ladisch (2):
      firewire: ohci: work around selfID junk due to wrong gap count
      firewire: ohci: fix isochronous DMA synchronization

Stefan Richter (6):
      firewire: sbp2: remove obsolete reference counting
      firewire: sbp2: move some code to more sensible places
      firewire: sbp2: fold two functions into one
      firewire: ohci: TSB41BA3D support tweaks
      firewire: ohci: optimize TSB41BA3D detection
      firewire: use clamp and min3 macros

Stephan Gatzka (3):
      firewire: ohci: Move code from the bus reset tasklet into a workqueue
      firewire: ohci: Add support for TSB41BA3D phy
      firewire: net: Use posted writes

 drivers/firewire/core-transaction.c |    4 +-
 drivers/firewire/net.c              |   15 +--
 drivers/firewire/ohci.c             |  255 ++++++++++++++++++++++++++++++++--
 drivers/firewire/sbp2.c             |  260 +++++++++++++++--------------------
 4 files changed, 362 insertions(+), 172 deletions(-)

Thanks,
- -- 
Stefan Richter
- -=====-==-== =-=- =====
http://arcgraph.de/sr/
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBAgAGBQJOrtvYAAoJEHnzb7JUXXnQ4KQP/1MAWOaSdSNxQT4xQHL0rGxp
5Nkn9PGjnfov3mxPrLP3gYHNIsL2u17KMYjtv4IyqsjUCNt7E9DWe5o3xPGRtk8d
qhicn/9ZO++mEJzrfjcIFuslOT7kEK9AhoO0h7hwyaRpr3zWbM+Xc2HoofnIEavQ
l2qAix1CZ9dU4ISyQcopkVb30Du6y71p/ebjD4kBCgOPkdzF6TbPC3+iNcekFNWA
sUm0cDcN6perJz1gcVCf0M/dd3dvrCrEISlNGJOwSPmdrIYSb0xGZF54Kfil+OCT
5N7PDOFF21dCwu540qF1JyUVuPL/+up4rEb3ksQwHnDFckk88vr2IViU/pGFoeee
OIC+tMW6FgN/2WNgAKLZCL/QVeJfYg+VBR1Wc/0z9SMalV0cjfmRSwKLljAV9hSc
9xTxownXP4Aw5bBKHcuXAje4MlXdTnLp+L98GlMoJl2PzH/v+am/pKiN2IWBVJ7C
ZmEtOcimSzZwglj7JTuuPyZi7Uig9Su2kSgPjwkNK+HBeXVGlQAdd1FqAf/jdNRI
HyWb7F5NWbpLvSmT50TcGEJFRA3wk6k2zUqBqp5SjPlqxTmEla/96n5o24toqlq3
4dGRWVeVJOaINwJCW608KuOelFsB/7HGw2u4Wi5Im3cGxE2FZncJQ0t4FiPnet4e
MHzU84nZUZGaIwRZlBLn
=4lH3
-----END PGP SIGNATURE-----
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
