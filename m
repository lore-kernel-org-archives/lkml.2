Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0KGVgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:36:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46484 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab0KGVgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:36:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=wOEh1mpvaRXN/yKARyhZnGYm9pYeJp9xcFJeB/xHQiOaugMV9reQCdNLeynAhOrDxh
         Gk3isnRpjoioUCGQ4qZIg2X5uwCfPwCENQBndWJBCKO3VaL1ybrJwywHgrVbGd6P3xcJ
         GDDNZQzRRarAm5hFF+TQG5Au0MTw+M71ozC4c=
MIME-Version: 1.0
Date: Sun, 7 Nov 2010 23:36:09 +0200
Message-ID: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
Subject: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <greg@kroah.com>, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The situation of tidspbridge driver on staging has been pretty sad,
basically, it has never worked. This is a step backwards from the
previous situation where it was clear which branch to use to get it
working. Unfortunately, the ARM and OMAP trees haven't made it easy,
as changes in those trees have broken it even further.

My proposal to get this fixed is:

1) Revert back the iommu changes

Presumably, in order to get the migration to omap iommu working many
dependencies are needed, which haven't been merged yet. And at least I
have never seen it working, although Fernando claims to have the right
set of patches to do so. I say merging this was premature.

I have reverted back those changes in:
 git://gitorious.org/~felipec/linux-omap/felipec.git fc-dsp-iommu-revert-v37-rc1

That would have been enough for 2.6.36, but...

2) Apply the fixes for recent omap control changes

On 2.6.37-rc1, omap platform internals changed, so the build is broken
again. Paul Walmsley provided some reference patches that I have
modified slightly.

3) Fix for memblock

Changes in memblock also broke this driver, one patch of mine should
fix that, as well as prepare it for imminent changes from the ARM
tree.

All the changes are in:
 git://gitorious.org/~felipec/linux-omap/felipec.git fc-dsp-fix-v37-rc1

With this, the driver should work on 2.6.37, and would be the first
time it does so on staging.

I didn't see any point in sending the patches to review the reverts,
I'm going to send the rest of the patches on top of the branch
fc-dsp-iommu-revert-v37-rc1.

These are the changes since v2.6.37-rc1:

Felipe Contreras (13):
      Revert "staging: tidspbridge - update Kconfig to select IOMMU module"
      Revert "staging: tidspbridge - remove dmm custom module"
      Revert "staging: tidspbridge - deprecate
reserve/unreserve_memory funtions"
      Revert "staging: tidspbridge - remove reserved memory clean up"
      Revert "staging: tidspbridge: remove dw_dmmu_base from cfg_hostres struct"
      Revert "staging: tidspbridge - move all iommu related code to a new file"
      Revert "staging: tidspbridge - remove hw directory"
      Revert "staging: tidspbridge - fix mmufault support"
      Revert "staging: tidspbridge - remove custom mmu code from tiomap3430.c"
      Revert "staging: tidspbridge - rename bridge_brd_mem_map/unmap
to a proper name"
      Revert "staging: tidspbridge - move shared memory iommu maps to
tiomap3430.c"
      Revert "staging: tidspbridge: replace iommu custom for
opensource implementation"
      omap: dsp: remove shm from normal memory

Paul Walmsley (4):
      omap: control: add functions for DSP boot
      omap: pm: use control functions in DSP reset code
      omap: dsp: add boot control functions
      staging: tidspbridge: use boot control functions

Cheers.

-- 
Felipe Contreras
