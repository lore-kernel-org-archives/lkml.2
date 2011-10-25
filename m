Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab1JYKL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 06:11:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47220 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1JYKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 06:11:25 -0400
MIME-Version: 1.0
Date: Tue, 25 Oct 2011 12:11:24 +0200
Message-ID: <CACRpkdZi=Vh-BfT9w_JVtL+wUPNtO41HqffD2hxoyQyT02iVcw@mail.gmail.com>
Subject: [GIT PULL] pinctrl subsystem creation
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jesper.nilsson@axis.com, Stephen Warren <swarren@nvidia.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rongjun Ying <rongjun.ying@csr.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is a new subsystem in a new git so given all the current
GnuPG signing and hoopla the probability of this being rejected
for one or another reason tends to one. But anyway, here goes:

The pinctrl subsystem is something I came up with when the
overpopulation in ARM was being highlighted. I noticed that
several platforms were reimplementing the same similar
functionality over and over, all in essentially same but different
ways.

So this tries to create a generic solution for the pin control
done in embedded systems. The idea is to get that *out* of the
arch and drivers/gpio/* files where it currently resides.
Documentation/pinctrl.txt should explain what it is trying to do
pretty well.

As proof of concept the U300 driver is converted over to this
new subsystem, and it is also expanded to serve as a good
example for others, listing all pins on the package and
implementing a showcase of stuff we can do with pinctrl.
(So yes, it is much much bigger than the driver in arch/arm
it is replacing and this is intentional.) I have also
got a driver for the SirfPrimaII SoC from Barry Song so it will
be used from day 1 on that platform. I have solid buy-in from
Stephen Warren at nVidia that this will be useful for the Tegra
chips (found in many contemporary tablets like the Xoom). I
also have Ack from GPIO maintainer Grant Likely. The Linaro
organization is going to look into converting over a number of
other SoC drivers to use pinctrl as well, and I will myself
look into converting the Nomadik/Ux500 driver.

It seems like pinctrl a crucial feature for device trees
which would otherwise have to create custom per-platform
bindings for all this stuff, defeating some of the simplification
and auto-discovery goals. I cannot claim to be an expert
in that area though, and pinctrl is nice enough anyway.
There are plans to create generic device tree bindings
for pinctrl.

It currently handles mainly pin multiplexing, but the
infrastructure for any pin control is in place, and we're already
discussing how to get complete handling of all other custom
pin-tinkering into this subsystem as well. That is why it is
named pinctrl rather than pinmux. But I did not want to
push for a TotalCompleteUpfrontDesign but try to get this
infrastructure and basic functionality in first. If it is accepted
there will for sure be more of it in the 3.3 merge window.

This subsystem has matured in linux-next for some weeks,
and is very unlikely to cause any disturbance.

The only thing it can regress is U300 and well, that's my
baby so it will just hit myself in the head.

You will find 4 patches from Stephen Warren and 1 patch
from Jean-Christophe Plaginol-Villard that have not yet
landed in linux-next - these are bug fixes that would go into
-rc1 otherwise. If you prefer I can remove them and create
a new tag for just the stuff that's been in -next, your pick.

I have signed the top commit on the for-next branch with
a for-torvalds tag using my GnuPG key (ID 0xB0195D73),
atleast it looks like that to me:

$ git tag -v for-torvalds
object ad7761ab3adc03fbf2cca8e3c84344175d876c40
type commit
tag for-torvalds
tagger Linus Walleij <linus.walleij@linaro.org> 1319534156 +0200

Signed pinctrl tag for Torvalds
gpg: Signature made Tue 25 Oct 2011 11:16:09 AM CEST using RSA key ID B0195D73
gpg: Good signature from "Linus Walleij (Linaro) <linus.walleij@linaro.org>"

(I have no clue how to fetch that single tag from my repo
or so, I just verified it by fetching all tags.)

Now to the question of whether you can trust this key:
I was unable to meet with any core kernel developers in time,
so I set up a local key-signing party here in Lund, Sweden,
and got CRIS arch mainatiner Jesper Nilsson to sign my
key. He has uploaded his signature to the pgp.mit.edu
keyserver, as can be seen here:
http://pgp.mit.edu:11371/pks/lookup?op=vindex&search=0x4110B337B0195D73

Sadly Jespers key is not in turn signed by other core
kernel developers ... yet. But:

I think Jesper is in Prague, and will participate in your key
signing party there. If you meet him, ask him if I am to
be trusted then. I guess you will have the opportunity to sign
his key so we have a chain of trust. Atleast I did an honest attempt
to do this the right way, that has to go for something.

Now you can also flame me for writing too long and
verbose pull requests...

The following changes since commit a102a9ece5489e1718cd7543aa079082450ac3a2:

  Linux 3.1-rc8 (2011-09-27 15:48:34 -0700)

are available in the git repository at:
   git://git.linaro.org/people/triad/linux-pinctrl.git for-next

Jean-Christophe PLAGNIOL-VILLARD (1):
      pinctrl/sirf: fix sirfsoc_get_group_pins prototype

Linus Walleij (2):
      drivers: create a pin control subsystem
      pinctrl: add a driver for the U300 pinmux

Rongjun Ying (1):
      pinctrl: add a driver for the CSR SiRFprimaII pinmux

Stephen Warren (4):
      pinctrl: get_group_pins() const fixes
      pinctrl: Remove unsafe __refdata
      pinctrl: Don't copy pin names when registering them
      pinctrl: Don't copy function name when requesting a pin

 Documentation/pinctrl.txt                |  950 +++++++++++++++++++++++
 MAINTAINERS                              |    5 +
 arch/arm/mach-u300/Kconfig               |    2 +
 arch/arm/mach-u300/Makefile              |    2 +-
 arch/arm/mach-u300/core.c                |   84 ++-
 arch/arm/mach-u300/include/mach/syscon.h |  136 ----
 arch/arm/mach-u300/mmc.c                 |   16 -
 arch/arm/mach-u300/padmux.c              |  367 ---------
 arch/arm/mach-u300/padmux.h              |   39 -
 arch/arm/mach-u300/spi.c                 |   20 -
 drivers/Kconfig                          |    2 +
 drivers/Makefile                         |    2 +
 drivers/pinctrl/Kconfig                  |   43 ++
 drivers/pinctrl/Makefile                 |    8 +
 drivers/pinctrl/core.c                   |  598 +++++++++++++++
 drivers/pinctrl/core.h                   |   71 ++
 drivers/pinctrl/pinmux-sirf.c            | 1215 ++++++++++++++++++++++++++++++
 drivers/pinctrl/pinmux-u300.c            | 1135 ++++++++++++++++++++++++++++
 drivers/pinctrl/pinmux.c                 | 1190 +++++++++++++++++++++++++++++
 drivers/pinctrl/pinmux.h                 |   47 ++
 include/linux/pinctrl/machine.h          |  107 +++
 include/linux/pinctrl/pinctrl.h          |  133 ++++
 include/linux/pinctrl/pinmux.h           |  117 +++
 23 files changed, 5708 insertions(+), 581 deletions(-)
 create mode 100644 Documentation/pinctrl.txt
 delete mode 100644 arch/arm/mach-u300/padmux.c
 delete mode 100644 arch/arm/mach-u300/padmux.h
 create mode 100644 drivers/pinctrl/Kconfig
 create mode 100644 drivers/pinctrl/Makefile
 create mode 100644 drivers/pinctrl/core.c
 create mode 100644 drivers/pinctrl/core.h
 create mode 100644 drivers/pinctrl/pinmux-sirf.c
 create mode 100644 drivers/pinctrl/pinmux-u300.c
 create mode 100644 drivers/pinctrl/pinmux.c
 create mode 100644 drivers/pinctrl/pinmux.h
 create mode 100644 include/linux/pinctrl/machine.h
 create mode 100644 include/linux/pinctrl/pinctrl.h
 create mode 100644 include/linux/pinctrl/pinmux.h

Yours,
Linus Walleij
