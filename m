Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab2AETSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:18:43 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57115 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932324Ab2AETSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:18:41 -0500
X-Sasl-enc: ExiCYKeTrhcGDafUWz4jI2/+3D04Yv6pN2lnIKEeJlXG 1325791120
Date: Thu, 5 Jan 2012 11:18:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/67] 3.0.16-stable review
Message-ID: <20120105191813.GA5762@kroah.com>
References: <20120103223043.GA26738@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20120103223043.GA26738@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 03, 2012 at 02:30:43PM -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 3.0.16 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
>=20
> Responses should be made by Friday, January 6, 2012, 20:00:00 UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.16-rc1.gz
> and the diffstat can be found below.

Due to a few noted issues in this series, and a few last-minute
straggler patches being applied to the final 3.2 release, there's a new
3.0.16-rc2 release, which can be found at:
 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.16-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                     |    4 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 arch/arm/oprofile/common.c                   |    2 +-
 arch/arm/plat-mxc/pwm.c                      |   16 +-
 arch/s390/oprofile/init.c                    |    2 +-
 arch/sh/oprofile/common.c                    |    4 +-
 arch/sparc/include/asm/pgtable_32.h          |   20 +-
 arch/sparc/include/asm/pgtable_64.h          |   20 +-
 arch/sparc/kernel/entry.h                    |    7 +
 arch/sparc/kernel/module.c                   |   27 +
 arch/sparc/kernel/pci_sun4v.c                |    4 +-
 arch/sparc/kernel/setup_64.c                 |   48 +-
 arch/sparc/kernel/signal32.c                 |   18 +-
 arch/sparc/kernel/signal_32.c                |   30 +-
 arch/sparc/kernel/signal_64.c                |   42 +-
 arch/sparc/kernel/visemul.c                  |   32 +-
 arch/sparc/lib/memcpy.S                      |  804 ++++------------------=
----
 arch/sparc/mm/Makefile                       |    1 -
 arch/sparc/mm/btfixup.c                      |    3 +-
 arch/sparc/mm/generic_32.c                   |   98 ----
 arch/sparc/mm/generic_64.c                   |  164 ------
 arch/x86/net/bpf_jit_comp.c                  |    4 +-
 block/blk-core.c                             |   14 +-
 block/cfq-iosched.c                          |   16 +-
 drivers/gpu/drm/i915/i915_dma.c              |   10 +
 drivers/gpu/drm/i915/i915_drv.h              |    1 +
 drivers/gpu/drm/radeon/evergreen.c           |   12 +
 drivers/gpu/drm/radeon/radeon_atombios.c     |    6 +-
 drivers/input/mouse/synaptics.c              |   11 +
 drivers/media/video/s5p-fimc/fimc-core.c     |    2 +-
 drivers/mfd/twl-core.c                       |   16 +-
 drivers/mfd/twl4030-madc.c                   |   35 +-
 drivers/mmc/host/mmci.c                      |   14 +-
 drivers/mmc/host/vub300.c                    |    2 +-
 drivers/net/pptp.c                           |    4 +-
 drivers/net/wireless/ath/ath9k/main.c        |    3 +
 drivers/net/wireless/ath/ath9k/rc.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   10 +-
 drivers/oprofile/oprofile_files.c            |    7 +-
 drivers/oprofile/oprofilefs.c                |   11 +-
 drivers/rtc/interface.c                      |   44 +--
 drivers/rtc/rtc-m41t80.c                     |    9 +
 drivers/s390/scsi/zfcp_scsi.c                |    4 +
 drivers/scsi/fcoe/fcoe.c                     |    1 +
 drivers/scsi/mpt2sas/mpt2sas_base.c          |   59 +--
 drivers/scsi/mpt2sas/mpt2sas_base.h          |    4 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |    2 +-
 drivers/ssb/driver_pcicore.c                 |    8 +-
 drivers/watchdog/hpwdt.c                     |    5 +-
 drivers/xen/swiotlb-xen.c                    |    2 +-
 fs/nfs/nfs4state.c                           |    8 +-
 fs/nilfs2/ioctl.c                            |   13 +
 fs/xfs/linux-2.6/xfs_super.c                 |   30 +-
 fs/xfs/linux-2.6/xfs_sync.c                  |   37 ++
 fs/xfs/linux-2.6/xfs_sync.h                  |    2 +
 include/linux/blkdev.h                       |    3 -
 include/linux/i2c/twl4030-madc.h             |    4 +
 include/linux/lglock.h                       |   36 +-
 include/net/sctp/structs.h                   |    4 +
 kernel/cgroup.c                              |    5 -
 kernel/exit.c                                |    9 +-
 kernel/futex.c                               |   28 +-
 kernel/hung_task.c                           |   14 +-
 kernel/sysctl_binary.c                       |    2 +-
 mm/filemap.c                                 |    7 +-
 mm/hugetlb.c                                 |    2 +-
 mm/memcontrol.c                              |    3 +-
 mm/oom_kill.c                                |    2 +-
 mm/percpu.c                                  |    6 +-
 net/ipv4/devinet.c                           |    5 +
 net/ipv4/ipconfig.c                          |    4 +
 net/ipv4/ipip.c                              |    7 +-
 net/ipv4/route.c                             |  107 ++++
 net/ipv6/sit.c                               |    7 +-
 net/llc/af_llc.c                             |   14 +-
 net/mac80211/agg-tx.c                        |   86 ++--
 net/sched/sch_gred.c                         |    2 +-
 net/sched/sch_mqprio.c                       |    2 +-
 net/sctp/associola.c                         |    2 +-
 net/sctp/output.c                            |    8 +-
 net/sctp/outqueue.c                          |    6 +-
 net/sctp/protocol.c                          |    3 +
 net/sctp/socket.c                            |    2 -
 net/sctp/sysctl.c                            |   13 +
 security/selinux/netport.c                   |    4 +-
 86 files changed, 824 insertions(+), 1335 deletions(-)

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPBfd1AAoJEDjbvchgkmk+71EP/jDd9CLYnDDJ/vSoDjPzslNm
opfW6zIjUkNDiHvyJLENpWvgTr1GkA4L64aILBNk6x/dL1Oa6PryIRQPz0+3qY5W
R5p4qLmHTrBUWSFTeO33mBh2hHTk08A0SaLXOTG5LiM91iJzxtXTRMSUygOwal41
StOq6MciWIavDc9hEjOWEyk37OFe6aUaXLMWzuQdDthEkuJ+TvfESk6QI3cXA5xr
mpPlb1Pekqz7HlPvv6zmZsHpo56xwC3M84hjZk09llEseVCrnWPwPXD8xXs9ee61
m0ls5OfwpWH65Q15anj0To8cJRQw1l9Fsz9wtKE84ltGcsmD2R1mAkgIbcCyuBvh
sBeOVXnkZieoXgn8vR7Hg2HfxYcVG/b5pTXiLd/S99jzCsY7QgYxnnZ1CbtN/clk
nKoUXMSgHHCobhpFHG7zlBDBQgKx86rZrdM8E5akTs/klj38WUwSvK4Y5ituTBmL
a/ZLT4GYAOSF4JaiN87bXZDeDnY2NU97BqNJLTamcDmVDl1iSnDD5tCvZ6i2H6Jg
ZuKcgDrNBcJAUdfKXoWJD2cUHcUitNBkxBbXUci5fCeTGxp22RTrKh2JMkoffq+P
aSieJc03oR9wkPnlib8Fz1vUjm//wdCyEzMlN3YhNnkhhI5HgHtwrv7EmLXybo3z
4XJyK305/Z881jyFpzkC
=DxkV
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
