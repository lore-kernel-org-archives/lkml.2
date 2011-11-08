Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1KHEnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 23:43:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:55512 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1KHEnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 23:43:03 -0500
Message-ID: <1320727374.9419.17.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 08 Nov 2011 15:42:54 +1100
In-Reply-To: <1320726103.9419.14.camel@pasglop>
References: <1320726103.9419.14.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 15:21 +1100, Benjamin Herrenschmidt wrote:
> Hi Linus !
> 
> Me again :-) So yesterday you pulled my -next branch with the bulk of
> what happened since the last merge window up to when I left for my long
> vacation (5 weeks). Today are a few remaining nits that happened during
> that time.

 .. Add added a build fix (the defconfig change enables KVM which hits a
compile problem with some config combinations) so new pull request
bellow. Sorry about that.

Cheers,
Ben.

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Alexander Graf (1):
      powerpc/kvm: Fix build failure with HV KVM and CBE

Anton Blanchard (1):
      powerpc: Add System RAM to /proc/iomem

Benjamin Herrenschmidt (1):
      Merge remote-tracking branch 'agust/next' into merge

Dipankar Sarma (1):
      powerpc/numa: NUMA topology support for PowerNV

Geoff Levand (2):
      powerpc/ps3: Fix PS3 repository build warnings
      powerpc/ps3: Fix lv1_gpu_attribute hcall

Heiko Schocher (2):
      powerpc/5200: add support for charon board
      powerpc, tqm5200: update tqm5200_defconfig to fit for charon board.

Michael Neuling (1):
      powerpc: Add KVM as module to defconfigs

Nishanth Aravamudan (1):
      powerpc/kvm: Fix build with older toolchains

Yong Zhang (2):
      powerpc/irq: Remove IRQF_DISABLED
      powerpc/ps3: irq: Remove IRQF_DISABLED

 arch/powerpc/boot/dts/charon.dts               |  236 ++++++++++++++++++++++++
 arch/powerpc/configs/52xx/tqm5200_defconfig    |   20 ++-
 arch/powerpc/configs/ppc64_defconfig           |    4 +
 arch/powerpc/configs/pseries_defconfig         |    4 +
 arch/powerpc/include/asm/floppy.h              |    4 +-
 arch/powerpc/include/asm/lv1call.h             |    2 +-
 arch/powerpc/include/asm/xics.h                |    4 +-
 arch/powerpc/kernel/exceptions-64s.S           |    6 +-
 arch/powerpc/kernel/smp.c                      |    2 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S        |    2 +-
 arch/powerpc/mm/mem.c                          |   30 +++
 arch/powerpc/mm/numa.c                         |   24 ++-
 arch/powerpc/platforms/52xx/mpc5200_simple.c   |    1 +
 arch/powerpc/platforms/cell/beat.c             |    2 +-
 arch/powerpc/platforms/cell/celleb_scc_pciex.c |    2 +-
 arch/powerpc/platforms/cell/iommu.c            |    3 +-
 arch/powerpc/platforms/cell/pmu.c              |    2 +-
 arch/powerpc/platforms/cell/spu_base.c         |    9 +-
 arch/powerpc/platforms/powermac/pic.c          |    1 -
 arch/powerpc/platforms/powermac/smp.c          |    4 +-
 arch/powerpc/platforms/ps3/device-init.c       |    2 +-
 arch/powerpc/platforms/ps3/repository.c        |   32 ++--
 arch/powerpc/sysdev/mpic.c                     |    2 -
 arch/powerpc/sysdev/ppc4xx_soc.c               |    2 +-
 arch/powerpc/sysdev/xics/xics-common.c         |    5 +-
 drivers/ps3/ps3-vuart.c                        |    2 +-
 drivers/ps3/ps3stor_lib.c                      |    2 +-
 sound/ppc/snd_ps3.c                            |    2 +-
 28 files changed, 346 insertions(+), 65 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/charon.dts


