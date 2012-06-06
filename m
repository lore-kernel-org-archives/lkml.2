Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab2FFO4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:56:06 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:60031 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012Ab2FFOz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:55:59 -0400
From: Felipe Balbi <balbi@ti.com>
To: trivial@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, joe@perches.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2] trivial: treewide: remove extra semicolon added by module_init/exit
Date: Wed,  6 Jun 2012 17:54:01 +0300
Message-Id: <1338994441-13863-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338994062.9522.12.camel@joe2Laptop>
References: <1338994062.9522.12.camel@joe2Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of module_init() and module_exit()
already added the final semicolon creating a situation
where most of our drivers end up with two semicolons
at the end of every module_init()/module_exit() call.

To fix that, we add missing semicolons to the places
which didn't have them and remove the semicolons from
the definition of module_init/module_exit.

Patch generated with the following sed script:

$ sed -i 's/^module_\(init\|exit\)\s*\((\w\+)\)\s*$/module_\1\2;/g' \
	(git ls-files)

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/kernel/kprobes-test.c                        |    4 ++--
 arch/ia64/kvm/vmm.c                                   |    4 ++--
 arch/ia64/sn/kernel/mca.c                             |    2 +-
 arch/s390/hypfs/inode.c                               |    4 ++--
 arch/x86/kernel/msr.c                                 |    2 +-
 arch/x86/kvm/svm.c                                    |    4 ++--
 arch/x86/kvm/vmx.c                                    |    4 ++--
 drivers/bcma/main.c                                   |    2 +-
 drivers/block/ataflop.c                               |    4 ++--
 drivers/block/cpqarray.c                              |    4 ++--
 drivers/block/drbd/drbd_main.c                        |    4 ++--
 drivers/block/floppy.c                                |    2 +-
 drivers/block/paride/aten.c                           |    4 ++--
 drivers/block/paride/bpck.c                           |    4 ++--
 drivers/block/paride/bpck6.c                          |    4 ++--
 drivers/block/paride/comm.c                           |    4 ++--
 drivers/block/paride/dstr.c                           |    4 ++--
 drivers/block/paride/epat.c                           |    4 ++--
 drivers/block/paride/epia.c                           |    4 ++--
 drivers/block/paride/fit2.c                           |    4 ++--
 drivers/block/paride/fit3.c                           |    4 ++--
 drivers/block/paride/friq.c                           |    4 ++--
 drivers/block/paride/frpw.c                           |    4 ++--
 drivers/block/paride/kbic.c                           |    4 ++--
 drivers/block/paride/ktti.c                           |    4 ++--
 drivers/block/paride/on20.c                           |    4 ++--
 drivers/block/paride/on26.c                           |    4 ++--
 drivers/block/paride/pcd.c                            |    4 ++--
 drivers/block/paride/pd.c                             |    4 ++--
 drivers/block/paride/pf.c                             |    4 ++--
 drivers/block/paride/pg.c                             |    4 ++--
 drivers/block/paride/pt.c                             |    4 ++--
 drivers/block/swim3.c                                 |    2 +-
 drivers/hwmon/coretemp.c                              |    4 ++--
 drivers/hwmon/via-cputemp.c                           |    4 ++--
 drivers/i2c/busses/i2c-amd756.c                       |    4 ++--
 drivers/iommu/omap-iommu-debug.c                      |    4 ++--
 drivers/md/dm-bufio.c                                 |    4 ++--
 drivers/md/dm-zero.c                                  |    4 ++--
 drivers/md/md.c                                       |    2 +-
 drivers/media/media-devnode.c                         |    2 +-
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c       |    4 ++--
 drivers/media/rc/keymaps/rc-alink-dtu-m.c             |    4 ++--
 drivers/media/rc/keymaps/rc-anysee.c                  |    4 ++--
 drivers/media/rc/keymaps/rc-apac-viewcomp.c           |    4 ++--
 drivers/media/rc/keymaps/rc-asus-pc39.c               |    4 ++--
 drivers/media/rc/keymaps/rc-asus-ps3-100.c            |    4 ++--
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c    |    4 ++--
 drivers/media/rc/keymaps/rc-ati-x10.c                 |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia-a16d.c          |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c       |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c          |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia-m135a.c         |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c   |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c         |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia.c               |    4 ++--
 drivers/media/rc/keymaps/rc-avertv-303.c              |    4 ++--
 drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c      |    4 ++--
 drivers/media/rc/keymaps/rc-behold-columbus.c         |    4 ++--
 drivers/media/rc/keymaps/rc-behold.c                  |    4 ++--
 drivers/media/rc/keymaps/rc-budget-ci-old.c           |    4 ++--
 drivers/media/rc/keymaps/rc-cinergy-1400.c            |    4 ++--
 drivers/media/rc/keymaps/rc-cinergy.c                 |    4 ++--
 drivers/media/rc/keymaps/rc-dib0700-nec.c             |    4 ++--
 drivers/media/rc/keymaps/rc-dib0700-rc5.c             |    4 ++--
 drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c     |    4 ++--
 drivers/media/rc/keymaps/rc-digittrade.c              |    4 ++--
 drivers/media/rc/keymaps/rc-dm1105-nec.c              |    4 ++--
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c         |    4 ++--
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c      |    4 ++--
 drivers/media/rc/keymaps/rc-em-terratec.c             |    4 ++--
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c       |    4 ++--
 drivers/media/rc/keymaps/rc-encore-enltv.c            |    4 ++--
 drivers/media/rc/keymaps/rc-encore-enltv2.c           |    4 ++--
 drivers/media/rc/keymaps/rc-evga-indtube.c            |    4 ++--
 drivers/media/rc/keymaps/rc-eztv.c                    |    4 ++--
 drivers/media/rc/keymaps/rc-flydvb.c                  |    4 ++--
 drivers/media/rc/keymaps/rc-flyvideo.c                |    4 ++--
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c          |    4 ++--
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c           |    4 ++--
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c      |    4 ++--
 drivers/media/rc/keymaps/rc-gotview7135.c             |    4 ++--
 drivers/media/rc/keymaps/rc-hauppauge.c               |    4 ++--
 drivers/media/rc/keymaps/rc-imon-mce.c                |    4 ++--
 drivers/media/rc/keymaps/rc-imon-pad.c                |    4 ++--
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c           |    4 ++--
 drivers/media/rc/keymaps/rc-it913x-v1.c               |    4 ++--
 drivers/media/rc/keymaps/rc-it913x-v2.c               |    4 ++--
 drivers/media/rc/keymaps/rc-kaiomy.c                  |    4 ++--
 drivers/media/rc/keymaps/rc-kworld-315u.c             |    4 ++--
 drivers/media/rc/keymaps/rc-kworld-pc150u.c           |    4 ++--
 drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c   |    4 ++--
 drivers/media/rc/keymaps/rc-leadtek-y04g0051.c        |    4 ++--
 drivers/media/rc/keymaps/rc-lirc.c                    |    4 ++--
 drivers/media/rc/keymaps/rc-lme2510.c                 |    4 ++--
 drivers/media/rc/keymaps/rc-manli.c                   |    4 ++--
 drivers/media/rc/keymaps/rc-medion-x10-digitainer.c   |    4 ++--
 drivers/media/rc/keymaps/rc-medion-x10-or2x.c         |    4 ++--
 drivers/media/rc/keymaps/rc-medion-x10.c              |    4 ++--
 drivers/media/rc/keymaps/rc-msi-digivox-ii.c          |    4 ++--
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c         |    4 ++--
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c     |    4 ++--
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c          |    4 ++--
 drivers/media/rc/keymaps/rc-nebula.c                  |    4 ++--
 drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c |    4 ++--
 drivers/media/rc/keymaps/rc-norwood.c                 |    4 ++--
 drivers/media/rc/keymaps/rc-npgtech.c                 |    4 ++--
 drivers/media/rc/keymaps/rc-pctv-sedna.c              |    4 ++--
 drivers/media/rc/keymaps/rc-pinnacle-color.c          |    4 ++--
 drivers/media/rc/keymaps/rc-pinnacle-grey.c           |    4 ++--
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c        |    4 ++--
 drivers/media/rc/keymaps/rc-pixelview-002t.c          |    4 ++--
 drivers/media/rc/keymaps/rc-pixelview-mk12.c          |    4 ++--
 drivers/media/rc/keymaps/rc-pixelview-new.c           |    4 ++--
 drivers/media/rc/keymaps/rc-pixelview.c               |    4 ++--
 drivers/media/rc/keymaps/rc-powercolor-real-angel.c   |    4 ++--
 drivers/media/rc/keymaps/rc-proteus-2309.c            |    4 ++--
 drivers/media/rc/keymaps/rc-purpletv.c                |    4 ++--
 drivers/media/rc/keymaps/rc-pv951.c                   |    4 ++--
 drivers/media/rc/keymaps/rc-rc6-mce.c                 |    4 ++--
 drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c  |    4 ++--
 drivers/media/rc/keymaps/rc-snapstream-firefly.c      |    4 ++--
 drivers/media/rc/keymaps/rc-streamzap.c               |    4 ++--
 drivers/media/rc/keymaps/rc-tbs-nec.c                 |    4 ++--
 drivers/media/rc/keymaps/rc-technisat-usb2.c          |    4 ++--
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c     |    4 ++--
 drivers/media/rc/keymaps/rc-terratec-slim-2.c         |    4 ++--
 drivers/media/rc/keymaps/rc-terratec-slim.c           |    4 ++--
 drivers/media/rc/keymaps/rc-tevii-nec.c               |    4 ++--
 drivers/media/rc/keymaps/rc-tivo.c                    |    4 ++--
 drivers/media/rc/keymaps/rc-total-media-in-hand.c     |    4 ++--
 drivers/media/rc/keymaps/rc-trekstor.c                |    4 ++--
 drivers/media/rc/keymaps/rc-tt-1500.c                 |    4 ++--
 drivers/media/rc/keymaps/rc-twinhan1027.c             |    4 ++--
 drivers/media/rc/keymaps/rc-videomate-m1f.c           |    4 ++--
 drivers/media/rc/keymaps/rc-videomate-s350.c          |    4 ++--
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c        |    4 ++--
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c    |    4 ++--
 drivers/media/rc/keymaps/rc-winfast.c                 |    4 ++--
 drivers/media/video/v4l2-dev.c                        |    2 +-
 drivers/mfd/htc-egpio.c                               |    2 +-
 drivers/net/arcnet/arc-rimi.c                         |    4 ++--
 drivers/net/arcnet/com20020-isa.c                     |    4 ++--
 drivers/net/arcnet/com20020-pci.c                     |    4 ++--
 drivers/net/arcnet/com90io.c                          |    4 ++--
 drivers/net/ethernet/cadence/at91_ether.c             |    4 ++--
 drivers/net/ethernet/dec/tulip/xircom_cb.c            |    4 ++--
 drivers/net/ethernet/hp/hp100.c                       |    4 ++--
 drivers/net/wireless/b43/main.c                       |    4 ++--
 drivers/net/wireless/b43legacy/main.c                 |    4 ++--
 drivers/parisc/led.c                                  |    2 +-
 drivers/parport/parport_atari.c                       |    4 ++--
 drivers/parport/parport_mfc3.c                        |    4 ++--
 drivers/parport/parport_pc.c                          |    4 ++--
 drivers/parport/procfs.c                              |    4 ++--
 drivers/regulator/twl-regulator.c                     |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c                          |    4 ++--
 drivers/ssb/main.c                                    |    2 +-
 drivers/staging/ramster/cluster/nodemanager.c         |    4 ++--
 drivers/staging/ramster/zcache-main.c                 |    2 +-
 drivers/staging/rts_pstor/rtsx.c                      |    4 ++--
 drivers/staging/zcache/zcache-main.c                  |    2 +-
 drivers/uio/uio.c                                     |    4 ++--
 drivers/xen/tmem.c                                    |    2 +-
 fs/9p/v9fs.c                                          |    4 ++--
 fs/adfs/super.c                                       |    4 ++--
 fs/affs/super.c                                       |    4 ++--
 fs/autofs4/init.c                                     |    4 ++--
 fs/befs/linuxvfs.c                                    |    4 ++--
 fs/bfs/inode.c                                        |    4 ++--
 fs/btrfs/super.c                                      |    4 ++--
 fs/cifs/cifsfs.c                                      |    4 ++--
 fs/cramfs/inode.c                                     |    4 ++--
 fs/devpts/inode.c                                     |    2 +-
 fs/direct-io.c                                        |    2 +-
 fs/ecryptfs/main.c                                    |    4 ++--
 fs/efs/super.c                                        |    4 ++--
 fs/exofs/super.c                                      |    4 ++--
 fs/ext2/super.c                                       |    4 ++--
 fs/ext3/super.c                                       |    4 ++--
 fs/ext4/super.c                                       |    4 ++--
 fs/fat/inode.c                                        |    4 ++--
 fs/fat/namei_msdos.c                                  |    4 ++--
 fs/fat/namei_vfat.c                                   |    4 ++--
 fs/fcntl.c                                            |    2 +-
 fs/hfs/super.c                                        |    4 ++--
 fs/hfsplus/super.c                                    |    4 ++--
 fs/hostfs/hostfs_kern.c                               |    4 ++--
 fs/hpfs/super.c                                       |    4 ++--
 fs/hppfs/hppfs.c                                      |    4 ++--
 fs/hugetlbfs/inode.c                                  |    4 ++--
 fs/isofs/inode.c                                      |    4 ++--
 fs/jfs/super.c                                        |    4 ++--
 fs/mbcache.c                                          |    4 ++--
 fs/minix/inode.c                                      |    4 ++--
 fs/ncpfs/inode.c                                      |    4 ++--
 fs/nfs/inode.c                                        |    4 ++--
 fs/nfsd/nfsctl.c                                      |    4 ++--
 fs/nilfs2/super.c                                     |    4 ++--
 fs/nls/mac-celtic.c                                   |    4 ++--
 fs/nls/mac-centeuro.c                                 |    4 ++--
 fs/nls/mac-croatian.c                                 |    4 ++--
 fs/nls/mac-cyrillic.c                                 |    4 ++--
 fs/nls/mac-gaelic.c                                   |    4 ++--
 fs/nls/mac-greek.c                                    |    4 ++--
 fs/nls/mac-iceland.c                                  |    4 ++--
 fs/nls/mac-inuit.c                                    |    4 ++--
 fs/nls/mac-roman.c                                    |    4 ++--
 fs/nls/mac-romanian.c                                 |    4 ++--
 fs/nls/mac-turkish.c                                  |    4 ++--
 fs/nls/nls_ascii.c                                    |    4 ++--
 fs/nls/nls_cp1250.c                                   |    4 ++--
 fs/nls/nls_cp1251.c                                   |    4 ++--
 fs/nls/nls_cp1255.c                                   |    4 ++--
 fs/nls/nls_cp437.c                                    |    4 ++--
 fs/nls/nls_cp737.c                                    |    4 ++--
 fs/nls/nls_cp775.c                                    |    4 ++--
 fs/nls/nls_cp850.c                                    |    4 ++--
 fs/nls/nls_cp852.c                                    |    4 ++--
 fs/nls/nls_cp855.c                                    |    4 ++--
 fs/nls/nls_cp857.c                                    |    4 ++--
 fs/nls/nls_cp860.c                                    |    4 ++--
 fs/nls/nls_cp861.c                                    |    4 ++--
 fs/nls/nls_cp862.c                                    |    4 ++--
 fs/nls/nls_cp863.c                                    |    4 ++--
 fs/nls/nls_cp864.c                                    |    4 ++--
 fs/nls/nls_cp865.c                                    |    4 ++--
 fs/nls/nls_cp866.c                                    |    4 ++--
 fs/nls/nls_cp869.c                                    |    4 ++--
 fs/nls/nls_cp874.c                                    |    4 ++--
 fs/nls/nls_cp932.c                                    |    4 ++--
 fs/nls/nls_cp936.c                                    |    4 ++--
 fs/nls/nls_cp949.c                                    |    4 ++--
 fs/nls/nls_cp950.c                                    |    4 ++--
 fs/nls/nls_euc-jp.c                                   |    4 ++--
 fs/nls/nls_iso8859-1.c                                |    4 ++--
 fs/nls/nls_iso8859-13.c                               |    4 ++--
 fs/nls/nls_iso8859-14.c                               |    4 ++--
 fs/nls/nls_iso8859-15.c                               |    4 ++--
 fs/nls/nls_iso8859-2.c                                |    4 ++--
 fs/nls/nls_iso8859-3.c                                |    4 ++--
 fs/nls/nls_iso8859-4.c                                |    4 ++--
 fs/nls/nls_iso8859-5.c                                |    4 ++--
 fs/nls/nls_iso8859-6.c                                |    4 ++--
 fs/nls/nls_iso8859-7.c                                |    4 ++--
 fs/nls/nls_iso8859-9.c                                |    4 ++--
 fs/nls/nls_koi8-r.c                                   |    4 ++--
 fs/nls/nls_koi8-ru.c                                  |    4 ++--
 fs/nls/nls_koi8-u.c                                   |    4 ++--
 fs/nls/nls_utf8.c                                     |    4 ++--
 fs/notify/dnotify/dnotify.c                           |    2 +-
 fs/ntfs/super.c                                       |    4 ++--
 fs/ocfs2/cluster/nodemanager.c                        |    4 ++--
 fs/ocfs2/dlmfs/dlmfs.c                                |    4 ++--
 fs/openpromfs/inode.c                                 |    4 ++--
 fs/proc/vmcore.c                                      |    2 +-
 fs/pstore/inode.c                                     |    2 +-
 fs/qnx4/inode.c                                       |    4 ++--
 fs/qnx6/inode.c                                       |    4 ++--
 fs/ramfs/inode.c                                      |    2 +-
 fs/sysv/super.c                                       |    4 ++--
 fs/udf/super.c                                        |    4 ++--
 fs/ufs/super.c                                        |    4 ++--
 include/linux/init.h                                  |    4 ++--
 kernel/kexec.c                                        |    4 ++--
 mm/cleancache.c                                       |    2 +-
 mm/huge_memory.c                                      |    2 +-
 mm/ksm.c                                              |    2 +-
 mm/page_alloc.c                                       |    2 +-
 mm/vmscan.c                                           |    2 +-
 mm/vmstat.c                                           |    2 +-
 net/9p/mod.c                                          |    4 ++--
 net/bridge/br.c                                       |    4 ++--
 net/dns_resolver/dns_key.c                            |    4 ++--
 net/sched/cls_basic.c                                 |    4 ++--
 net/sched/cls_fw.c                                    |    4 ++--
 net/sched/cls_route.c                                 |    4 ++--
 net/sched/cls_rsvp.h                                  |    4 ++--
 net/sched/cls_tcindex.c                               |    4 ++--
 net/sched/cls_u32.c                                   |    4 ++--
 net/sched/sch_atm.c                                   |    4 ++--
 net/sched/sch_blackhole.c                             |    4 ++--
 net/sched/sch_cbq.c                                   |    4 ++--
 net/sched/sch_choke.c                                 |    4 ++--
 net/sched/sch_codel.c                                 |    4 ++--
 net/sched/sch_dsmark.c                                |    4 ++--
 net/sched/sch_fq_codel.c                              |    4 ++--
 net/sched/sch_gred.c                                  |    4 ++--
 net/sched/sch_htb.c                                   |    4 ++--
 net/sched/sch_ingress.c                               |    4 ++--
 net/sched/sch_multiq.c                                |    4 ++--
 net/sched/sch_netem.c                                 |    4 ++--
 net/sched/sch_plug.c                                  |    4 ++--
 net/sched/sch_prio.c                                  |    4 ++--
 net/sched/sch_red.c                                   |    4 ++--
 net/sched/sch_sfb.c                                   |    4 ++--
 net/sched/sch_sfq.c                                   |    4 ++--
 net/sched/sch_tbf.c                                   |    4 ++--
 net/sunrpc/auth_gss/auth_gss.c                        |    4 ++--
 samples/kprobes/jprobe_example.c                      |    4 ++--
 samples/kprobes/kprobe_example.c                      |    4 ++--
 samples/kprobes/kretprobe_example.c                   |    4 ++--
 samples/tracepoints/tracepoint-sample.c               |    4 ++--
 sound/core/hwdep.c                                    |    4 ++--
 sound/core/memalloc.c                                 |    4 ++--
 sound/core/oss/mixer_oss.c                            |    4 ++--
 sound/core/oss/pcm_oss.c                              |    4 ++--
 sound/core/pcm.c                                      |    4 ++--
 sound/core/rawmidi.c                                  |    4 ++--
 sound/core/rtctimer.c                                 |    4 ++--
 sound/core/seq/oss/seq_oss.c                          |    4 ++--
 sound/core/seq/seq.c                                  |    4 ++--
 sound/core/seq/seq_device.c                           |    4 ++--
 sound/core/seq/seq_dummy.c                            |    4 ++--
 sound/core/seq/seq_midi.c                             |    4 ++--
 sound/core/seq/seq_midi_emul.c                        |    4 ++--
 sound/core/seq/seq_midi_event.c                       |    4 ++--
 sound/core/seq/seq_virmidi.c                          |    4 ++--
 sound/core/timer.c                                    |    4 ++--
 sound/drivers/aloop.c                                 |    4 ++--
 sound/drivers/dummy.c                                 |    4 ++--
 sound/drivers/mpu401/mpu401.c                         |    4 ++--
 sound/drivers/mpu401/mpu401_uart.c                    |    4 ++--
 sound/drivers/mtpav.c                                 |    4 ++--
 sound/drivers/opl3/opl3_lib.c                         |    4 ++--
 sound/drivers/opl3/opl3_seq.c                         |    4 ++--
 sound/drivers/opl4/opl4_lib.c                         |    4 ++--
 sound/drivers/opl4/opl4_seq.c                         |    4 ++--
 sound/drivers/serial-u16550.c                         |    4 ++--
 sound/drivers/virmidi.c                               |    4 ++--
 sound/drivers/vx/vx_core.c                            |    4 ++--
 sound/i2c/cs8427.c                                    |    4 ++--
 sound/i2c/i2c.c                                       |    4 ++--
 sound/i2c/other/ak4xxx-adda.c                         |    4 ++--
 sound/i2c/other/tea575x-tuner.c                       |    4 ++--
 sound/i2c/tea6330t.c                                  |    4 ++--
 sound/isa/ad1816a/ad1816a.c                           |    4 ++--
 sound/isa/als100.c                                    |    4 ++--
 sound/isa/azt2320.c                                   |    4 ++--
 sound/isa/cmi8330.c                                   |    4 ++--
 sound/isa/cs423x/cs4236.c                             |    4 ++--
 sound/isa/es1688/es1688_lib.c                         |    4 ++--
 sound/isa/es18xx.c                                    |    4 ++--
 sound/isa/gus/gus_main.c                              |    4 ++--
 sound/isa/gus/gusmax.c                                |    4 ++--
 sound/isa/gus/interwave.c                             |    4 ++--
 sound/isa/opl3sa2.c                                   |    4 ++--
 sound/isa/opti9xx/miro.c                              |    4 ++--
 sound/isa/opti9xx/opti92x-ad1848.c                    |    4 ++--
 sound/isa/sb/emu8000_synth.c                          |    4 ++--
 sound/isa/sb/jazz16.c                                 |    4 ++--
 sound/isa/sb/sb16.c                                   |    4 ++--
 sound/isa/sb/sb16_csp.c                               |    4 ++--
 sound/isa/sb/sb16_main.c                              |    4 ++--
 sound/isa/sb/sb8.c                                    |    4 ++--
 sound/isa/sb/sb8_main.c                               |    4 ++--
 sound/isa/sb/sb_common.c                              |    4 ++--
 sound/isa/sc6000.c                                    |    4 ++--
 sound/isa/wavefront/wavefront.c                       |    4 ++--
 sound/pci/ac97/ac97_codec.c                           |    4 ++--
 sound/pci/asihpi/asihpi.c                             |    4 ++--
 sound/pci/emu10k1/emu10k1_synth.c                     |    4 ++--
 sound/pci/hda/patch_analog.c                          |    4 ++--
 sound/pci/hda/patch_ca0110.c                          |    4 ++--
 sound/pci/hda/patch_ca0132.c                          |    4 ++--
 sound/pci/hda/patch_cirrus.c                          |    4 ++--
 sound/pci/hda/patch_cmedia.c                          |    4 ++--
 sound/pci/hda/patch_conexant.c                        |    4 ++--
 sound/pci/hda/patch_hdmi.c                            |    4 ++--
 sound/pci/hda/patch_realtek.c                         |    4 ++--
 sound/pci/hda/patch_si3054.c                          |    4 ++--
 sound/pci/hda/patch_sigmatel.c                        |    4 ++--
 sound/pci/hda/patch_via.c                             |    4 ++--
 sound/pci/ice1712/ak4xxx.c                            |    4 ++--
 sound/ppc/powermac.c                                  |    4 ++--
 sound/synth/emux/emux.c                               |    4 ++--
 sound/synth/util_mem.c                                |    4 ++--
 tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c  |    4 ++--
 378 files changed, 728 insertions(+), 728 deletions(-)

diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 1862d8f..e9fb0d4 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -1685,8 +1685,8 @@ static void __exit kprobe_test_exit(void)
 {
 }
 
-module_init(run_all_tests)
-module_exit(kprobe_test_exit)
+module_init(run_all_tests);
+module_exit(kprobe_test_exit);
 MODULE_LICENSE("GPL");
 
 #else /* !MODULE */
diff --git a/arch/ia64/kvm/vmm.c b/arch/ia64/kvm/vmm.c
index f0b9cac..1e0910d 100644
--- a/arch/ia64/kvm/vmm.c
+++ b/arch/ia64/kvm/vmm.c
@@ -95,5 +95,5 @@ asmlinkage int printk(const char *fmt, ...)
 	return r;
 }
 
-module_init(kvm_vmm_init)
-module_exit(kvm_vmm_exit)
+module_init(kvm_vmm_init);
+module_exit(kvm_vmm_exit);
diff --git a/arch/ia64/sn/kernel/mca.c b/arch/ia64/sn/kernel/mca.c
index 27793f7..022f49b 100644
--- a/arch/ia64/sn/kernel/mca.c
+++ b/arch/ia64/sn/kernel/mca.c
@@ -143,4 +143,4 @@ static int __init sn_salinfo_init(void)
 	return 0;
 }
 
-module_init(sn_salinfo_init)
+module_init(sn_salinfo_init);
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 73dae8b..017326d 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -507,8 +507,8 @@ static void __exit hypfs_exit(void)
 	kobject_put(s390_kobj);
 }
 
-module_init(hypfs_init)
-module_exit(hypfs_exit)
+module_init(hypfs_init);
+module_exit(hypfs_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael Holzheu <holzheu@de.ibm.com>");
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index eb11369..7addd86 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -289,7 +289,7 @@ static void __exit msr_exit(void)
 }
 
 module_init(msr_init);
-module_exit(msr_exit)
+module_exit(msr_exit);
 
 MODULE_AUTHOR("H. Peter Anvin <hpa@zytor.com>");
 MODULE_DESCRIPTION("x86 generic MSR driver");
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f75af40..bae9887 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4339,5 +4339,5 @@ static void __exit svm_exit(void)
 	kvm_exit();
 }
 
-module_init(svm_init)
-module_exit(svm_exit)
+module_init(svm_init);
+module_exit(svm_exit);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 32eb588..e67555e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7305,5 +7305,5 @@ static void __exit vmx_exit(void)
 	kvm_exit();
 }
 
-module_init(vmx_init)
-module_exit(vmx_exit)
+module_init(vmx_init);
+module_exit(vmx_exit);
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 7e138ec..5551ce7 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -384,4 +384,4 @@ static void __exit bcma_modexit(void)
 #endif
 	bus_unregister(&bcma_bus_type);
 }
-module_exit(bcma_modexit)
+module_exit(bcma_modexit);
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index ede16c6..2f196e3 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2051,7 +2051,7 @@ static void __exit atari_floppy_exit(void)
 	atari_stram_free( DMABuffer );
 }
 
-module_init(atari_floppy_init)
-module_exit(atari_floppy_exit)
+module_init(atari_floppy_init);
+module_exit(atari_floppy_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 9125bbe..1d48dd5 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -1817,5 +1817,5 @@ static void __exit cpqarray_exit(void)
 	remove_proc_entry("driver/cpqarray", NULL);
 }
 
-module_init(cpqarray_init)
-module_exit(cpqarray_exit)
+module_init(cpqarray_init);
+module_exit(cpqarray_exit);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 920ede2..1f56c81 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -4375,8 +4375,8 @@ const char *drbd_buildtag(void)
 	return buildtag;
 }
 
-module_init(drbd_init)
-module_exit(drbd_cleanup)
+module_init(drbd_init);
+module_exit(drbd_cleanup);
 
 EXPORT_SYMBOL(drbd_conn_str);
 EXPORT_SYMBOL(drbd_role_str);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cce7df3..970e448 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4583,7 +4583,7 @@ MODULE_DEVICE_TABLE(pnp, floppy_pnpids);
 #else
 
 __setup("floppy=", floppy_setup);
-module_init(floppy_init)
+module_init(floppy_init);
 #endif
 
 MODULE_ALIAS_BLOCKDEV_MAJOR(FLOPPY_MAJOR);
diff --git a/drivers/block/paride/aten.c b/drivers/block/paride/aten.c
index 2695465..57a41bb 100644
--- a/drivers/block/paride/aten.c
+++ b/drivers/block/paride/aten.c
@@ -158,5 +158,5 @@ static void __exit aten_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(aten_init)
-module_exit(aten_exit)
+module_init(aten_init);
+module_exit(aten_exit);
diff --git a/drivers/block/paride/bpck.c b/drivers/block/paride/bpck.c
index 4f27e73..a6facc1 100644
--- a/drivers/block/paride/bpck.c
+++ b/drivers/block/paride/bpck.c
@@ -473,5 +473,5 @@ static void __exit bpck_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(bpck_init)
-module_exit(bpck_exit)
+module_init(bpck_init);
+module_exit(bpck_exit);
diff --git a/drivers/block/paride/bpck6.c b/drivers/block/paride/bpck6.c
index ec64e7f..533e841 100644
--- a/drivers/block/paride/bpck6.c
+++ b/drivers/block/paride/bpck6.c
@@ -263,5 +263,5 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Micro Solutions Inc.");
 MODULE_DESCRIPTION("BACKPACK Protocol module, compatible with PARIDE");
 module_param(verbose, bool, 0644);
-module_init(bpck6_init)
-module_exit(bpck6_exit)
+module_init(bpck6_init);
+module_exit(bpck6_exit);
diff --git a/drivers/block/paride/comm.c b/drivers/block/paride/comm.c
index 9bcd354..62c0640 100644
--- a/drivers/block/paride/comm.c
+++ b/drivers/block/paride/comm.c
@@ -214,5 +214,5 @@ static void __exit comm_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(comm_init)
-module_exit(comm_exit)
+module_init(comm_init);
+module_exit(comm_exit);
diff --git a/drivers/block/paride/dstr.c b/drivers/block/paride/dstr.c
index accc5c7..993cf22 100644
--- a/drivers/block/paride/dstr.c
+++ b/drivers/block/paride/dstr.c
@@ -229,5 +229,5 @@ static void __exit dstr_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(dstr_init)
-module_exit(dstr_exit)
+module_init(dstr_init);
+module_exit(dstr_exit);
diff --git a/drivers/block/paride/epat.c b/drivers/block/paride/epat.c
index 1bcdff7..55bf19c 100644
--- a/drivers/block/paride/epat.c
+++ b/drivers/block/paride/epat.c
@@ -336,5 +336,5 @@ static void __exit epat_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(epat_init)
-module_exit(epat_exit)
+module_init(epat_init);
+module_exit(epat_exit);
diff --git a/drivers/block/paride/epia.c b/drivers/block/paride/epia.c
index fb0e782..ff688d1 100644
--- a/drivers/block/paride/epia.c
+++ b/drivers/block/paride/epia.c
@@ -312,5 +312,5 @@ static void __exit epia_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(epia_init)
-module_exit(epia_exit)
+module_init(epia_init);
+module_exit(epia_exit);
diff --git a/drivers/block/paride/fit2.c b/drivers/block/paride/fit2.c
index 3812837..e776971 100644
--- a/drivers/block/paride/fit2.c
+++ b/drivers/block/paride/fit2.c
@@ -147,5 +147,5 @@ static void __exit fit2_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(fit2_init)
-module_exit(fit2_exit)
+module_init(fit2_init);
+module_exit(fit2_exit);
diff --git a/drivers/block/paride/fit3.c b/drivers/block/paride/fit3.c
index 275d269..0db2abc 100644
--- a/drivers/block/paride/fit3.c
+++ b/drivers/block/paride/fit3.c
@@ -207,5 +207,5 @@ static void __exit fit3_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(fit3_init)
-module_exit(fit3_exit)
+module_init(fit3_init);
+module_exit(fit3_exit);
diff --git a/drivers/block/paride/friq.c b/drivers/block/paride/friq.c
index 4f2ba24..e18db33 100644
--- a/drivers/block/paride/friq.c
+++ b/drivers/block/paride/friq.c
@@ -272,5 +272,5 @@ static void __exit friq_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(friq_init)
-module_exit(friq_exit)
+module_init(friq_init);
+module_exit(friq_exit);
diff --git a/drivers/block/paride/frpw.c b/drivers/block/paride/frpw.c
index c3cde36..1eafa29 100644
--- a/drivers/block/paride/frpw.c
+++ b/drivers/block/paride/frpw.c
@@ -309,5 +309,5 @@ static void __exit frpw_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(frpw_init)
-module_exit(frpw_exit)
+module_init(frpw_init);
+module_exit(frpw_exit);
diff --git a/drivers/block/paride/kbic.c b/drivers/block/paride/kbic.c
index 35999c4..d19fb56 100644
--- a/drivers/block/paride/kbic.c
+++ b/drivers/block/paride/kbic.c
@@ -301,5 +301,5 @@ static void __exit kbic_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(kbic_init)
-module_exit(kbic_exit)
+module_init(kbic_init);
+module_exit(kbic_exit);
diff --git a/drivers/block/paride/ktti.c b/drivers/block/paride/ktti.c
index 117ab0e..cf3eb25 100644
--- a/drivers/block/paride/ktti.c
+++ b/drivers/block/paride/ktti.c
@@ -124,5 +124,5 @@ static void __exit ktti_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(ktti_init)
-module_exit(ktti_exit)
+module_init(ktti_init);
+module_exit(ktti_exit);
diff --git a/drivers/block/paride/on20.c b/drivers/block/paride/on20.c
index 0173697..a6cd9bd 100644
--- a/drivers/block/paride/on20.c
+++ b/drivers/block/paride/on20.c
@@ -149,5 +149,5 @@ static void __exit on20_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(on20_init)
-module_exit(on20_exit)
+module_init(on20_init);
+module_exit(on20_exit);
diff --git a/drivers/block/paride/on26.c b/drivers/block/paride/on26.c
index 95ba256..72db56c 100644
--- a/drivers/block/paride/on26.c
+++ b/drivers/block/paride/on26.c
@@ -315,5 +315,5 @@ static void __exit on26_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(on26_init)
-module_exit(on26_exit)
+module_init(on26_init);
+module_exit(on26_exit);
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index ba2b6b5..37dd97b 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -988,5 +988,5 @@ static void __exit pcd_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(pcd_init)
-module_exit(pcd_exit)
+module_init(pcd_init);
+module_exit(pcd_exit);
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 831e3ac..36fcade 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -954,5 +954,5 @@ static void __exit pd_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(pd_init)
-module_exit(pd_exit)
+module_init(pd_init);
+module_exit(pd_exit);
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index ec8f9ed..64d6fd0 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -1004,5 +1004,5 @@ static void __exit pf_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(pf_init)
-module_exit(pf_exit)
+module_init(pf_init);
+module_exit(pf_exit);
diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index 4a27b1d..d0fc4c4 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -722,5 +722,5 @@ static void __exit pg_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(pg_init)
-module_exit(pg_exit)
+module_init(pg_init);
+module_exit(pg_exit);
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 2596042..27f814a 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -1012,5 +1012,5 @@ static void __exit pt_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(pt_init)
-module_exit(pt_exit)
+module_init(pt_init);
+module_exit(pt_exit);
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 89ddab1..f2bde1f 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1275,7 +1275,7 @@ int swim3_init(void)
 	return 0;
 }
 
-module_init(swim3_init)
+module_init(swim3_init);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul Mackerras");
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index b9d5123..ce230a8 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -826,5 +826,5 @@ MODULE_AUTHOR("Rudolf Marek <r.marek@assembler.cz>");
 MODULE_DESCRIPTION("Intel Core temperature monitor");
 MODULE_LICENSE("GPL");
 
-module_init(coretemp_init)
-module_exit(coretemp_exit)
+module_init(coretemp_init);
+module_exit(coretemp_exit);
diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index 8689664..58aecce 100644
--- a/drivers/hwmon/via-cputemp.c
+++ b/drivers/hwmon/via-cputemp.c
@@ -382,5 +382,5 @@ MODULE_AUTHOR("Harald Welte <HaraldWelte@viatech.com>");
 MODULE_DESCRIPTION("VIA CPU temperature monitor");
 MODULE_LICENSE("GPL");
 
-module_init(via_cputemp_init)
-module_exit(via_cputemp_exit)
+module_init(via_cputemp_init);
+module_exit(via_cputemp_exit);
diff --git a/drivers/i2c/busses/i2c-amd756.c b/drivers/i2c/busses/i2c-amd756.c
index eb778bf1..f370783 100644
--- a/drivers/i2c/busses/i2c-amd756.c
+++ b/drivers/i2c/busses/i2c-amd756.c
@@ -426,5 +426,5 @@ MODULE_LICENSE("GPL");
 
 EXPORT_SYMBOL(amd756_smbus);
 
-module_init(amd756_init)
-module_exit(amd756_exit)
+module_init(amd756_init);
+module_exit(amd756_exit);
diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index f55fc5d..4dec109 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -430,14 +430,14 @@ err_out:
 	debugfs_remove_recursive(iommu_debug_root);
 	return err;
 }
-module_init(iommu_debug_init)
+module_init(iommu_debug_init);
 
 static void __exit iommu_debugfs_exit(void)
 {
 	debugfs_remove_recursive(iommu_debug_root);
 	omap_foreach_iommu_device(NULL, iommu_debug_unregister);
 }
-module_exit(iommu_debugfs_exit)
+module_exit(iommu_debugfs_exit);
 
 MODULE_DESCRIPTION("omap iommu: debugfs interface");
 MODULE_AUTHOR("Hiroshi DOYU <Hiroshi.DOYU@nokia.com>");
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cc06a1e..c0fe35d 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1726,8 +1726,8 @@ static void __exit dm_bufio_exit(void)
 		BUG();
 }
 
-module_init(dm_bufio_init)
-module_exit(dm_bufio_exit)
+module_init(dm_bufio_init);
+module_exit(dm_bufio_exit);
 
 module_param_named(max_cache_size_bytes, dm_bufio_cache_size, ulong, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(max_cache_size_bytes, "Size of metadata cache");
diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
index cc2b3cb..139df27 100644
--- a/drivers/md/dm-zero.c
+++ b/drivers/md/dm-zero.c
@@ -77,8 +77,8 @@ static void __exit dm_zero_exit(void)
 	dm_unregister_target(&zero_target);
 }
 
-module_init(dm_zero_init)
-module_exit(dm_zero_exit)
+module_init(dm_zero_init);
+module_exit(dm_zero_exit);
 
 MODULE_AUTHOR("Christophe Saout <christophe@saout.de>");
 MODULE_DESCRIPTION(DM_NAME " dummy target returning zeros");
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1c2f904..90eb881 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8576,7 +8576,7 @@ static __exit void md_exit(void)
 }
 
 subsys_initcall(md_init);
-module_exit(md_exit)
+module_exit(md_exit);
 
 static int get_ro(char *buffer, struct kernel_param *kp)
 {
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index f6b52d5..f2d6c4b 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -312,7 +312,7 @@ static void __exit media_devnode_exit(void)
 }
 
 subsys_initcall(media_devnode_init);
-module_exit(media_devnode_exit)
+module_exit(media_devnode_exit);
 
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
 MODULE_DESCRIPTION("Device node registration for media drivers");
diff --git a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
index b0e42df..941831d 100644
--- a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
+++ b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
@@ -83,8 +83,8 @@ static void __exit exit_rc_map_adstech_dvb_t_pci(void)
 	rc_map_unregister(&adstech_dvb_t_pci_map);
 }
 
-module_init(init_rc_map_adstech_dvb_t_pci)
-module_exit(exit_rc_map_adstech_dvb_t_pci)
+module_init(init_rc_map_adstech_dvb_t_pci);
+module_exit(exit_rc_map_adstech_dvb_t_pci);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-alink-dtu-m.c b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
index 4e6ade8..1f13d34 100644
--- a/drivers/media/rc/keymaps/rc-alink-dtu-m.c
+++ b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
@@ -62,8 +62,8 @@ static void __exit exit_rc_map_alink_dtu_m(void)
 	rc_map_unregister(&alink_dtu_m_map);
 }
 
-module_init(init_rc_map_alink_dtu_m)
-module_exit(exit_rc_map_alink_dtu_m)
+module_init(init_rc_map_alink_dtu_m);
+module_exit(exit_rc_map_alink_dtu_m);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-anysee.c b/drivers/media/rc/keymaps/rc-anysee.c
index c735fe1..d5cd01e 100644
--- a/drivers/media/rc/keymaps/rc-anysee.c
+++ b/drivers/media/rc/keymaps/rc-anysee.c
@@ -87,8 +87,8 @@ static void __exit exit_rc_map_anysee(void)
 	rc_map_unregister(&anysee_map);
 }
 
-module_init(init_rc_map_anysee)
-module_exit(exit_rc_map_anysee)
+module_init(init_rc_map_anysee);
+module_exit(exit_rc_map_anysee);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-apac-viewcomp.c b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
index 8c92ff9..df5bcfa 100644
--- a/drivers/media/rc/keymaps/rc-apac-viewcomp.c
+++ b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
@@ -74,8 +74,8 @@ static void __exit exit_rc_map_apac_viewcomp(void)
 	rc_map_unregister(&apac_viewcomp_map);
 }
 
-module_init(init_rc_map_apac_viewcomp)
-module_exit(exit_rc_map_apac_viewcomp)
+module_init(init_rc_map_apac_viewcomp);
+module_exit(exit_rc_map_apac_viewcomp);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-asus-pc39.c b/drivers/media/rc/keymaps/rc-asus-pc39.c
index 2caf211..9c7b546 100644
--- a/drivers/media/rc/keymaps/rc-asus-pc39.c
+++ b/drivers/media/rc/keymaps/rc-asus-pc39.c
@@ -85,8 +85,8 @@ static void __exit exit_rc_map_asus_pc39(void)
 	rc_map_unregister(&asus_pc39_map);
 }
 
-module_init(init_rc_map_asus_pc39)
-module_exit(exit_rc_map_asus_pc39)
+module_init(init_rc_map_asus_pc39);
+module_exit(exit_rc_map_asus_pc39);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-asus-ps3-100.c b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
index ba76609..11d2766 100644
--- a/drivers/media/rc/keymaps/rc-asus-ps3-100.c
+++ b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
@@ -84,8 +84,8 @@ static void __exit exit_rc_map_asus_ps3_100(void)
 rc_map_unregister(&asus_ps3_100_map);
 }
 
-module_init(init_rc_map_asus_ps3_100)
-module_exit(exit_rc_map_asus_ps3_100)
+module_init(init_rc_map_asus_ps3_100);
+module_exit(exit_rc_map_asus_ps3_100);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
index 2031224..38e9b97 100644
--- a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
+++ b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
@@ -63,8 +63,8 @@ static void __exit exit_rc_map_ati_tv_wonder_hd_600(void)
 	rc_map_unregister(&ati_tv_wonder_hd_600_map);
 }
 
-module_init(init_rc_map_ati_tv_wonder_hd_600)
-module_exit(exit_rc_map_ati_tv_wonder_hd_600)
+module_init(init_rc_map_ati_tv_wonder_hd_600);
+module_exit(exit_rc_map_ati_tv_wonder_hd_600);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-ati-x10.c b/drivers/media/rc/keymaps/rc-ati-x10.c
index 8150644..dbd746d 100644
--- a/drivers/media/rc/keymaps/rc-ati-x10.c
+++ b/drivers/media/rc/keymaps/rc-ati-x10.c
@@ -97,8 +97,8 @@ static void __exit exit_rc_map_ati_x10(void)
 	rc_map_unregister(&ati_x10_map);
 }
 
-module_init(init_rc_map_ati_x10)
-module_exit(exit_rc_map_ati_x10)
+module_init(init_rc_map_ati_x10);
+module_exit(exit_rc_map_ati_x10);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Anssi Hannula <anssi.hannula@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-a16d.c b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
index 894939a..43b7562 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-a16d.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
@@ -69,8 +69,8 @@ static void __exit exit_rc_map_avermedia_a16d(void)
 	rc_map_unregister(&avermedia_a16d_map);
 }
 
-module_init(init_rc_map_avermedia_a16d)
-module_exit(exit_rc_map_avermedia_a16d)
+module_init(init_rc_map_avermedia_a16d);
+module_exit(exit_rc_map_avermedia_a16d);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
index d2aaf5b..acaf1ed 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
@@ -91,8 +91,8 @@ static void __exit exit_rc_map_avermedia_cardbus(void)
 	rc_map_unregister(&avermedia_cardbus_map);
 }
 
-module_init(init_rc_map_avermedia_cardbus)
-module_exit(exit_rc_map_avermedia_cardbus)
+module_init(init_rc_map_avermedia_cardbus);
+module_exit(exit_rc_map_avermedia_cardbus);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
index dc2baf0..58a8ddc 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
@@ -72,8 +72,8 @@ static void __exit exit_rc_map_avermedia_dvbt(void)
 	rc_map_unregister(&avermedia_dvbt_map);
 }
 
-module_init(init_rc_map_avermedia_dvbt)
-module_exit(exit_rc_map_avermedia_dvbt)
+module_init(init_rc_map_avermedia_dvbt);
+module_exit(exit_rc_map_avermedia_dvbt);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index 04269d3..3a8b441 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -141,8 +141,8 @@ static void __exit exit_rc_map_avermedia_m135a(void)
 	rc_map_unregister(&avermedia_m135a_map);
 }
 
-module_init(init_rc_map_avermedia_m135a)
-module_exit(exit_rc_map_avermedia_m135a)
+module_init(init_rc_map_avermedia_m135a);
+module_exit(exit_rc_map_avermedia_m135a);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
index e83b1a1..05affbc 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
@@ -89,8 +89,8 @@ static void __exit exit_rc_map_avermedia_m733a_rm_k6(void)
 	rc_map_unregister(&avermedia_m733a_rm_k6_map);
 }
 
-module_init(init_rc_map_avermedia_m733a_rm_k6)
-module_exit(exit_rc_map_avermedia_m733a_rm_k6)
+module_init(init_rc_map_avermedia_m733a_rm_k6);
+module_exit(exit_rc_map_avermedia_m733a_rm_k6);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
index 8344bcc..d30d2d3 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
@@ -73,8 +73,8 @@ static void __exit exit_rc_map_avermedia_rm_ks(void)
 	rc_map_unregister(&avermedia_rm_ks_map);
 }
 
-module_init(init_rc_map_avermedia_rm_ks)
-module_exit(exit_rc_map_avermedia_rm_ks)
+module_init(init_rc_map_avermedia_rm_ks);
+module_exit(exit_rc_map_avermedia_rm_ks);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia.c b/drivers/media/rc/keymaps/rc-avermedia.c
index c6063df..41ebf8a 100644
--- a/drivers/media/rc/keymaps/rc-avermedia.c
+++ b/drivers/media/rc/keymaps/rc-avermedia.c
@@ -80,8 +80,8 @@ static void __exit exit_rc_map_avermedia(void)
 	rc_map_unregister(&avermedia_map);
 }
 
-module_init(init_rc_map_avermedia)
-module_exit(exit_rc_map_avermedia)
+module_init(init_rc_map_avermedia);
+module_exit(exit_rc_map_avermedia);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avertv-303.c b/drivers/media/rc/keymaps/rc-avertv-303.c
index 14f7845..a48d268 100644
--- a/drivers/media/rc/keymaps/rc-avertv-303.c
+++ b/drivers/media/rc/keymaps/rc-avertv-303.c
@@ -79,8 +79,8 @@ static void __exit exit_rc_map_avertv_303(void)
 	rc_map_unregister(&avertv_303_map);
 }
 
-module_init(init_rc_map_avertv_303)
-module_exit(exit_rc_map_avertv_303)
+module_init(init_rc_map_avertv_303);
+module_exit(exit_rc_map_avertv_303);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
index ea7f2d0..355a22a 100644
--- a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
+++ b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
@@ -96,8 +96,8 @@ static void __exit exit_rc_map_azurewave_ad_tu700(void)
 	rc_map_unregister(&azurewave_ad_tu700_map);
 }
 
-module_init(init_rc_map_azurewave_ad_tu700)
-module_exit(exit_rc_map_azurewave_ad_tu700)
+module_init(init_rc_map_azurewave_ad_tu700);
+module_exit(exit_rc_map_azurewave_ad_tu700);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
index 086b4b1..d343ae5 100644
--- a/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -102,8 +102,8 @@ static void __exit exit_rc_map_behold_columbus(void)
 	rc_map_unregister(&behold_columbus_map);
 }
 
-module_init(init_rc_map_behold_columbus)
-module_exit(exit_rc_map_behold_columbus)
+module_init(init_rc_map_behold_columbus);
+module_exit(exit_rc_map_behold_columbus);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index 0877e34..d471d69 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -135,8 +135,8 @@ static void __exit exit_rc_map_behold(void)
 	rc_map_unregister(&behold_map);
 }
 
-module_init(init_rc_map_behold)
-module_exit(exit_rc_map_behold)
+module_init(init_rc_map_behold);
+module_exit(exit_rc_map_behold);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
index 8311e09..51ac114 100644
--- a/drivers/media/rc/keymaps/rc-budget-ci-old.c
+++ b/drivers/media/rc/keymaps/rc-budget-ci-old.c
@@ -87,8 +87,8 @@ static void __exit exit_rc_map_budget_ci_old(void)
 	rc_map_unregister(&budget_ci_old_map);
 }
 
-module_init(init_rc_map_budget_ci_old)
-module_exit(exit_rc_map_budget_ci_old)
+module_init(init_rc_map_budget_ci_old);
+module_exit(exit_rc_map_budget_ci_old);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-cinergy-1400.c b/drivers/media/rc/keymaps/rc-cinergy-1400.c
index 0c87fba..8277d27 100644
--- a/drivers/media/rc/keymaps/rc-cinergy-1400.c
+++ b/drivers/media/rc/keymaps/rc-cinergy-1400.c
@@ -78,8 +78,8 @@ static void __exit exit_rc_map_cinergy_1400(void)
 	rc_map_unregister(&cinergy_1400_map);
 }
 
-module_init(init_rc_map_cinergy_1400)
-module_exit(exit_rc_map_cinergy_1400)
+module_init(init_rc_map_cinergy_1400);
+module_exit(exit_rc_map_cinergy_1400);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
index 309e9e3..863dfd2 100644
--- a/drivers/media/rc/keymaps/rc-cinergy.c
+++ b/drivers/media/rc/keymaps/rc-cinergy.c
@@ -72,8 +72,8 @@ static void __exit exit_rc_map_cinergy(void)
 	rc_map_unregister(&cinergy_map);
 }
 
-module_init(init_rc_map_cinergy)
-module_exit(exit_rc_map_cinergy)
+module_init(init_rc_map_cinergy);
+module_exit(exit_rc_map_cinergy);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index 4d13a7f..d0c30c7 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -118,8 +118,8 @@ static void __exit exit_rc_map(void)
 	rc_map_unregister(&dib0700_nec_map);
 }
 
-module_init(init_rc_map)
-module_exit(exit_rc_map)
+module_init(init_rc_map);
+module_exit(exit_rc_map);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
index ba81d96..331c179 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-rc5.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
@@ -229,8 +229,8 @@ static void __exit exit_rc_map(void)
 	rc_map_unregister(&dib0700_rc5_map);
 }
 
-module_init(init_rc_map)
-module_exit(exit_rc_map)
+module_init(init_rc_map);
+module_exit(exit_rc_map);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
index bed78acb..0ea808b 100644
--- a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
+++ b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
@@ -92,8 +92,8 @@ static void __exit exit_rc_map_digitalnow_tinytwin(void)
 	rc_map_unregister(&digitalnow_tinytwin_map);
 }
 
-module_init(init_rc_map_digitalnow_tinytwin)
-module_exit(exit_rc_map_digitalnow_tinytwin)
+module_init(init_rc_map_digitalnow_tinytwin);
+module_exit(exit_rc_map_digitalnow_tinytwin);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-digittrade.c b/drivers/media/rc/keymaps/rc-digittrade.c
index a3b97a1..d579a23 100644
--- a/drivers/media/rc/keymaps/rc-digittrade.c
+++ b/drivers/media/rc/keymaps/rc-digittrade.c
@@ -76,8 +76,8 @@ static void __exit exit_rc_map_digittrade(void)
 	rc_map_unregister(&digittrade_map);
 }
 
-module_init(init_rc_map_digittrade)
-module_exit(exit_rc_map_digittrade)
+module_init(init_rc_map_digittrade);
+module_exit(exit_rc_map_digittrade);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-dm1105-nec.c b/drivers/media/rc/keymaps/rc-dm1105-nec.c
index 67fc9fb..be9bbbd 100644
--- a/drivers/media/rc/keymaps/rc-dm1105-nec.c
+++ b/drivers/media/rc/keymaps/rc-dm1105-nec.c
@@ -70,8 +70,8 @@ static void __exit exit_rc_map_dm1105_nec(void)
 	rc_map_unregister(&dm1105_nec_map);
 }
 
-module_init(init_rc_map_dm1105_nec)
-module_exit(exit_rc_map_dm1105_nec)
+module_init(init_rc_map_dm1105_nec);
+module_exit(exit_rc_map_dm1105_nec);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
index 91ea91d..ecf5e97 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
@@ -72,8 +72,8 @@ static void __exit exit_rc_map_dntv_live_dvb_t(void)
 	rc_map_unregister(&dntv_live_dvb_t_map);
 }
 
-module_init(init_rc_map_dntv_live_dvb_t)
-module_exit(exit_rc_map_dntv_live_dvb_t)
+module_init(init_rc_map_dntv_live_dvb_t);
+module_exit(exit_rc_map_dntv_live_dvb_t);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
index fd680d4..2b47a31 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
@@ -91,8 +91,8 @@ static void __exit exit_rc_map_dntv_live_dvbt_pro(void)
 	rc_map_unregister(&dntv_live_dvbt_pro_map);
 }
 
-module_init(init_rc_map_dntv_live_dvbt_pro)
-module_exit(exit_rc_map_dntv_live_dvbt_pro)
+module_init(init_rc_map_dntv_live_dvbt_pro);
+module_exit(exit_rc_map_dntv_live_dvbt_pro);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-em-terratec.c b/drivers/media/rc/keymaps/rc-em-terratec.c
index d1fcd64..b68234a 100644
--- a/drivers/media/rc/keymaps/rc-em-terratec.c
+++ b/drivers/media/rc/keymaps/rc-em-terratec.c
@@ -63,8 +63,8 @@ static void __exit exit_rc_map_em_terratec(void)
 	rc_map_unregister(&em_terratec_map);
 }
 
-module_init(init_rc_map_em_terratec)
-module_exit(exit_rc_map_em_terratec)
+module_init(init_rc_map_em_terratec);
+module_exit(exit_rc_map_em_terratec);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
index 2fe45e4..938be73 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
@@ -75,8 +75,8 @@ static void __exit exit_rc_map_encore_enltv_fm53(void)
 	rc_map_unregister(&encore_enltv_fm53_map);
 }
 
-module_init(init_rc_map_encore_enltv_fm53)
-module_exit(exit_rc_map_encore_enltv_fm53)
+module_init(init_rc_map_encore_enltv_fm53);
+module_exit(exit_rc_map_encore_enltv_fm53);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
index 223de75..2fb4109 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -106,8 +106,8 @@ static void __exit exit_rc_map_encore_enltv(void)
 	rc_map_unregister(&encore_enltv_map);
 }
 
-module_init(init_rc_map_encore_enltv)
-module_exit(exit_rc_map_encore_enltv)
+module_init(init_rc_map_encore_enltv);
+module_exit(exit_rc_map_encore_enltv);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
index 669cbff..24209c0 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -84,8 +84,8 @@ static void __exit exit_rc_map_encore_enltv2(void)
 	rc_map_unregister(&encore_enltv2_map);
 }
 
-module_init(init_rc_map_encore_enltv2)
-module_exit(exit_rc_map_encore_enltv2)
+module_init(init_rc_map_encore_enltv2);
+module_exit(exit_rc_map_encore_enltv2);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-evga-indtube.c b/drivers/media/rc/keymaps/rc-evga-indtube.c
index 2c647fc..912d8ab 100644
--- a/drivers/media/rc/keymaps/rc-evga-indtube.c
+++ b/drivers/media/rc/keymaps/rc-evga-indtube.c
@@ -55,8 +55,8 @@ static void __exit exit_rc_map_evga_indtube(void)
 	rc_map_unregister(&evga_indtube_map);
 }
 
-module_init(init_rc_map_evga_indtube)
-module_exit(exit_rc_map_evga_indtube)
+module_init(init_rc_map_evga_indtube);
+module_exit(exit_rc_map_evga_indtube);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-eztv.c b/drivers/media/rc/keymaps/rc-eztv.c
index 7692144..5540a1c 100644
--- a/drivers/media/rc/keymaps/rc-eztv.c
+++ b/drivers/media/rc/keymaps/rc-eztv.c
@@ -90,8 +90,8 @@ static void __exit exit_rc_map_eztv(void)
 	rc_map_unregister(&eztv_map);
 }
 
-module_init(init_rc_map_eztv)
-module_exit(exit_rc_map_eztv)
+module_init(init_rc_map_eztv);
+module_exit(exit_rc_map_eztv);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
index 3a6bba3..545e55e 100644
--- a/drivers/media/rc/keymaps/rc-flydvb.c
+++ b/drivers/media/rc/keymaps/rc-flydvb.c
@@ -71,8 +71,8 @@ static void __exit exit_rc_map_flydvb(void)
 	rc_map_unregister(&flydvb_map);
 }
 
-module_init(init_rc_map_flydvb)
-module_exit(exit_rc_map_flydvb)
+module_init(init_rc_map_flydvb);
+module_exit(exit_rc_map_flydvb);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-flyvideo.c b/drivers/media/rc/keymaps/rc-flyvideo.c
index bf9da58..78f2434 100644
--- a/drivers/media/rc/keymaps/rc-flyvideo.c
+++ b/drivers/media/rc/keymaps/rc-flyvideo.c
@@ -64,8 +64,8 @@ static void __exit exit_rc_map_flyvideo(void)
 	rc_map_unregister(&flyvideo_map);
 }
 
-module_init(init_rc_map_flyvideo)
-module_exit(exit_rc_map_flyvideo)
+module_init(init_rc_map_flyvideo);
+module_exit(exit_rc_map_flyvideo);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
index 2f0970f..4465166 100644
--- a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
+++ b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
@@ -92,8 +92,8 @@ static void __exit exit_rc_map_fusionhdtv_mce(void)
 	rc_map_unregister(&fusionhdtv_mce_map);
 }
 
-module_init(init_rc_map_fusionhdtv_mce)
-module_exit(exit_rc_map_fusionhdtv_mce)
+module_init(init_rc_map_fusionhdtv_mce);
+module_exit(exit_rc_map_fusionhdtv_mce);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
index 0e98ec4..6ce84c7 100644
--- a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
+++ b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
@@ -75,8 +75,8 @@ static void __exit exit_rc_map_gadmei_rm008z(void)
 	rc_map_unregister(&gadmei_rm008z_map);
 }
 
-module_init(init_rc_map_gadmei_rm008z)
-module_exit(exit_rc_map_gadmei_rm008z)
+module_init(init_rc_map_gadmei_rm008z);
+module_exit(exit_rc_map_gadmei_rm008z);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
index a2e2faa..dcad6e5 100644
--- a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
+++ b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
@@ -78,8 +78,8 @@ static void __exit exit_rc_map_genius_tvgo_a11mce(void)
 	rc_map_unregister(&genius_tvgo_a11mce_map);
 }
 
-module_init(init_rc_map_genius_tvgo_a11mce)
-module_exit(exit_rc_map_genius_tvgo_a11mce)
+module_init(init_rc_map_genius_tvgo_a11mce);
+module_exit(exit_rc_map_genius_tvgo_a11mce);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-gotview7135.c b/drivers/media/rc/keymaps/rc-gotview7135.c
index 864614e..caac932 100644
--- a/drivers/media/rc/keymaps/rc-gotview7135.c
+++ b/drivers/media/rc/keymaps/rc-gotview7135.c
@@ -73,8 +73,8 @@ static void __exit exit_rc_map_gotview7135(void)
 	rc_map_unregister(&gotview7135_map);
 }
 
-module_init(init_rc_map_gotview7135)
-module_exit(exit_rc_map_gotview7135)
+module_init(init_rc_map_gotview7135);
+module_exit(exit_rc_map_gotview7135);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-hauppauge.c b/drivers/media/rc/keymaps/rc-hauppauge.c
index 929bbbc..ebd0881 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge.c
@@ -286,8 +286,8 @@ static void __exit exit_rc_map_rc5_hauppauge_new(void)
 	rc_map_unregister(&rc5_hauppauge_new_map);
 }
 
-module_init(init_rc_map_rc5_hauppauge_new)
-module_exit(exit_rc_map_rc5_hauppauge_new)
+module_init(init_rc_map_rc5_hauppauge_new);
+module_exit(exit_rc_map_rc5_hauppauge_new);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-imon-mce.c b/drivers/media/rc/keymaps/rc-imon-mce.c
index 124c722..38e977a 100644
--- a/drivers/media/rc/keymaps/rc-imon-mce.c
+++ b/drivers/media/rc/keymaps/rc-imon-mce.c
@@ -136,8 +136,8 @@ static void __exit exit_rc_map_imon_mce(void)
 	rc_map_unregister(&imon_mce_map);
 }
 
-module_init(init_rc_map_imon_mce)
-module_exit(exit_rc_map_imon_mce)
+module_init(init_rc_map_imon_mce);
+module_exit(exit_rc_map_imon_mce);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-imon-pad.c b/drivers/media/rc/keymaps/rc-imon-pad.c
index 999c629..2506512 100644
--- a/drivers/media/rc/keymaps/rc-imon-pad.c
+++ b/drivers/media/rc/keymaps/rc-imon-pad.c
@@ -150,8 +150,8 @@ static void __exit exit_rc_map_imon_pad(void)
 	rc_map_unregister(&imon_pad_map);
 }
 
-module_init(init_rc_map_imon_pad)
-module_exit(exit_rc_map_imon_pad)
+module_init(init_rc_map_imon_pad);
+module_exit(exit_rc_map_imon_pad);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
index 34540df..cc6ece7 100644
--- a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
+++ b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
@@ -82,8 +82,8 @@ static void __exit exit_rc_map_iodata_bctv7e(void)
 	rc_map_unregister(&iodata_bctv7e_map);
 }
 
-module_init(init_rc_map_iodata_bctv7e)
-module_exit(exit_rc_map_iodata_bctv7e)
+module_init(init_rc_map_iodata_bctv7e);
+module_exit(exit_rc_map_iodata_bctv7e);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-it913x-v1.c b/drivers/media/rc/keymaps/rc-it913x-v1.c
index 0ac775f..2d483fb 100644
--- a/drivers/media/rc/keymaps/rc-it913x-v1.c
+++ b/drivers/media/rc/keymaps/rc-it913x-v1.c
@@ -88,8 +88,8 @@ static void __exit exit_rc_it913x_v1_map(void)
 	rc_map_unregister(&it913x_v1_map);
 }
 
-module_init(init_rc_it913x_v1_map)
-module_exit(exit_rc_it913x_v1_map)
+module_init(init_rc_it913x_v1_map);
+module_exit(exit_rc_it913x_v1_map);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
diff --git a/drivers/media/rc/keymaps/rc-it913x-v2.c b/drivers/media/rc/keymaps/rc-it913x-v2.c
index bd42a30..4199f37 100644
--- a/drivers/media/rc/keymaps/rc-it913x-v2.c
+++ b/drivers/media/rc/keymaps/rc-it913x-v2.c
@@ -87,8 +87,8 @@ static void __exit exit_rc_it913x_v2_map(void)
 	rc_map_unregister(&it913x_v2_map);
 }
 
-module_init(init_rc_it913x_v2_map)
-module_exit(exit_rc_it913x_v2_map)
+module_init(init_rc_it913x_v2_map);
+module_exit(exit_rc_it913x_v2_map);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
diff --git a/drivers/media/rc/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
index 4264a78..0bc71e4 100644
--- a/drivers/media/rc/keymaps/rc-kaiomy.c
+++ b/drivers/media/rc/keymaps/rc-kaiomy.c
@@ -81,8 +81,8 @@ static void __exit exit_rc_map_kaiomy(void)
 	rc_map_unregister(&kaiomy_map);
 }
 
-module_init(init_rc_map_kaiomy)
-module_exit(exit_rc_map_kaiomy)
+module_init(init_rc_map_kaiomy);
+module_exit(exit_rc_map_kaiomy);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
index e48cd26..da0a9b8 100644
--- a/drivers/media/rc/keymaps/rc-kworld-315u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-315u.c
@@ -77,8 +77,8 @@ static void __exit exit_rc_map_kworld_315u(void)
 	rc_map_unregister(&kworld_315u_map);
 }
 
-module_init(init_rc_map_kworld_315u)
-module_exit(exit_rc_map_kworld_315u)
+module_init(init_rc_map_kworld_315u);
+module_exit(exit_rc_map_kworld_315u);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-kworld-pc150u.c b/drivers/media/rc/keymaps/rc-kworld-pc150u.c
index 233bb5e..41adc14 100644
--- a/drivers/media/rc/keymaps/rc-kworld-pc150u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-pc150u.c
@@ -95,8 +95,8 @@ static void __exit exit_rc_map_kworld_pc150u(void)
 	rc_map_unregister(&kworld_pc150u_map);
 }
 
-module_init(init_rc_map_kworld_pc150u)
-module_exit(exit_rc_map_kworld_pc150u)
+module_init(init_rc_map_kworld_pc150u);
+module_exit(exit_rc_map_kworld_pc150u);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kyle Strickland <kyle@kyle.strickland.name>");
diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
index 32998d6..1add07e 100644
--- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -93,8 +93,8 @@ static void __exit exit_rc_map_kworld_plus_tv_analog(void)
 	rc_map_unregister(&kworld_plus_tv_analog_map);
 }
 
-module_init(init_rc_map_kworld_plus_tv_analog)
-module_exit(exit_rc_map_kworld_plus_tv_analog)
+module_init(init_rc_map_kworld_plus_tv_analog);
+module_exit(exit_rc_map_kworld_plus_tv_analog);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
index 03d762d..ed2a797 100644
--- a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
+++ b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
@@ -93,8 +93,8 @@ static void __exit exit_rc_map_leadtek_y04g0051(void)
 	rc_map_unregister(&leadtek_y04g0051_map);
 }
 
-module_init(init_rc_map_leadtek_y04g0051)
-module_exit(exit_rc_map_leadtek_y04g0051)
+module_init(init_rc_map_leadtek_y04g0051);
+module_exit(exit_rc_map_leadtek_y04g0051);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-lirc.c b/drivers/media/rc/keymaps/rc-lirc.c
index fbf08fa..055ef0b 100644
--- a/drivers/media/rc/keymaps/rc-lirc.c
+++ b/drivers/media/rc/keymaps/rc-lirc.c
@@ -35,8 +35,8 @@ static void __exit exit_rc_map_lirc(void)
 	rc_map_unregister(&lirc_map);
 }
 
-module_init(init_rc_map_lirc)
-module_exit(exit_rc_map_lirc)
+module_init(init_rc_map_lirc);
+module_exit(exit_rc_map_lirc);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-lme2510.c b/drivers/media/rc/keymaps/rc-lme2510.c
index 51f18bb..767abe6 100644
--- a/drivers/media/rc/keymaps/rc-lme2510.c
+++ b/drivers/media/rc/keymaps/rc-lme2510.c
@@ -104,8 +104,8 @@ static void __exit exit_rc_lme2510_map(void)
 	rc_map_unregister(&lme2510_map);
 }
 
-module_init(init_rc_lme2510_map)
-module_exit(exit_rc_lme2510_map)
+module_init(init_rc_lme2510_map);
+module_exit(exit_rc_lme2510_map);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
diff --git a/drivers/media/rc/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
index e7038bb..f4d9983 100644
--- a/drivers/media/rc/keymaps/rc-manli.c
+++ b/drivers/media/rc/keymaps/rc-manli.c
@@ -128,8 +128,8 @@ static void __exit exit_rc_map_manli(void)
 	rc_map_unregister(&manli_map);
 }
 
-module_init(init_rc_map_manli)
-module_exit(exit_rc_map_manli)
+module_init(init_rc_map_manli);
+module_exit(exit_rc_map_manli);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c b/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c
index 966f9b3..db79f5f 100644
--- a/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c
+++ b/drivers/media/rc/keymaps/rc-medion-x10-digitainer.c
@@ -115,8 +115,8 @@ static void __exit exit_rc_map_medion_x10_digitainer(void)
 	rc_map_unregister(&medion_x10_digitainer_map);
 }
 
-module_init(init_rc_map_medion_x10_digitainer)
-module_exit(exit_rc_map_medion_x10_digitainer)
+module_init(init_rc_map_medion_x10_digitainer);
+module_exit(exit_rc_map_medion_x10_digitainer);
 
 MODULE_DESCRIPTION("Medion X10 RF remote keytable (Digitainer variant)");
 MODULE_AUTHOR("Anssi Hannula <anssi.hannula@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-medion-x10-or2x.c b/drivers/media/rc/keymaps/rc-medion-x10-or2x.c
index b077300..e3e5628 100644
--- a/drivers/media/rc/keymaps/rc-medion-x10-or2x.c
+++ b/drivers/media/rc/keymaps/rc-medion-x10-or2x.c
@@ -100,8 +100,8 @@ static void __exit exit_rc_map_medion_x10_or2x(void)
 	rc_map_unregister(&medion_x10_or2x_map);
 }
 
-module_init(init_rc_map_medion_x10_or2x)
-module_exit(exit_rc_map_medion_x10_or2x)
+module_init(init_rc_map_medion_x10_or2x);
+module_exit(exit_rc_map_medion_x10_or2x);
 
 MODULE_DESCRIPTION("Medion X10 OR22/OR24 RF remote keytable");
 MODULE_AUTHOR("Anssi Hannula <anssi.hannula@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-medion-x10.c b/drivers/media/rc/keymaps/rc-medion-x10.c
index 479cdb8..d19feb6 100644
--- a/drivers/media/rc/keymaps/rc-medion-x10.c
+++ b/drivers/media/rc/keymaps/rc-medion-x10.c
@@ -110,8 +110,8 @@ static void __exit exit_rc_map_medion_x10(void)
 	rc_map_unregister(&medion_x10_map);
 }
 
-module_init(init_rc_map_medion_x10)
-module_exit(exit_rc_map_medion_x10)
+module_init(init_rc_map_medion_x10);
+module_exit(exit_rc_map_medion_x10);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Anssi Hannula <anssi.hannula@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
index c64e9e3..ada5fac 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
@@ -61,8 +61,8 @@ static void __exit exit_rc_map_msi_digivox_ii(void)
 	rc_map_unregister(&msi_digivox_ii_map);
 }
 
-module_init(init_rc_map_msi_digivox_ii)
-module_exit(exit_rc_map_msi_digivox_ii)
+module_init(init_rc_map_msi_digivox_ii);
+module_exit(exit_rc_map_msi_digivox_ii);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
index 303a0b7..21e3df6 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
@@ -79,8 +79,8 @@ static void __exit exit_rc_map_msi_digivox_iii(void)
 	rc_map_unregister(&msi_digivox_iii_map);
 }
 
-module_init(init_rc_map_msi_digivox_iii)
-module_exit(exit_rc_map_msi_digivox_iii)
+module_init(init_rc_map_msi_digivox_iii);
+module_exit(exit_rc_map_msi_digivox_iii);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
index c393d8a..6df0d7c 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
@@ -117,8 +117,8 @@ static void __exit exit_rc_map_msi_tvanywhere_plus(void)
 	rc_map_unregister(&msi_tvanywhere_plus_map);
 }
 
-module_init(init_rc_map_msi_tvanywhere_plus)
-module_exit(exit_rc_map_msi_tvanywhere_plus)
+module_init(init_rc_map_msi_tvanywhere_plus);
+module_exit(exit_rc_map_msi_tvanywhere_plus);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
index a7003d3..df2c702 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
@@ -63,8 +63,8 @@ static void __exit exit_rc_map_msi_tvanywhere(void)
 	rc_map_unregister(&msi_tvanywhere_map);
 }
 
-module_init(init_rc_map_msi_tvanywhere)
-module_exit(exit_rc_map_msi_tvanywhere)
+module_init(init_rc_map_msi_tvanywhere);
+module_exit(exit_rc_map_msi_tvanywhere);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
index 3f0ddd7..8757df8 100644
--- a/drivers/media/rc/keymaps/rc-nebula.c
+++ b/drivers/media/rc/keymaps/rc-nebula.c
@@ -90,8 +90,8 @@ static void __exit exit_rc_map_nebula(void)
 	rc_map_unregister(&nebula_map);
 }
 
-module_init(init_rc_map_nebula)
-module_exit(exit_rc_map_nebula)
+module_init(init_rc_map_nebula);
+module_exit(exit_rc_map_nebula);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
index 8d4dae2..65b3bba 100644
--- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -151,8 +151,8 @@ static void __exit exit_rc_map_nec_terratec_cinergy_xs(void)
 	rc_map_unregister(&nec_terratec_cinergy_xs_map);
 }
 
-module_init(init_rc_map_nec_terratec_cinergy_xs)
-module_exit(exit_rc_map_nec_terratec_cinergy_xs)
+module_init(init_rc_map_nec_terratec_cinergy_xs);
+module_exit(exit_rc_map_nec_terratec_cinergy_xs);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
index 9e65f07..dd70085 100644
--- a/drivers/media/rc/keymaps/rc-norwood.c
+++ b/drivers/media/rc/keymaps/rc-norwood.c
@@ -79,8 +79,8 @@ static void __exit exit_rc_map_norwood(void)
 	rc_map_unregister(&norwood_map);
 }
 
-module_init(init_rc_map_norwood)
-module_exit(exit_rc_map_norwood)
+module_init(init_rc_map_norwood);
+module_exit(exit_rc_map_norwood);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-npgtech.c b/drivers/media/rc/keymaps/rc-npgtech.c
index 65d0cfc..c4becde 100644
--- a/drivers/media/rc/keymaps/rc-npgtech.c
+++ b/drivers/media/rc/keymaps/rc-npgtech.c
@@ -74,8 +74,8 @@ static void __exit exit_rc_map_npgtech(void)
 	rc_map_unregister(&npgtech_map);
 }
 
-module_init(init_rc_map_npgtech)
-module_exit(exit_rc_map_npgtech)
+module_init(init_rc_map_npgtech);
+module_exit(exit_rc_map_npgtech);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
index bf2cbdf..cc4ceb1 100644
--- a/drivers/media/rc/keymaps/rc-pctv-sedna.c
+++ b/drivers/media/rc/keymaps/rc-pctv-sedna.c
@@ -74,8 +74,8 @@ static void __exit exit_rc_map_pctv_sedna(void)
 	rc_map_unregister(&pctv_sedna_map);
 }
 
-module_init(init_rc_map_pctv_sedna)
-module_exit(exit_rc_map_pctv_sedna)
+module_init(init_rc_map_pctv_sedna);
+module_exit(exit_rc_map_pctv_sedna);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-color.c b/drivers/media/rc/keymaps/rc-pinnacle-color.c
index b46cd8f..f4f7c40 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-color.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-color.c
@@ -88,8 +88,8 @@ static void __exit exit_rc_map_pinnacle_color(void)
 	rc_map_unregister(&pinnacle_color_map);
 }
 
-module_init(init_rc_map_pinnacle_color)
-module_exit(exit_rc_map_pinnacle_color)
+module_init(init_rc_map_pinnacle_color);
+module_exit(exit_rc_map_pinnacle_color);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-grey.c b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
index d525df9..0a4c125 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-grey.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
@@ -83,8 +83,8 @@ static void __exit exit_rc_map_pinnacle_grey(void)
 	rc_map_unregister(&pinnacle_grey_map);
 }
 
-module_init(init_rc_map_pinnacle_grey)
-module_exit(exit_rc_map_pinnacle_grey)
+module_init(init_rc_map_pinnacle_grey);
+module_exit(exit_rc_map_pinnacle_grey);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
index a4603d0..801b4b3 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
@@ -64,8 +64,8 @@ static void __exit exit_rc_map_pinnacle_pctv_hd(void)
 	rc_map_unregister(&pinnacle_pctv_hd_map);
 }
 
-module_init(init_rc_map_pinnacle_pctv_hd)
-module_exit(exit_rc_map_pinnacle_pctv_hd)
+module_init(init_rc_map_pinnacle_pctv_hd);
+module_exit(exit_rc_map_pinnacle_pctv_hd);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-002t.c b/drivers/media/rc/keymaps/rc-pixelview-002t.c
index 33eb643..079be38 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-002t.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-002t.c
@@ -71,8 +71,8 @@ static void __exit exit_rc_map_pixelview(void)
 	rc_map_unregister(&pixelview_map);
 }
 
-module_init(init_rc_map_pixelview)
-module_exit(exit_rc_map_pixelview)
+module_init(init_rc_map_pixelview);
+module_exit(exit_rc_map_pixelview);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
index 21f4dd2..d794c54 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -77,8 +77,8 @@ static void __exit exit_rc_map_pixelview(void)
 	rc_map_unregister(&pixelview_map);
 }
 
-module_init(init_rc_map_pixelview)
-module_exit(exit_rc_map_pixelview)
+module_init(init_rc_map_pixelview);
+module_exit(exit_rc_map_pixelview);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
index f944ad2..ab72e51 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -77,8 +77,8 @@ static void __exit exit_rc_map_pixelview_new(void)
 	rc_map_unregister(&pixelview_new_map);
 }
 
-module_init(init_rc_map_pixelview_new)
-module_exit(exit_rc_map_pixelview_new)
+module_init(init_rc_map_pixelview_new);
+module_exit(exit_rc_map_pixelview_new);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
index a6020ee..17a45df 100644
--- a/drivers/media/rc/keymaps/rc-pixelview.c
+++ b/drivers/media/rc/keymaps/rc-pixelview.c
@@ -76,8 +76,8 @@ static void __exit exit_rc_map_pixelview(void)
 	rc_map_unregister(&pixelview_map);
 }
 
-module_init(init_rc_map_pixelview)
-module_exit(exit_rc_map_pixelview)
+module_init(init_rc_map_pixelview);
+module_exit(exit_rc_map_pixelview);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
index e74c571..ebc7531 100644
--- a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
+++ b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
@@ -75,8 +75,8 @@ static void __exit exit_rc_map_powercolor_real_angel(void)
 	rc_map_unregister(&powercolor_real_angel_map);
 }
 
-module_init(init_rc_map_powercolor_real_angel)
-module_exit(exit_rc_map_powercolor_real_angel)
+module_init(init_rc_map_powercolor_real_angel);
+module_exit(exit_rc_map_powercolor_real_angel);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-proteus-2309.c b/drivers/media/rc/keymaps/rc-proteus-2309.c
index adee803..ea0a2d2 100644
--- a/drivers/media/rc/keymaps/rc-proteus-2309.c
+++ b/drivers/media/rc/keymaps/rc-proteus-2309.c
@@ -63,8 +63,8 @@ static void __exit exit_rc_map_proteus_2309(void)
 	rc_map_unregister(&proteus_2309_map);
 }
 
-module_init(init_rc_map_proteus_2309)
-module_exit(exit_rc_map_proteus_2309)
+module_init(init_rc_map_proteus_2309);
+module_exit(exit_rc_map_proteus_2309);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-purpletv.c b/drivers/media/rc/keymaps/rc-purpletv.c
index 722597a..81c19e6 100644
--- a/drivers/media/rc/keymaps/rc-purpletv.c
+++ b/drivers/media/rc/keymaps/rc-purpletv.c
@@ -75,8 +75,8 @@ static void __exit exit_rc_map_purpletv(void)
 	rc_map_unregister(&purpletv_map);
 }
 
-module_init(init_rc_map_purpletv)
-module_exit(exit_rc_map_purpletv)
+module_init(init_rc_map_purpletv);
+module_exit(exit_rc_map_purpletv);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
index 0105d63..4cf5979 100644
--- a/drivers/media/rc/keymaps/rc-pv951.c
+++ b/drivers/media/rc/keymaps/rc-pv951.c
@@ -72,8 +72,8 @@ static void __exit exit_rc_map_pv951(void)
 	rc_map_unregister(&pv951_map);
 }
 
-module_init(init_rc_map_pv951)
-module_exit(exit_rc_map_pv951)
+module_init(init_rc_map_pv951);
+module_exit(exit_rc_map_pv951);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
index 753e43e..1456dda 100644
--- a/drivers/media/rc/keymaps/rc-rc6-mce.c
+++ b/drivers/media/rc/keymaps/rc-rc6-mce.c
@@ -112,8 +112,8 @@ static void __exit exit_rc_map_rc6_mce(void)
 	rc_map_unregister(&rc6_mce_map);
 }
 
-module_init(init_rc_map_rc6_mce)
-module_exit(exit_rc_map_rc6_mce)
+module_init(init_rc_map_rc6_mce);
+module_exit(exit_rc_map_rc6_mce);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
index 073694d..7c14125 100644
--- a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
+++ b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
@@ -72,8 +72,8 @@ static void __exit exit_rc_map_real_audio_220_32_keys(void)
 	rc_map_unregister(&real_audio_220_32_keys_map);
 }
 
-module_init(init_rc_map_real_audio_220_32_keys)
-module_exit(exit_rc_map_real_audio_220_32_keys)
+module_init(init_rc_map_real_audio_220_32_keys);
+module_exit(exit_rc_map_real_audio_220_32_keys);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-snapstream-firefly.c b/drivers/media/rc/keymaps/rc-snapstream-firefly.c
index c7f33ec..4db164b 100644
--- a/drivers/media/rc/keymaps/rc-snapstream-firefly.c
+++ b/drivers/media/rc/keymaps/rc-snapstream-firefly.c
@@ -100,8 +100,8 @@ static void __exit exit_rc_map_snapstream_firefly(void)
 	rc_map_unregister(&snapstream_firefly_map);
 }
 
-module_init(init_rc_map_snapstream_firefly)
-module_exit(exit_rc_map_snapstream_firefly)
+module_init(init_rc_map_snapstream_firefly);
+module_exit(exit_rc_map_snapstream_firefly);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Anssi Hannula <anssi.hannula@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-streamzap.c b/drivers/media/rc/keymaps/rc-streamzap.c
index f9a0757..712ef6b 100644
--- a/drivers/media/rc/keymaps/rc-streamzap.c
+++ b/drivers/media/rc/keymaps/rc-streamzap.c
@@ -76,8 +76,8 @@ static void __exit exit_rc_map_streamzap(void)
 	rc_map_unregister(&streamzap_map);
 }
 
-module_init(init_rc_map_streamzap)
-module_exit(exit_rc_map_streamzap)
+module_init(init_rc_map_streamzap);
+module_exit(exit_rc_map_streamzap);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
index 5039be7..e7aa04c 100644
--- a/drivers/media/rc/keymaps/rc-tbs-nec.c
+++ b/drivers/media/rc/keymaps/rc-tbs-nec.c
@@ -69,8 +69,8 @@ static void __exit exit_rc_map_tbs_nec(void)
 	rc_map_unregister(&tbs_nec_map);
 }
 
-module_init(init_rc_map_tbs_nec)
-module_exit(exit_rc_map_tbs_nec)
+module_init(init_rc_map_tbs_nec);
+module_exit(exit_rc_map_tbs_nec);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-technisat-usb2.c b/drivers/media/rc/keymaps/rc-technisat-usb2.c
index f9733bb..c049efd 100644
--- a/drivers/media/rc/keymaps/rc-technisat-usb2.c
+++ b/drivers/media/rc/keymaps/rc-technisat-usb2.c
@@ -87,8 +87,8 @@ static void __exit exit_rc_map(void)
 	rc_map_unregister(&technisat_usb2_map);
 }
 
-module_init(init_rc_map)
-module_exit(exit_rc_map)
+module_init(init_rc_map);
+module_exit(exit_rc_map);
 
 MODULE_AUTHOR("Patrick Boettcher <pboettcher@kernellabs.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
index 53629fb..2b852b0 100644
--- a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
@@ -86,8 +86,8 @@ static void __exit exit_rc_map_terratec_cinergy_xs(void)
 	rc_map_unregister(&terratec_cinergy_xs_map);
 }
 
-module_init(init_rc_map_terratec_cinergy_xs)
-module_exit(exit_rc_map_terratec_cinergy_xs)
+module_init(init_rc_map_terratec_cinergy_xs);
+module_exit(exit_rc_map_terratec_cinergy_xs);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-terratec-slim-2.c b/drivers/media/rc/keymaps/rc-terratec-slim-2.c
index 4c149ef..e50ed9c 100644
--- a/drivers/media/rc/keymaps/rc-terratec-slim-2.c
+++ b/drivers/media/rc/keymaps/rc-terratec-slim-2.c
@@ -66,8 +66,8 @@ static void __exit exit_rc_map_terratec_slim_2(void)
 	rc_map_unregister(&terratec_slim_2_map);
 }
 
-module_init(init_rc_map_terratec_slim_2)
-module_exit(exit_rc_map_terratec_slim_2)
+module_init(init_rc_map_terratec_slim_2);
+module_exit(exit_rc_map_terratec_slim_2);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-terratec-slim.c b/drivers/media/rc/keymaps/rc-terratec-slim.c
index 3d8a19c..30421b4 100644
--- a/drivers/media/rc/keymaps/rc-terratec-slim.c
+++ b/drivers/media/rc/keymaps/rc-terratec-slim.c
@@ -73,8 +73,8 @@ static void __exit exit_rc_map_terratec_slim(void)
 	rc_map_unregister(&terratec_slim_map);
 }
 
-module_init(init_rc_map_terratec_slim)
-module_exit(exit_rc_map_terratec_slim)
+module_init(init_rc_map_terratec_slim);
+module_exit(exit_rc_map_terratec_slim);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-tevii-nec.c b/drivers/media/rc/keymaps/rc-tevii-nec.c
index f2c3b75..465488b 100644
--- a/drivers/media/rc/keymaps/rc-tevii-nec.c
+++ b/drivers/media/rc/keymaps/rc-tevii-nec.c
@@ -82,8 +82,8 @@ static void __exit exit_rc_map_tevii_nec(void)
 	rc_map_unregister(&tevii_nec_map);
 }
 
-module_init(init_rc_map_tevii_nec)
-module_exit(exit_rc_map_tevii_nec)
+module_init(init_rc_map_tevii_nec);
+module_exit(exit_rc_map_tevii_nec);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-tivo.c b/drivers/media/rc/keymaps/rc-tivo.c
index 454e062..c23d0dc 100644
--- a/drivers/media/rc/keymaps/rc-tivo.c
+++ b/drivers/media/rc/keymaps/rc-tivo.c
@@ -92,8 +92,8 @@ static void __exit exit_rc_map_tivo(void)
 	rc_map_unregister(&tivo_map);
 }
 
-module_init(init_rc_map_tivo)
-module_exit(exit_rc_map_tivo)
+module_init(init_rc_map_tivo);
+module_exit(exit_rc_map_tivo);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-total-media-in-hand.c b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
index 5b9f9ec..331d516 100644
--- a/drivers/media/rc/keymaps/rc-total-media-in-hand.c
+++ b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
@@ -79,8 +79,8 @@ static void __exit exit_rc_map_total_media_in_hand(void)
 	rc_map_unregister(&total_media_in_hand_map);
 }
 
-module_init(init_rc_map_total_media_in_hand)
-module_exit(exit_rc_map_total_media_in_hand)
+module_init(init_rc_map_total_media_in_hand);
+module_exit(exit_rc_map_total_media_in_hand);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-trekstor.c b/drivers/media/rc/keymaps/rc-trekstor.c
index f9a2e0f..801b9b5 100644
--- a/drivers/media/rc/keymaps/rc-trekstor.c
+++ b/drivers/media/rc/keymaps/rc-trekstor.c
@@ -74,8 +74,8 @@ static void __exit exit_rc_map_trekstor(void)
 	rc_map_unregister(&trekstor_map);
 }
 
-module_init(init_rc_map_trekstor)
-module_exit(exit_rc_map_trekstor)
+module_init(init_rc_map_trekstor);
+module_exit(exit_rc_map_trekstor);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
index caeff85..d94e335 100644
--- a/drivers/media/rc/keymaps/rc-tt-1500.c
+++ b/drivers/media/rc/keymaps/rc-tt-1500.c
@@ -76,8 +76,8 @@ static void __exit exit_rc_map_tt_1500(void)
 	rc_map_unregister(&tt_1500_map);
 }
 
-module_init(init_rc_map_tt_1500)
-module_exit(exit_rc_map_tt_1500)
+module_init(init_rc_map_tt_1500);
+module_exit(exit_rc_map_tt_1500);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-twinhan1027.c b/drivers/media/rc/keymaps/rc-twinhan1027.c
index 509299b..9d9a9df 100644
--- a/drivers/media/rc/keymaps/rc-twinhan1027.c
+++ b/drivers/media/rc/keymaps/rc-twinhan1027.c
@@ -81,8 +81,8 @@ static void __exit exit_rc_map_twinhan_vp1027(void)
 	rc_map_unregister(&twinhan_vp1027_map);
 }
 
-module_init(init_rc_map_twinhan_vp1027)
-module_exit(exit_rc_map_twinhan_vp1027)
+module_init(init_rc_map_twinhan_vp1027);
+module_exit(exit_rc_map_twinhan_vp1027);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sergey Ivanov <123kash@gmail.com>");
diff --git a/drivers/media/rc/keymaps/rc-videomate-m1f.c b/drivers/media/rc/keymaps/rc-videomate-m1f.c
index 23ee05e..ef5d5aa 100644
--- a/drivers/media/rc/keymaps/rc-videomate-m1f.c
+++ b/drivers/media/rc/keymaps/rc-videomate-m1f.c
@@ -86,8 +86,8 @@ static void __exit exit_rc_map_videomate_k100(void)
 	rc_map_unregister(&videomate_k100_map);
 }
 
-module_init(init_rc_map_videomate_k100)
-module_exit(exit_rc_map_videomate_k100)
+module_init(init_rc_map_videomate_k100);
+module_exit(exit_rc_map_videomate_k100);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pavel Osnova <pvosnova@gmail.com>");
diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
index 8bfc3e8..cc3f9e8 100644
--- a/drivers/media/rc/keymaps/rc-videomate-s350.c
+++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
@@ -79,8 +79,8 @@ static void __exit exit_rc_map_videomate_s350(void)
 	rc_map_unregister(&videomate_s350_map);
 }
 
-module_init(init_rc_map_videomate_s350)
-module_exit(exit_rc_map_videomate_s350)
+module_init(init_rc_map_videomate_s350);
+module_exit(exit_rc_map_videomate_s350);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
index 390ce94..44b2d80 100644
--- a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
+++ b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
@@ -81,8 +81,8 @@ static void __exit exit_rc_map_videomate_tv_pvr(void)
 	rc_map_unregister(&videomate_tv_pvr_map);
 }
 
-module_init(init_rc_map_videomate_tv_pvr)
-module_exit(exit_rc_map_videomate_tv_pvr)
+module_init(init_rc_map_videomate_tv_pvr);
+module_exit(exit_rc_map_videomate_tv_pvr);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
index 2852bf7..25418ca 100644
--- a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
+++ b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
@@ -76,8 +76,8 @@ static void __exit exit_rc_map_winfast_usbii_deluxe(void)
 	rc_map_unregister(&winfast_usbii_deluxe_map);
 }
 
-module_init(init_rc_map_winfast_usbii_deluxe)
-module_exit(exit_rc_map_winfast_usbii_deluxe)
+module_init(init_rc_map_winfast_usbii_deluxe);
+module_exit(exit_rc_map_winfast_usbii_deluxe);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
index 2df1cba..16c9d33c 100644
--- a/drivers/media/rc/keymaps/rc-winfast.c
+++ b/drivers/media/rc/keymaps/rc-winfast.c
@@ -96,8 +96,8 @@ static void __exit exit_rc_map_winfast(void)
 	rc_map_unregister(&winfast_map);
 }
 
-module_init(init_rc_map_winfast)
-module_exit(exit_rc_map_winfast)
+module_init(init_rc_map_winfast);
+module_exit(exit_rc_map_winfast);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 5ccbd46..e19098d 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -976,7 +976,7 @@ static void __exit videodev_exit(void)
 }
 
 subsys_initcall(videodev_init);
-module_exit(videodev_exit)
+module_exit(videodev_exit);
 
 MODULE_AUTHOR("Alan Cox, Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_DESCRIPTION("Device registrar for Video4Linux drivers v2");
diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
index bbaec0c..4ca0219 100644
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -435,7 +435,7 @@ static void __exit egpio_exit(void)
 
 /* start early for dependencies */
 subsys_initcall(egpio_init);
-module_exit(egpio_exit)
+module_exit(egpio_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kevin O'Connor <kevin@koconnor.net>");
diff --git a/drivers/net/arcnet/arc-rimi.c b/drivers/net/arcnet/arc-rimi.c
index b8b4c7b..daf86d1 100644
--- a/drivers/net/arcnet/arc-rimi.c
+++ b/drivers/net/arcnet/arc-rimi.c
@@ -394,5 +394,5 @@ static int __init arcrimi_setup(char *s)
 __setup("arcrimi=", arcrimi_setup);
 #endif				/* MODULE */
 
-module_init(arc_rimi_init)
-module_exit(arc_rimi_exit)
+module_init(arc_rimi_init);
+module_exit(arc_rimi_exit);
diff --git a/drivers/net/arcnet/com20020-isa.c b/drivers/net/arcnet/com20020-isa.c
index 45c61a2..891a0aa 100644
--- a/drivers/net/arcnet/com20020-isa.c
+++ b/drivers/net/arcnet/com20020-isa.c
@@ -217,5 +217,5 @@ __setup("com20020=", com20020isa_setup);
 
 #endif				/* MODULE */
 
-module_init(com20020_init)
-module_exit(com20020_exit)
+module_init(com20020_init);
+module_exit(com20020_exit);
diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index d427493..bdda5d1 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -192,5 +192,5 @@ static void __exit com20020pci_cleanup(void)
 	pci_unregister_driver(&com20020pci_driver);
 }
 
-module_init(com20020pci_init)
-module_exit(com20020pci_cleanup)
+module_init(com20020pci_init);
+module_exit(com20020pci_cleanup);
diff --git a/drivers/net/arcnet/com90io.c b/drivers/net/arcnet/com90io.c
index 487d780..44cd084 100644
--- a/drivers/net/arcnet/com90io.c
+++ b/drivers/net/arcnet/com90io.c
@@ -429,5 +429,5 @@ static void __exit com90io_exit(void)
 	free_netdev(dev);
 }
 
-module_init(com90io_init)
-module_exit(com90io_exit)
+module_init(com90io_init);
+module_exit(com90io_exit);
diff --git a/drivers/net/ethernet/cadence/at91_ether.c b/drivers/net/ethernet/cadence/at91_ether.c
index 7788419..b107e7f 100644
--- a/drivers/net/ethernet/cadence/at91_ether.c
+++ b/drivers/net/ethernet/cadence/at91_ether.c
@@ -1290,8 +1290,8 @@ static void __exit at91ether_exit(void)
 	platform_driver_unregister(&at91ether_driver);
 }
 
-module_init(at91ether_init)
-module_exit(at91ether_exit)
+module_init(at91ether_init);
+module_exit(at91ether_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("AT91RM9200 EMAC Ethernet driver");
diff --git a/drivers/net/ethernet/dec/tulip/xircom_cb.c b/drivers/net/ethernet/dec/tulip/xircom_cb.c
index 138bf83..2773355 100644
--- a/drivers/net/ethernet/dec/tulip/xircom_cb.c
+++ b/drivers/net/ethernet/dec/tulip/xircom_cb.c
@@ -1184,6 +1184,6 @@ static void __exit xircom_exit(void)
 	pci_unregister_driver(&xircom_ops);
 }
 
-module_init(xircom_init)
-module_exit(xircom_exit)
+module_init(xircom_init);
+module_exit(xircom_exit);
 
diff --git a/drivers/net/ethernet/hp/hp100.c b/drivers/net/ethernet/hp/hp100.c
index d496673..cf009d4 100644
--- a/drivers/net/ethernet/hp/hp100.c
+++ b/drivers/net/ethernet/hp/hp100.c
@@ -3062,5 +3062,5 @@ static void __exit hp100_module_exit(void)
 #endif
 }
 
-module_init(hp100_module_init)
-module_exit(hp100_module_exit)
+module_init(hp100_module_init);
+module_exit(hp100_module_exit);
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 5a39b22..8e077a5 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5563,5 +5563,5 @@ static void __exit b43_exit(void)
 	b43_debugfs_exit();
 }
 
-module_init(b43_init)
-module_exit(b43_exit)
+module_init(b43_init);
+module_exit(b43_exit);
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index cd9c9bc..3743425 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -4031,5 +4031,5 @@ static void __exit b43legacy_exit(void)
 	b43legacy_debugfs_exit();
 }
 
-module_init(b43legacy_init)
-module_exit(b43legacy_exit)
+module_init(b43legacy_init);
+module_exit(b43legacy_exit);
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index f2f501e..30f6e44 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -775,5 +775,5 @@ static void __exit led_exit(void)
 }
 
 #ifdef CONFIG_PROC_FS
-module_init(led_create_procfs)
+module_init(led_create_procfs);
 #endif
diff --git a/drivers/parport/parport_atari.c b/drivers/parport/parport_atari.c
index 7ad59ac..15b41d8 100644
--- a/drivers/parport/parport_atari.c
+++ b/drivers/parport/parport_atari.c
@@ -220,5 +220,5 @@ MODULE_DESCRIPTION("Parport Driver for Atari builtin Port");
 MODULE_SUPPORTED_DEVICE("Atari builtin Parallel Port");
 MODULE_LICENSE("GPL");
 
-module_init(parport_atari_init)
-module_exit(parport_atari_exit)
+module_init(parport_atari_init);
+module_exit(parport_atari_exit);
diff --git a/drivers/parport/parport_mfc3.c b/drivers/parport/parport_mfc3.c
index 7578d79..4d8146b 100644
--- a/drivers/parport/parport_mfc3.c
+++ b/drivers/parport/parport_mfc3.c
@@ -366,5 +366,5 @@ MODULE_DESCRIPTION("Parport Driver for Multiface 3 expansion cards Parallel Port
 MODULE_SUPPORTED_DEVICE("Multiface 3 Parallel Port");
 MODULE_LICENSE("GPL");
 
-module_init(parport_mfc3_init)
-module_exit(parport_mfc3_exit)
+module_init(parport_mfc3_init);
+module_exit(parport_mfc3_exit);
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 5abffe5..3734d43 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -3334,5 +3334,5 @@ static void __exit parport_pc_exit(void)
 MODULE_AUTHOR("Phil Blundell, Tim Waugh, others");
 MODULE_DESCRIPTION("PC-style parallel port driver");
 MODULE_LICENSE("GPL");
-module_init(parport_pc_init)
-module_exit(parport_pc_exit)
+module_init(parport_pc_init);
+module_exit(parport_pc_exit);
diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index 3f56bc0..5b98977 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -606,5 +606,5 @@ static void __exit parport_default_proc_unregister (void)
 }
 #endif
 
-module_init(parport_default_proc_register)
-module_exit(parport_default_proc_unregister)
+module_init(parport_default_proc_register);
+module_exit(parport_default_proc_unregister);
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index c739071..dcb4c0b 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1315,7 +1315,7 @@ static void __exit twlreg_exit(void)
 {
 	platform_driver_unregister(&twlreg_driver);
 }
-module_exit(twlreg_exit)
+module_exit(twlreg_exit);
 
 MODULE_DESCRIPTION("TWL regulator driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index b61a753..26703cf 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1785,7 +1785,7 @@ static void __exit nsp_cs_exit(void)
 }
 
 
-module_init(nsp_cs_init)
-module_exit(nsp_cs_exit)
+module_init(nsp_cs_init);
+module_exit(nsp_cs_exit);
 
 /* end */
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index df0f145..d5169a5 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1468,4 +1468,4 @@ static void __exit ssb_modexit(void)
 	b43_pci_ssb_bridge_exit();
 	bus_unregister(&ssb_bustype);
 }
-module_exit(ssb_modexit)
+module_exit(ssb_modexit);
diff --git a/drivers/staging/ramster/cluster/nodemanager.c b/drivers/staging/ramster/cluster/nodemanager.c
index de0e5c8..63090f6 100644
--- a/drivers/staging/ramster/cluster/nodemanager.c
+++ b/drivers/staging/ramster/cluster/nodemanager.c
@@ -988,5 +988,5 @@ out:
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
 
-module_init(init_r2nm)
-module_exit(exit_r2nm)
+module_init(init_r2nm);
+module_exit(exit_r2nm);
diff --git a/drivers/staging/ramster/zcache-main.c b/drivers/staging/ramster/zcache-main.c
index 4e7ef0e..1e1a9a0 100644
--- a/drivers/staging/ramster/zcache-main.c
+++ b/drivers/staging/ramster/zcache-main.c
@@ -3317,4 +3317,4 @@ out:
 	return ret;
 }
 
-module_init(zcache_init)
+module_init(zcache_init);
diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 1dccd93..cb1b338 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -1106,6 +1106,6 @@ static void __exit rtsx_exit(void)
 	printk(KERN_INFO "%s module exit\n", CR_DRIVER_NAME);
 }
 
-module_init(rtsx_init)
-module_exit(rtsx_exit)
+module_init(rtsx_init);
+module_exit(rtsx_exit);
 
diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 2734dac..4a54758 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -2081,4 +2081,4 @@ out:
 	return ret;
 }
 
-module_init(zcache_init)
+module_init(zcache_init);
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a783d53..7ab5159 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -902,6 +902,6 @@ static void __exit uio_exit(void)
 	release_uio_class();
 }
 
-module_init(uio_init)
-module_exit(uio_exit)
+module_init(uio_init);
+module_exit(uio_exit);
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
index dcb7952..c103f0c 100644
--- a/drivers/xen/tmem.c
+++ b/drivers/xen/tmem.c
@@ -402,4 +402,4 @@ static int __init xen_tmem_init(void)
 	return 0;
 }
 
-module_init(xen_tmem_init)
+module_init(xen_tmem_init);
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index b85efa7..eb96df6 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -635,8 +635,8 @@ static void __exit exit_v9fs(void)
 	unregister_filesystem(&v9fs_fs_type);
 }
 
-module_init(init_v9fs)
-module_exit(exit_v9fs)
+module_init(init_v9fs);
+module_exit(exit_v9fs);
 
 MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
 MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 06fdcc9..9153ec7 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -537,6 +537,6 @@ static void __exit exit_adfs_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_adfs_fs)
-module_exit(exit_adfs_fs)
+module_init(init_adfs_fs);
+module_exit(exit_adfs_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 0782653..2386b0d 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -618,5 +618,5 @@ static void __exit exit_affs_fs(void)
 MODULE_DESCRIPTION("Amiga filesystem support for Linux");
 MODULE_LICENSE("GPL");
 
-module_init(init_affs_fs)
-module_exit(exit_affs_fs)
+module_init(init_affs_fs);
+module_exit(exit_affs_fs);
diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
index cddc74b..afd9c44 100644
--- a/fs/autofs4/init.c
+++ b/fs/autofs4/init.c
@@ -46,6 +46,6 @@ static void __exit exit_autofs4_fs(void)
 	unregister_filesystem(&autofs_fs_type);
 }
 
-module_init(init_autofs4_fs) 
-module_exit(exit_autofs4_fs)
+module_init(init_autofs4_fs);
+module_exit(exit_autofs4_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index e18da23..15e4c05 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -973,5 +973,5 @@ Macros that typecheck the init and exit functions,
 ensures that they are called at init and cleanup,
 and eliminates warnings about unused functions.
 */
-module_init(init_befs_fs)
-module_exit(exit_befs_fs)
+module_init(init_befs_fs);
+module_exit(exit_befs_fs);
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 9870417..307871b 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -490,5 +490,5 @@ static void __exit exit_bfs_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_bfs_fs)
-module_exit(exit_bfs_fs)
+module_init(init_bfs_fs);
+module_exit(exit_bfs_fs);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 96eb9fe..274a35a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1593,7 +1593,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_exit_compress();
 }
 
-module_init(init_btrfs_fs)
-module_exit(exit_btrfs_fs)
+module_init(init_btrfs_fs);
+module_exit(exit_btrfs_fs);
 
 MODULE_LICENSE("GPL");
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8b6e344..2efc6f0 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1216,5 +1216,5 @@ MODULE_DESCRIPTION
     ("VFS to access servers complying with the SNIA CIFS Specification "
      "e.g. Samba and Windows");
 MODULE_VERSION(CIFS_VERSION);
-module_init(init_cifs)
-module_exit(exit_cifs)
+module_init(init_cifs);
+module_exit(exit_cifs);
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index d013c46..002bbdf 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -593,6 +593,6 @@ static void __exit exit_cramfs_fs(void)
 	unregister_filesystem(&cramfs_fs_type);
 }
 
-module_init(init_cramfs_fs)
-module_exit(exit_cramfs_fs)
+module_init(init_cramfs_fs);
+module_exit(exit_cramfs_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 979c1e3..9853a20 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -651,4 +651,4 @@ static int __init init_devpts_fs(void)
 	}
 	return err;
 }
-module_init(init_devpts_fs)
+module_init(init_devpts_fs);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 0c85fae..b51ae4f 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1304,4 +1304,4 @@ static __init int dio_init(void)
 	dio_cache = KMEM_CACHE(dio, SLAB_PANIC);
 	return 0;
 }
-module_init(dio_init)
+module_init(dio_init);
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 6895493..cf35e3a 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -862,5 +862,5 @@ MODULE_DESCRIPTION("eCryptfs");
 
 MODULE_LICENSE("GPL");
 
-module_init(ecryptfs_init)
-module_exit(ecryptfs_exit)
+module_init(ecryptfs_init);
+module_exit(ecryptfs_exit);
diff --git a/fs/efs/super.c b/fs/efs/super.c
index e755ec7..a0ba063 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -146,8 +146,8 @@ static void __exit exit_efs_fs(void) {
 	destroy_inodecache();
 }
 
-module_init(init_efs_fs)
-module_exit(exit_efs_fs)
+module_init(init_efs_fs);
+module_exit(exit_efs_fs);
 
 static efs_block_t efs_validate_vh(struct volume_header *vh) {
 	int		i;
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 4337836..fe212d3 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -1054,5 +1054,5 @@ MODULE_AUTHOR("Avishay Traeger <avishay@gmail.com>");
 MODULE_DESCRIPTION("exofs");
 MODULE_LICENSE("GPL");
 
-module_init(init_exofs)
-module_exit(exit_exofs)
+module_init(init_exofs);
+module_exit(exit_exofs);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index b3621cb..c7e62aa 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1522,5 +1522,5 @@ static void __exit exit_ext2_fs(void)
 MODULE_AUTHOR("Remy Card and others");
 MODULE_DESCRIPTION("Second Extended Filesystem");
 MODULE_LICENSE("GPL");
-module_init(init_ext2_fs)
-module_exit(exit_ext2_fs)
+module_init(init_ext2_fs);
+module_exit(exit_ext2_fs);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 8c3a44b..6acb601 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -3095,5 +3095,5 @@ static void __exit exit_ext3_fs(void)
 MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
 MODULE_DESCRIPTION("Second Extended Filesystem with journaling extensions");
 MODULE_LICENSE("GPL");
-module_init(init_ext3_fs)
-module_exit(exit_ext3_fs)
+module_init(init_ext3_fs);
+module_exit(exit_ext3_fs);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index eb7aa3e..f32da0a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5151,5 +5151,5 @@ static void __exit ext4_exit_fs(void)
 MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
 MODULE_DESCRIPTION("Fourth Extended Filesystem");
 MODULE_LICENSE("GPL");
-module_init(ext4_init_fs)
-module_exit(ext4_exit_fs)
+module_init(ext4_init_fs);
+module_exit(ext4_exit_fs);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index a3d81eb..ab86159 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1597,7 +1597,7 @@ static void __exit exit_fat_fs(void)
 	fat_destroy_inodecache();
 }
 
-module_init(init_fat_fs)
-module_exit(exit_fat_fs)
+module_init(init_fat_fs);
+module_exit(exit_fat_fs);
 
 MODULE_LICENSE("GPL");
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index c5938c9..6da7716 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -689,5 +689,5 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Werner Almesberger");
 MODULE_DESCRIPTION("MS-DOS filesystem support");
 
-module_init(init_msdos_fs)
-module_exit(exit_msdos_fs)
+module_init(init_msdos_fs);
+module_exit(exit_msdos_fs);
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 98ae804..be33bc2 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1094,5 +1094,5 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("VFAT filesystem support");
 MODULE_AUTHOR("Gordon Chaffee");
 
-module_init(init_vfat_fs)
-module_exit(exit_vfat_fs)
+module_init(init_vfat_fs);
+module_exit(exit_vfat_fs);
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 81b70e6..100e16b 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -842,4 +842,4 @@ static int __init fcntl_init(void)
 	return 0;
 }
 
-module_init(fcntl_init)
+module_init(fcntl_init);
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 7b4c537..c5b99b5 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -486,5 +486,5 @@ static void __exit exit_hfs_fs(void)
 	kmem_cache_destroy(hfs_inode_cachep);
 }
 
-module_init(init_hfs_fs)
-module_exit(exit_hfs_fs)
+module_init(init_hfs_fs);
+module_exit(exit_hfs_fs);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index a9bca4b..07da6e1 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -618,5 +618,5 @@ static void __exit exit_hfsplus_fs(void)
 	kmem_cache_destroy(hfsplus_inode_cachep);
 }
 
-module_init(init_hfsplus_fs)
-module_exit(exit_hfsplus_fs)
+module_init(init_hfsplus_fs);
+module_exit(exit_hfsplus_fs);
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 2afa5bb..d06675b 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -1010,6 +1010,6 @@ static void __exit exit_hostfs(void)
 	unregister_filesystem(&hostfs_type);
 }
 
-module_init(init_hostfs)
-module_exit(exit_hostfs)
+module_init(init_hostfs);
+module_exit(exit_hostfs);
 MODULE_LICENSE("GPL");
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 706a12c..e9b91fb 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -704,6 +704,6 @@ static void __exit exit_hpfs_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_hpfs_fs)
-module_exit(exit_hpfs_fs)
+module_init(init_hpfs_fs);
+module_exit(exit_hpfs_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index d4f93b5..8d34083 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -763,6 +763,6 @@ static void __exit exit_hppfs(void)
 	unregister_filesystem(&hppfs_type);
 }
 
-module_init(init_hppfs)
-module_exit(exit_hppfs)
+module_init(init_hppfs);
+module_exit(exit_hppfs);
 MODULE_LICENSE("GPL");
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index cc9281b..6ad225c 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1048,7 +1048,7 @@ static void __exit exit_hugetlbfs_fs(void)
 	bdi_destroy(&hugetlbfs_backing_dev_info);
 }
 
-module_init(init_hugetlbfs_fs)
-module_exit(exit_hugetlbfs_fs)
+module_init(init_hugetlbfs_fs);
+module_exit(exit_hugetlbfs_fs);
 
 MODULE_LICENSE("GPL");
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 29037c3..c6e93d5 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1580,8 +1580,8 @@ static void __exit exit_iso9660_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_iso9660_fs)
-module_exit(exit_iso9660_fs)
+module_init(init_iso9660_fs);
+module_exit(exit_iso9660_fs);
 MODULE_LICENSE("GPL");
 /* Actual filesystem name is iso9660, as requested in filesystems.c */
 MODULE_ALIAS("iso9660");
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 4a82950..3c06867 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -901,5 +901,5 @@ static void __exit exit_jfs_fs(void)
 	kmem_cache_destroy(jfs_inode_cachep);
 }
 
-module_init(init_jfs_fs)
-module_exit(exit_jfs_fs)
+module_init(init_jfs_fs);
+module_exit(exit_jfs_fs);
diff --git a/fs/mbcache.c b/fs/mbcache.c
index 8c32ef3..7057d23 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -615,6 +615,6 @@ static void __exit exit_mbcache(void)
 	unregister_shrinker(&mb_cache_shrinker);
 }
 
-module_init(init_mbcache)
-module_exit(exit_mbcache)
+module_init(init_mbcache);
+module_exit(exit_mbcache);
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 2a503ad..14ed217 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -670,7 +670,7 @@ static void __exit exit_minix_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_minix_fs)
-module_exit(exit_minix_fs)
+module_init(init_minix_fs);
+module_exit(exit_minix_fs);
 MODULE_LICENSE("GPL");
 
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 333df07..f4b10cd 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -1063,6 +1063,6 @@ static void __exit exit_ncp_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_ncp_fs)
-module_exit(exit_ncp_fs)
+module_init(init_ncp_fs);
+module_exit(exit_ncp_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index e605d69..5cc52b5 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1731,5 +1731,5 @@ MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
 MODULE_LICENSE("GPL");
 module_param(enable_ino64, bool, 0644);
 
-module_init(init_nfs_fs)
-module_exit(exit_nfs_fs)
+module_init(init_nfs_fs);
+module_exit(exit_nfs_fs);
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index c55298e..802e929 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1239,5 +1239,5 @@ static void __exit exit_nfsd(void)
 
 MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
 MODULE_LICENSE("GPL");
-module_init(init_nfsd)
-module_exit(exit_nfsd)
+module_init(init_nfsd);
+module_exit(exit_nfsd);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1099a76..d87e645 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1456,5 +1456,5 @@ static void __exit exit_nilfs_fs(void)
 	unregister_filesystem(&nilfs_fs_type);
 }
 
-module_init(init_nilfs_fs)
-module_exit(exit_nilfs_fs)
+module_init(init_nilfs_fs);
+module_exit(exit_nilfs_fs);
diff --git a/fs/nls/mac-celtic.c b/fs/nls/mac-celtic.c
index 634a8b7..2a18031 100644
--- a/fs/nls/mac-celtic.c
+++ b/fs/nls/mac-celtic.c
@@ -596,7 +596,7 @@ static void __exit exit_nls_macceltic(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_macceltic)
-module_exit(exit_nls_macceltic)
+module_init(init_nls_macceltic);
+module_exit(exit_nls_macceltic);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/mac-centeuro.c b/fs/nls/mac-centeuro.c
index 979e626..28e659f 100644
--- a/fs/nls/mac-centeuro.c
+++ b/fs/nls/mac-centeuro.c
@@ -526,7 +526,7 @@ static void __exit exit_nls_maccenteuro(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_maccenteuro)
-module_exit(exit_nls_maccenteuro)
+module_init(init_nls_maccenteuro);
+module_exit(exit_nls_maccenteuro);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/mac-croatian.c b/fs/nls/mac-croatian.c
index dd3f675..bb7ffbd 100644
--- a/fs/nls/mac-croatian.c
+++ b/fs/nls/mac-croatian.c
@@ -596,7 +596,7 @@ static void __exit exit_nls_maccroatian(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_maccroatian)
-module_exit(exit_nls_maccroatian)
+module_init(init_nls_maccroatian);
+module_exit(exit_nls_maccroatian);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/mac-cyrillic.c b/fs/nls/mac-cyrillic.c
index 1112c84..63f848c 100644
--- a/fs/nls/mac-cyrillic.c
+++ b/fs/nls/mac-cyrillic.c
@@ -491,7 +491,7 @@ static void __exit exit_nls_maccyrillic(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_maccyrillic)
-module_exit(exit_nls_maccyrillic)
+module_init(init_nls_maccyrillic);
+module_exit(exit_nls_maccyrillic);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/mac-gaelic.c b/fs/nls/mac-gaelic.c
index 2de9158..73c60a1 100644
--- a/fs/nls/mac-gaelic.c
+++ b/fs/nls/mac-gaelic.c
@@ -561,7 +561,7 @@ static void __exit exit_nls_macgaelic(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_macgaelic)
-module_exit(exit_nls_macgaelic)
+module_init(init_nls_macgaelic);
+module_exit(exit_nls_macgaelic);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/mac-greek.c b/fs/nls/mac-greek.c
index a863100..ac8cc6a 100644
--- a/fs/nls/mac-greek.c
+++ b/fs/nls/mac-greek.c
@@ -491,7 +491,7 @@ static void __exit exit_nls_macgreek(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_macgreek)
-module_exit(exit_nls_macgreek)
+module_init(init_nls_macgreek);
+module_exit(exit_nls_macgreek);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/mac-iceland.c b/fs/nls/mac-iceland.c
index babe299..d6b5ab7 100644
--- a/fs/nls/mac-iceland.c
+++ b/fs/nls/mac-iceland.c
@@ -596,7 +596,7 @@ static void __exit exit_nls_maciceland(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_maciceland)
-module_exit(exit_nls_maciceland)
+module_init(init_nls_maciceland);
+module_exit(exit_nls_maciceland);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/mac-inuit.c b/fs/nls/mac-inuit.c
index 312364f..a7e9b16 100644
--- a/fs/nls/mac-inuit.c
+++ b/fs/nls/mac-inuit.c
@@ -526,7 +526,7 @@ static void __exit exit_nls_macinuit(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_macinuit)
-module_exit(exit_nls_macinuit)
+module_init(init_nls_macinuit);
+module_exit(exit_nls_macinuit);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/mac-roman.c b/fs/nls/mac-roman.c
index 53ce080..f1971c5 100644
--- a/fs/nls/mac-roman.c
+++ b/fs/nls/mac-roman.c
@@ -631,7 +631,7 @@ static void __exit exit_nls_macroman(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_macroman)
-module_exit(exit_nls_macroman)
+module_init(init_nls_macroman);
+module_exit(exit_nls_macroman);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/mac-romanian.c b/fs/nls/mac-romanian.c
index add6f7a..72b7cd8 100644
--- a/fs/nls/mac-romanian.c
+++ b/fs/nls/mac-romanian.c
@@ -596,7 +596,7 @@ static void __exit exit_nls_macromanian(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_macromanian)
-module_exit(exit_nls_macromanian)
+module_init(init_nls_macromanian);
+module_exit(exit_nls_macromanian);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/mac-turkish.c b/fs/nls/mac-turkish.c
index dffa96d..2520412 100644
--- a/fs/nls/mac-turkish.c
+++ b/fs/nls/mac-turkish.c
@@ -596,7 +596,7 @@ static void __exit exit_nls_macturkish(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_macturkish)
-module_exit(exit_nls_macturkish)
+module_init(init_nls_macturkish);
+module_exit(exit_nls_macturkish);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_ascii.c b/fs/nls/nls_ascii.c
index 7020e94..5cd626f 100644
--- a/fs/nls/nls_ascii.c
+++ b/fs/nls/nls_ascii.c
@@ -161,7 +161,7 @@ static void __exit exit_nls_ascii(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_ascii)
-module_exit(exit_nls_ascii)
+module_init(init_nls_ascii);
+module_exit(exit_nls_ascii);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp1250.c b/fs/nls/nls_cp1250.c
index c8471fe..a231e04 100644
--- a/fs/nls/nls_cp1250.c
+++ b/fs/nls/nls_cp1250.c
@@ -341,7 +341,7 @@ static void __exit exit_nls_cp1250(void)
         unregister_nls(&table);
 }
 
-module_init(init_nls_cp1250)
-module_exit(exit_nls_cp1250)
+module_init(init_nls_cp1250);
+module_exit(exit_nls_cp1250);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp1251.c b/fs/nls/nls_cp1251.c
index 1939b46..7f422c5 100644
--- a/fs/nls/nls_cp1251.c
+++ b/fs/nls/nls_cp1251.c
@@ -296,7 +296,7 @@ static void __exit exit_nls_cp1251(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp1251)
-module_exit(exit_nls_cp1251)
+module_init(init_nls_cp1251);
+module_exit(exit_nls_cp1251);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp1255.c b/fs/nls/nls_cp1255.c
index 8120ae2..2df7740 100644
--- a/fs/nls/nls_cp1255.c
+++ b/fs/nls/nls_cp1255.c
@@ -378,8 +378,8 @@ static void __exit exit_nls_cp1255(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp1255)
-module_exit(exit_nls_cp1255)
+module_init(init_nls_cp1255);
+module_exit(exit_nls_cp1255);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS_NLS(iso8859-8);
diff --git a/fs/nls/nls_cp437.c b/fs/nls/nls_cp437.c
index ff37a46..488d1c1 100644
--- a/fs/nls/nls_cp437.c
+++ b/fs/nls/nls_cp437.c
@@ -382,7 +382,7 @@ static void __exit exit_nls_cp437(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp437)
-module_exit(exit_nls_cp437)
+module_init(init_nls_cp437);
+module_exit(exit_nls_cp437);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp737.c b/fs/nls/nls_cp737.c
index f5576b8..71e4ba2 100644
--- a/fs/nls/nls_cp737.c
+++ b/fs/nls/nls_cp737.c
@@ -345,7 +345,7 @@ static void __exit exit_nls_cp737(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp737)
-module_exit(exit_nls_cp737)
+module_init(init_nls_cp737);
+module_exit(exit_nls_cp737);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp775.c b/fs/nls/nls_cp775.c
index 4905635..09e5027 100644
--- a/fs/nls/nls_cp775.c
+++ b/fs/nls/nls_cp775.c
@@ -314,7 +314,7 @@ static void __exit exit_nls_cp775(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp775)
-module_exit(exit_nls_cp775)
+module_init(init_nls_cp775);
+module_exit(exit_nls_cp775);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp850.c b/fs/nls/nls_cp850.c
index fe5bdad..c37aa74 100644
--- a/fs/nls/nls_cp850.c
+++ b/fs/nls/nls_cp850.c
@@ -310,7 +310,7 @@ static void __exit exit_nls_cp850(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp850)
-module_exit(exit_nls_cp850)
+module_init(init_nls_cp850);
+module_exit(exit_nls_cp850);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp852.c b/fs/nls/nls_cp852.c
index ceb1c01..db5233f 100644
--- a/fs/nls/nls_cp852.c
+++ b/fs/nls/nls_cp852.c
@@ -332,7 +332,7 @@ static void __exit exit_nls_cp852(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp852)
-module_exit(exit_nls_cp852)
+module_init(init_nls_cp852);
+module_exit(exit_nls_cp852);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp855.c b/fs/nls/nls_cp855.c
index cc7f5fb2..fa0bf36 100644
--- a/fs/nls/nls_cp855.c
+++ b/fs/nls/nls_cp855.c
@@ -294,7 +294,7 @@ static void __exit exit_nls_cp855(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp855)
-module_exit(exit_nls_cp855)
+module_init(init_nls_cp855);
+module_exit(exit_nls_cp855);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp857.c b/fs/nls/nls_cp857.c
index e418e19..f6d2f3c 100644
--- a/fs/nls/nls_cp857.c
+++ b/fs/nls/nls_cp857.c
@@ -296,7 +296,7 @@ static void __exit exit_nls_cp857(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp857)
-module_exit(exit_nls_cp857)
+module_init(init_nls_cp857);
+module_exit(exit_nls_cp857);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp860.c b/fs/nls/nls_cp860.c
index a86c97d..efcb9e6 100644
--- a/fs/nls/nls_cp860.c
+++ b/fs/nls/nls_cp860.c
@@ -359,7 +359,7 @@ static void __exit exit_nls_cp860(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp860)
-module_exit(exit_nls_cp860)
+module_init(init_nls_cp860);
+module_exit(exit_nls_cp860);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp861.c b/fs/nls/nls_cp861.c
index bd92022..1314fea 100644
--- a/fs/nls/nls_cp861.c
+++ b/fs/nls/nls_cp861.c
@@ -382,7 +382,7 @@ static void __exit exit_nls_cp861(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp861)
-module_exit(exit_nls_cp861)
+module_init(init_nls_cp861);
+module_exit(exit_nls_cp861);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp862.c b/fs/nls/nls_cp862.c
index e9b68eb..ac0dfa1 100644
--- a/fs/nls/nls_cp862.c
+++ b/fs/nls/nls_cp862.c
@@ -416,7 +416,7 @@ static void __exit exit_nls_cp862(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp862)
-module_exit(exit_nls_cp862)
+module_init(init_nls_cp862);
+module_exit(exit_nls_cp862);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp863.c b/fs/nls/nls_cp863.c
index f8a9b07..7a1a927 100644
--- a/fs/nls/nls_cp863.c
+++ b/fs/nls/nls_cp863.c
@@ -376,7 +376,7 @@ static void __exit exit_nls_cp863(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp863)
-module_exit(exit_nls_cp863)
+module_init(init_nls_cp863);
+module_exit(exit_nls_cp863);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp864.c b/fs/nls/nls_cp864.c
index 8d31f43..e6e0f27 100644
--- a/fs/nls/nls_cp864.c
+++ b/fs/nls/nls_cp864.c
@@ -402,7 +402,7 @@ static void __exit exit_nls_cp864(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp864)
-module_exit(exit_nls_cp864)
+module_init(init_nls_cp864);
+module_exit(exit_nls_cp864);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp865.c b/fs/nls/nls_cp865.c
index 4bd902f..dc62732 100644
--- a/fs/nls/nls_cp865.c
+++ b/fs/nls/nls_cp865.c
@@ -382,7 +382,7 @@ static void __exit exit_nls_cp865(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp865)
-module_exit(exit_nls_cp865)
+module_init(init_nls_cp865);
+module_exit(exit_nls_cp865);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp866.c b/fs/nls/nls_cp866.c
index bdc7cb3..26e7b56 100644
--- a/fs/nls/nls_cp866.c
+++ b/fs/nls/nls_cp866.c
@@ -300,7 +300,7 @@ static void __exit exit_nls_cp866(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp866)
-module_exit(exit_nls_cp866)
+module_init(init_nls_cp866);
+module_exit(exit_nls_cp866);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp869.c b/fs/nls/nls_cp869.c
index 9f283a2..17c3385 100644
--- a/fs/nls/nls_cp869.c
+++ b/fs/nls/nls_cp869.c
@@ -310,7 +310,7 @@ static void __exit exit_nls_cp869(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp869)
-module_exit(exit_nls_cp869)
+module_init(init_nls_cp869);
+module_exit(exit_nls_cp869);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp874.c b/fs/nls/nls_cp874.c
index 0b3c488..afcbd8e 100644
--- a/fs/nls/nls_cp874.c
+++ b/fs/nls/nls_cp874.c
@@ -269,8 +269,8 @@ static void __exit exit_nls_cp874(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp874)
-module_exit(exit_nls_cp874)
+module_init(init_nls_cp874);
+module_exit(exit_nls_cp874);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS_NLS(tis-620);
diff --git a/fs/nls/nls_cp932.c b/fs/nls/nls_cp932.c
index 0ffed6f..038b753 100644
--- a/fs/nls/nls_cp932.c
+++ b/fs/nls/nls_cp932.c
@@ -7927,8 +7927,8 @@ static void __exit exit_nls_cp932(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp932)
-module_exit(exit_nls_cp932)
+module_init(init_nls_cp932);
+module_exit(exit_nls_cp932);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS_NLS(sjis);
diff --git a/fs/nls/nls_cp936.c b/fs/nls/nls_cp936.c
index 8277030..03e28ea 100644
--- a/fs/nls/nls_cp936.c
+++ b/fs/nls/nls_cp936.c
@@ -11105,8 +11105,8 @@ static void __exit exit_nls_cp936(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp936)
-module_exit(exit_nls_cp936)
+module_init(init_nls_cp936);
+module_exit(exit_nls_cp936);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS_NLS(gb2312);
diff --git a/fs/nls/nls_cp949.c b/fs/nls/nls_cp949.c
index 8a7a2fe85c..83a1643 100644
--- a/fs/nls/nls_cp949.c
+++ b/fs/nls/nls_cp949.c
@@ -13940,8 +13940,8 @@ static void __exit exit_nls_cp949(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp949)
-module_exit(exit_nls_cp949)
+module_init(init_nls_cp949);
+module_exit(exit_nls_cp949);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS_NLS(euc-kr);
diff --git a/fs/nls/nls_cp950.c b/fs/nls/nls_cp950.c
index ef25368..47adf75 100644
--- a/fs/nls/nls_cp950.c
+++ b/fs/nls/nls_cp950.c
@@ -9476,8 +9476,8 @@ static void __exit exit_nls_cp950(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_cp950)
-module_exit(exit_nls_cp950)
+module_init(init_nls_cp950);
+module_exit(exit_nls_cp950);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS_NLS(big5);
diff --git a/fs/nls/nls_euc-jp.c b/fs/nls/nls_euc-jp.c
index 7424929..f617dec 100644
--- a/fs/nls/nls_euc-jp.c
+++ b/fs/nls/nls_euc-jp.c
@@ -575,7 +575,7 @@ static void __exit exit_nls_euc_jp(void)
 	unload_nls(p_nls);
 }
 
-module_init(init_nls_euc_jp)
-module_exit(exit_nls_euc_jp)
+module_init(init_nls_euc_jp);
+module_exit(exit_nls_euc_jp);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-1.c b/fs/nls/nls_iso8859-1.c
index 7b951bb..2d2a168 100644
--- a/fs/nls/nls_iso8859-1.c
+++ b/fs/nls/nls_iso8859-1.c
@@ -252,7 +252,7 @@ static void __exit exit_nls_iso8859_1(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_iso8859_1)
-module_exit(exit_nls_iso8859_1)
+module_init(init_nls_iso8859_1);
+module_exit(exit_nls_iso8859_1);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-13.c b/fs/nls/nls_iso8859-13.c
index c4d52ea..7057dc1 100644
--- a/fs/nls/nls_iso8859-13.c
+++ b/fs/nls/nls_iso8859-13.c
@@ -280,7 +280,7 @@ static void __exit exit_nls_iso8859_13(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_iso8859_13)
-module_exit(exit_nls_iso8859_13)
+module_init(init_nls_iso8859_13);
+module_exit(exit_nls_iso8859_13);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-14.c b/fs/nls/nls_iso8859-14.c
index dc02600..4cbb2e9 100644
--- a/fs/nls/nls_iso8859-14.c
+++ b/fs/nls/nls_iso8859-14.c
@@ -336,7 +336,7 @@ static void __exit exit_nls_iso8859_14(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_iso8859_14)
-module_exit(exit_nls_iso8859_14)
+module_init(init_nls_iso8859_14);
+module_exit(exit_nls_iso8859_14);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-15.c b/fs/nls/nls_iso8859-15.c
index 3c7dfc8..007dc30 100644
--- a/fs/nls/nls_iso8859-15.c
+++ b/fs/nls/nls_iso8859-15.c
@@ -302,7 +302,7 @@ static void __exit exit_nls_iso8859_15(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_iso8859_15)
-module_exit(exit_nls_iso8859_15)
+module_init(init_nls_iso8859_15);
+module_exit(exit_nls_iso8859_15);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-2.c b/fs/nls/nls_iso8859-2.c
index a2d2197..8b4dac8 100644
--- a/fs/nls/nls_iso8859-2.c
+++ b/fs/nls/nls_iso8859-2.c
@@ -303,7 +303,7 @@ static void __exit exit_nls_iso8859_2(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_iso8859_2)
-module_exit(exit_nls_iso8859_2)
+module_init(init_nls_iso8859_2);
+module_exit(exit_nls_iso8859_2);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-3.c b/fs/nls/nls_iso8859-3.c
index a61e0da..07e0247 100644
--- a/fs/nls/nls_iso8859-3.c
+++ b/fs/nls/nls_iso8859-3.c
@@ -303,7 +303,7 @@ static void __exit exit_nls_iso8859_3(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_iso8859_3)
-module_exit(exit_nls_iso8859_3)
+module_init(init_nls_iso8859_3);
+module_exit(exit_nls_iso8859_3);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-4.c b/fs/nls/nls_iso8859-4.c
index e8ff555..9387240 100644
--- a/fs/nls/nls_iso8859-4.c
+++ b/fs/nls/nls_iso8859-4.c
@@ -303,7 +303,7 @@ static void __exit exit_nls_iso8859_4(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_iso8859_4)
-module_exit(exit_nls_iso8859_4)
+module_init(init_nls_iso8859_4);
+module_exit(exit_nls_iso8859_4);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-5.c b/fs/nls/nls_iso8859-5.c
index 4721e89..d168fd2 100644
--- a/fs/nls/nls_iso8859-5.c
+++ b/fs/nls/nls_iso8859-5.c
@@ -267,7 +267,7 @@ static void __exit exit_nls_iso8859_5(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_iso8859_5)
-module_exit(exit_nls_iso8859_5)
+module_init(init_nls_iso8859_5);
+module_exit(exit_nls_iso8859_5);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-6.c b/fs/nls/nls_iso8859-6.c
index 01a517d..cd0e99a 100644
--- a/fs/nls/nls_iso8859-6.c
+++ b/fs/nls/nls_iso8859-6.c
@@ -258,7 +258,7 @@ static void __exit exit_nls_iso8859_6(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_iso8859_6)
-module_exit(exit_nls_iso8859_6)
+module_init(init_nls_iso8859_6);
+module_exit(exit_nls_iso8859_6);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-7.c b/fs/nls/nls_iso8859-7.c
index 2d27b93..70c923c 100644
--- a/fs/nls/nls_iso8859-7.c
+++ b/fs/nls/nls_iso8859-7.c
@@ -312,7 +312,7 @@ static void __exit exit_nls_iso8859_7(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_iso8859_7)
-module_exit(exit_nls_iso8859_7)
+module_init(init_nls_iso8859_7);
+module_exit(exit_nls_iso8859_7);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-9.c b/fs/nls/nls_iso8859-9.c
index 694bf07..82dec0c 100644
--- a/fs/nls/nls_iso8859-9.c
+++ b/fs/nls/nls_iso8859-9.c
@@ -267,7 +267,7 @@ static void __exit exit_nls_iso8859_9(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_iso8859_9)
-module_exit(exit_nls_iso8859_9)
+module_init(init_nls_iso8859_9);
+module_exit(exit_nls_iso8859_9);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_koi8-r.c b/fs/nls/nls_koi8-r.c
index 4387531..16ae9aa 100644
--- a/fs/nls/nls_koi8-r.c
+++ b/fs/nls/nls_koi8-r.c
@@ -318,7 +318,7 @@ static void __exit exit_nls_koi8_r(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_koi8_r)
-module_exit(exit_nls_koi8_r)
+module_init(init_nls_koi8_r);
+module_exit(exit_nls_koi8_r);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_koi8-ru.c b/fs/nls/nls_koi8-ru.c
index e7bc1d7..8988308 100644
--- a/fs/nls/nls_koi8-ru.c
+++ b/fs/nls/nls_koi8-ru.c
@@ -77,7 +77,7 @@ static void __exit exit_nls_koi8_ru(void)
 	unload_nls(p_nls);
 }
 
-module_init(init_nls_koi8_ru)
-module_exit(exit_nls_koi8_ru)
+module_init(init_nls_koi8_ru);
+module_exit(exit_nls_koi8_ru);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_koi8-u.c b/fs/nls/nls_koi8-u.c
index 8c9f029..3e1ebf6 100644
--- a/fs/nls/nls_koi8-u.c
+++ b/fs/nls/nls_koi8-u.c
@@ -325,7 +325,7 @@ static void __exit exit_nls_koi8_u(void)
 	unregister_nls(&table);
 }
 
-module_init(init_nls_koi8_u)
-module_exit(exit_nls_koi8_u)
+module_init(init_nls_koi8_u);
+module_exit(exit_nls_koi8_u);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_utf8.c b/fs/nls/nls_utf8.c
index 0d60a44..9753265 100644
--- a/fs/nls/nls_utf8.c
+++ b/fs/nls/nls_utf8.c
@@ -63,6 +63,6 @@ static void __exit exit_nls_utf8(void)
         unregister_nls(&table);
 }
 
-module_init(init_nls_utf8)
-module_exit(exit_nls_utf8)
+module_init(init_nls_utf8);
+module_exit(exit_nls_utf8);
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 3344bdd..d69db71 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -408,4 +408,4 @@ static int __init dnotify_init(void)
 	return 0;
 }
 
-module_init(dnotify_init)
+module_init(dnotify_init);
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index b341492..327b717 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -3203,5 +3203,5 @@ module_param(debug_msgs, bint, 0);
 MODULE_PARM_DESC(debug_msgs, "Enable debug messages.");
 #endif
 
-module_init(init_ntfs_fs)
-module_exit(exit_ntfs_fs)
+module_init(init_ntfs_fs);
+module_exit(exit_ntfs_fs);
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index bb24064..1371bf3 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -985,5 +985,5 @@ out:
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
 
-module_init(init_o2nm)
-module_exit(exit_o2nm)
+module_init(init_o2nm);
+module_exit(exit_o2nm);
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index e31d6ae..ca24dc0 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -699,5 +699,5 @@ static void __exit exit_dlmfs_fs(void)
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
 
-module_init(init_dlmfs_fs)
-module_exit(exit_dlmfs_fs)
+module_init(init_dlmfs_fs);
+module_exit(exit_dlmfs_fs);
diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index bc49c97..4766c14 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -466,6 +466,6 @@ static void __exit exit_openprom_fs(void)
 	kmem_cache_destroy(op_inode_cachep);
 }
 
-module_init(init_openprom_fs)
-module_exit(exit_openprom_fs)
+module_init(init_openprom_fs);
+module_exit(exit_openprom_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 0d5071d..61807a7 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -699,7 +699,7 @@ static int __init vmcore_init(void)
 		proc_vmcore->size = vmcore_size;
 	return 0;
 }
-module_init(vmcore_init)
+module_init(vmcore_init);
 
 /* Cleanup function for vmcore module. */
 void vmcore_cleanup(void)
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index aeb19e6..2a13a38 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -313,7 +313,7 @@ static int __init init_pstore_fs(void)
 {
 	return register_filesystem(&pstore_fs_type);
 }
-module_init(init_pstore_fs)
+module_init(init_pstore_fs);
 
 MODULE_AUTHOR("Tony Luck <tony.luck@intel.com>");
 MODULE_LICENSE("GPL");
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 552e994..0bb7c2d 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -432,7 +432,7 @@ static void __exit exit_qnx4_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_qnx4_fs)
-module_exit(exit_qnx4_fs)
+module_init(init_qnx4_fs);
+module_exit(exit_qnx4_fs);
 MODULE_LICENSE("GPL");
 
diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index e44012d..2ffe3a7 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -693,6 +693,6 @@ static void __exit exit_qnx6_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_qnx6_fs)
-module_exit(exit_qnx6_fs)
+module_init(init_qnx6_fs);
+module_exit(exit_qnx6_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index a1fdabe..64975a5 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -271,7 +271,7 @@ static int __init init_ramfs_fs(void)
 {
 	return register_filesystem(&ramfs_fs_type);
 }
-module_init(init_ramfs_fs)
+module_init(init_ramfs_fs);
 
 int __init init_rootfs(void)
 {
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 7491c33..95b2997 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -583,7 +583,7 @@ static void __exit exit_sysv_fs(void)
 	sysv_destroy_icache();
 }
 
-module_init(init_sysv_fs)
-module_exit(exit_sysv_fs)
+module_init(init_sysv_fs);
+module_exit(exit_sysv_fs);
 MODULE_ALIAS("v7");
 MODULE_LICENSE("GPL");
diff --git a/fs/udf/super.c b/fs/udf/super.c
index ac8a348..656cbee 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -231,8 +231,8 @@ static void __exit exit_udf_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_udf_fs)
-module_exit(exit_udf_fs)
+module_init(init_udf_fs);
+module_exit(exit_udf_fs);
 
 static int udf_sb_alloc_partition_maps(struct super_block *sb, u32 count)
 {
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 302f340..d598bed 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1500,6 +1500,6 @@ static void __exit exit_ufs_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_ufs_fs)
-module_exit(exit_ufs_fs)
+module_init(init_ufs_fs);
+module_exit(exit_ufs_fs);
 MODULE_LICENSE("GPL");
diff --git a/include/linux/init.h b/include/linux/init.h
index 6b95109..446964e 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -264,7 +264,7 @@ void __init parse_early_options(char *cmdline);
  * builtin) or at module insertion time (if a module).  There can only
  * be one per module.
  */
-#define module_init(x)	__initcall(x);
+#define module_init(x)	__initcall(x)
 
 /**
  * module_exit() - driver exit entry point
@@ -276,7 +276,7 @@ void __init parse_early_options(char *cmdline);
  * compiled into the kernel, module_exit() has no effect.
  * There can only be one per module.
  */
-#define module_exit(x)	__exitcall(x);
+#define module_exit(x)	__exitcall(x)
 
 #else /* MODULE */
 
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 4e2e472..bc0bead 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1240,7 +1240,7 @@ static int __init crash_notes_memory_init(void)
 	}
 	return 0;
 }
-module_init(crash_notes_memory_init)
+module_init(crash_notes_memory_init);
 
 
 /*
@@ -1520,7 +1520,7 @@ static int __init crash_save_vmcoreinfo_init(void)
 	return 0;
 }
 
-module_init(crash_save_vmcoreinfo_init)
+module_init(crash_save_vmcoreinfo_init);
 
 /*
  * Move into place and start executing a preloaded standalone
diff --git a/mm/cleancache.c b/mm/cleancache.c
index 32e6f41..8fe447f 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -217,4 +217,4 @@ static int __init init_cleancache(void)
 #endif
 	return 0;
 }
-module_init(init_cleancache)
+module_init(init_cleancache);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 57c4b93..0df9de5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -577,7 +577,7 @@ out:
 	hugepage_exit_sysfs(hugepage_kobj);
 	return err;
 }
-module_init(hugepage_init)
+module_init(hugepage_init);
 
 static int __init setup_transparent_hugepage(char *str)
 {
diff --git a/mm/ksm.c b/mm/ksm.c
index 47c8853..b0b2f50 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2031,4 +2031,4 @@ out_free:
 out:
 	return err;
 }
-module_init(ksm_init)
+module_init(ksm_init);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6092f33..25cfe92 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5184,7 +5184,7 @@ int __meminit init_per_zone_wmark_min(void)
 	setup_per_zone_inactive_ratio();
 	return 0;
 }
-module_init(init_per_zone_wmark_min)
+module_init(init_per_zone_wmark_min);
 
 /*
  * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index eeb3bc9..b14e50a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2976,7 +2976,7 @@ static int __init kswapd_init(void)
 	return 0;
 }
 
-module_init(kswapd_init)
+module_init(kswapd_init);
 
 #ifdef CONFIG_NUMA
 /*
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 1bbbbd9..a289e92 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1218,7 +1218,7 @@ static int __init setup_vmstat(void)
 #endif
 	return 0;
 }
-module_init(setup_vmstat)
+module_init(setup_vmstat);
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_COMPACTION)
 #include <linux/debugfs.h>
diff --git a/net/9p/mod.c b/net/9p/mod.c
index 6ab36ae..24361a7 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -192,8 +192,8 @@ static void __exit exit_p9(void)
 	p9_trans_fd_exit();
 }
 
-module_init(init_p9)
-module_exit(exit_p9)
+module_init(init_p9);
+module_exit(exit_p9);
 
 MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
 MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
diff --git a/net/bridge/br.c b/net/bridge/br.c
index ba780cc..b116931 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -100,8 +100,8 @@ static void __exit br_deinit(void)
 	br_fdb_fini();
 }
 
-module_init(br_init)
-module_exit(br_deinit)
+module_init(br_init);
+module_exit(br_deinit);
 MODULE_LICENSE("GPL");
 MODULE_VERSION(BR_VERSION);
 MODULE_ALIAS_RTNL_LINK("bridge");
diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index d9507dd..336562f 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -300,6 +300,6 @@ static void __exit exit_dns_resolver(void)
 	put_cred(dns_resolver_cache);
 }
 
-module_init(init_dns_resolver)
-module_exit(exit_dns_resolver)
+module_init(init_dns_resolver);
+module_exit(exit_dns_resolver);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index 590960a..0620a17 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -301,7 +301,7 @@ static void __exit exit_basic(void)
 	unregister_tcf_proto_ops(&cls_basic_ops);
 }
 
-module_init(init_basic)
-module_exit(exit_basic)
+module_init(init_basic);
+module_exit(exit_basic);
 MODULE_LICENSE("GPL");
 
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index 8384a47..7526024 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -397,6 +397,6 @@ static void __exit exit_fw(void)
 	unregister_tcf_proto_ops(&cls_fw_ops);
 }
 
-module_init(init_fw)
-module_exit(exit_fw)
+module_init(init_fw);
+module_exit(exit_fw);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 36fec42..b4f945f 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -626,6 +626,6 @@ static void __exit exit_route4(void)
 	unregister_tcf_proto_ops(&cls_route4_ops);
 }
 
-module_init(init_route4)
-module_exit(exit_route4)
+module_init(init_route4);
+module_exit(exit_route4);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index 18ab93e..8a88b69 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -670,5 +670,5 @@ static void __exit exit_rsvp(void)
 	unregister_tcf_proto_ops(&RSVP_OPS);
 }
 
-module_init(init_rsvp)
-module_exit(exit_rsvp)
+module_init(init_rsvp);
+module_exit(exit_rsvp);
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index fe29420..b121f54 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -504,6 +504,6 @@ static void __exit exit_tcindex(void)
 	unregister_tcf_proto_ops(&cls_tcindex_ops);
 }
 
-module_init(init_tcindex)
-module_exit(exit_tcindex)
+module_init(init_tcindex);
+module_exit(exit_tcindex);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index d45373f..30134e0 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -819,6 +819,6 @@ static void __exit exit_u32(void)
 	unregister_tcf_proto_ops(&cls_u32_ops);
 }
 
-module_init(init_u32)
-module_exit(exit_u32)
+module_init(init_u32);
+module_exit(exit_u32);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index ca8e0a5..1360fed 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -689,6 +689,6 @@ static void __exit atm_exit(void)
 	unregister_qdisc(&atm_qdisc_ops);
 }
 
-module_init(atm_init)
-module_exit(atm_exit)
+module_init(atm_init);
+module_exit(atm_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_blackhole.c b/net/sched/sch_blackhole.c
index 094a874..dcc1636 100644
--- a/net/sched/sch_blackhole.c
+++ b/net/sched/sch_blackhole.c
@@ -47,7 +47,7 @@ static void __exit blackhole_module_exit(void)
 	unregister_qdisc(&blackhole_qdisc_ops);
 }
 
-module_init(blackhole_module_init)
-module_exit(blackhole_module_exit)
+module_init(blackhole_module_init);
+module_exit(blackhole_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 6aabd77..bc82cb7 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -2076,6 +2076,6 @@ static void __exit cbq_module_exit(void)
 {
 	unregister_qdisc(&cbq_qdisc_ops);
 }
-module_init(cbq_module_init)
-module_exit(cbq_module_exit)
+module_init(cbq_module_init);
+module_exit(cbq_module_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index cc37dd5..2937ab8 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -637,7 +637,7 @@ static void __exit choke_module_exit(void)
 	unregister_qdisc(&choke_qdisc_ops);
 }
 
-module_init(choke_module_init)
-module_exit(choke_module_exit)
+module_init(choke_module_init);
+module_exit(choke_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 2f9ab17..0927c3e 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -267,8 +267,8 @@ static void __exit codel_module_exit(void)
 	unregister_qdisc(&codel_qdisc_ops);
 }
 
-module_init(codel_module_init)
-module_exit(codel_module_exit)
+module_init(codel_module_init);
+module_exit(codel_module_exit);
 
 MODULE_DESCRIPTION("Controlled Delay queue discipline");
 MODULE_AUTHOR("Dave Taht");
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 3886365..111eb4e 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -506,7 +506,7 @@ static void __exit dsmark_module_exit(void)
 	unregister_qdisc(&dsmark_qdisc_ops);
 }
 
-module_init(dsmark_module_init)
-module_exit(dsmark_module_exit)
+module_init(dsmark_module_init);
+module_exit(dsmark_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 9fc1c62..1f15599 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -620,7 +620,7 @@ static void __exit fq_codel_module_exit(void)
 	unregister_qdisc(&fq_codel_qdisc_ops);
 }
 
-module_init(fq_codel_module_init)
-module_exit(fq_codel_module_exit)
+module_init(fq_codel_module_init);
+module_exit(fq_codel_module_exit);
 MODULE_AUTHOR("Eric Dumazet");
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index e901583..e2b6ea7 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -618,7 +618,7 @@ static void __exit gred_module_exit(void)
 	unregister_qdisc(&gred_qdisc_ops);
 }
 
-module_init(gred_module_init)
-module_exit(gred_module_exit)
+module_init(gred_module_init);
+module_exit(gred_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 9d75b77..1e79608 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1582,6 +1582,6 @@ static void __exit htb_module_exit(void)
 	unregister_qdisc(&htb_qdisc_ops);
 }
 
-module_init(htb_module_init)
-module_exit(htb_module_exit)
+module_init(htb_module_init);
+module_exit(htb_module_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index bce1665..dc70518 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -138,6 +138,6 @@ static void __exit ingress_module_exit(void)
 	unregister_qdisc(&ingress_qdisc_ops);
 }
 
-module_init(ingress_module_init)
-module_exit(ingress_module_exit)
+module_init(ingress_module_init);
+module_exit(ingress_module_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index 2a2b096..b27414a 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -438,7 +438,7 @@ static void __exit multiq_module_exit(void)
 	unregister_qdisc(&multiq_qdisc_ops);
 }
 
-module_init(multiq_module_init)
-module_exit(multiq_module_exit)
+module_init(multiq_module_init);
+module_exit(multiq_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index a2a95aa..dbd3535 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -1015,6 +1015,6 @@ static void __exit netem_module_exit(void)
 {
 	unregister_qdisc(&netem_qdisc_ops);
 }
-module_init(netem_module_init)
-module_exit(netem_module_exit)
+module_init(netem_module_init);
+module_exit(netem_module_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_plug.c b/net/sched/sch_plug.c
index 89f8fcf..b5d309f 100644
--- a/net/sched/sch_plug.c
+++ b/net/sched/sch_plug.c
@@ -228,6 +228,6 @@ static void __exit plug_module_exit(void)
 {
 	unregister_qdisc(&plug_qdisc_ops);
 }
-module_init(plug_module_init)
-module_exit(plug_module_exit)
+module_init(plug_module_init);
+module_exit(plug_module_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 79359b6..7e549de 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -400,7 +400,7 @@ static void __exit prio_module_exit(void)
 	unregister_qdisc(&prio_qdisc_ops);
 }
 
-module_init(prio_module_init)
-module_exit(prio_module_exit)
+module_init(prio_module_init);
+module_exit(prio_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 633e32d..6e58e4d 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -385,7 +385,7 @@ static void __exit red_module_exit(void)
 	unregister_qdisc(&red_qdisc_ops);
 }
 
-module_init(red_module_init)
-module_exit(red_module_exit)
+module_init(red_module_init);
+module_exit(red_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 74305c8..783d27a 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -714,8 +714,8 @@ static void __exit sfb_module_exit(void)
 	unregister_qdisc(&sfb_qdisc_ops);
 }
 
-module_init(sfb_module_init)
-module_exit(sfb_module_exit)
+module_init(sfb_module_init);
+module_exit(sfb_module_exit);
 
 MODULE_DESCRIPTION("Stochastic Fair Blue queue discipline");
 MODULE_AUTHOR("Juliusz Chroboczek");
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index d3a1bc2..f015f237 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -938,6 +938,6 @@ static void __exit sfq_module_exit(void)
 {
 	unregister_qdisc(&sfq_qdisc_ops);
 }
-module_init(sfq_module_init)
-module_exit(sfq_module_exit)
+module_init(sfq_module_init);
+module_exit(sfq_module_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 4b056c15..2ae3ae8 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -461,6 +461,6 @@ static void __exit tbf_module_exit(void)
 {
 	unregister_qdisc(&tbf_qdisc_ops);
 }
-module_init(tbf_module_init)
-module_exit(tbf_module_exit)
+module_init(tbf_module_init);
+module_exit(tbf_module_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index d3ad81f..094eb73 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1718,5 +1718,5 @@ module_param_named(expired_cred_retry_delay,
 MODULE_PARM_DESC(expired_cred_retry_delay, "Timeout (in seconds) until "
 		"the RPC engine retries an expired credential");
 
-module_init(init_rpcsec_gss)
-module_exit(exit_rpcsec_gss)
+module_init(init_rpcsec_gss);
+module_exit(exit_rpcsec_gss);
diff --git a/samples/kprobes/jprobe_example.c b/samples/kprobes/jprobe_example.c
index b754135..40c2ec9 100644
--- a/samples/kprobes/jprobe_example.c
+++ b/samples/kprobes/jprobe_example.c
@@ -63,6 +63,6 @@ static void __exit jprobe_exit(void)
 	printk(KERN_INFO "jprobe at %p unregistered\n", my_jprobe.kp.addr);
 }
 
-module_init(jprobe_init)
-module_exit(jprobe_exit)
+module_init(jprobe_init);
+module_exit(jprobe_exit);
 MODULE_LICENSE("GPL");
diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
index ebf5e0c..16dd81f 100644
--- a/samples/kprobes/kprobe_example.c
+++ b/samples/kprobes/kprobe_example.c
@@ -95,6 +95,6 @@ static void __exit kprobe_exit(void)
 	printk(KERN_INFO "kprobe at %p unregistered\n", kp.addr);
 }
 
-module_init(kprobe_init)
-module_exit(kprobe_exit)
+module_init(kprobe_init);
+module_exit(kprobe_exit);
 MODULE_LICENSE("GPL");
diff --git a/samples/kprobes/kretprobe_example.c b/samples/kprobes/kretprobe_example.c
index 1041b67..f57ebf1 100644
--- a/samples/kprobes/kretprobe_example.c
+++ b/samples/kprobes/kretprobe_example.c
@@ -102,6 +102,6 @@ static void __exit kretprobe_exit(void)
 		my_kretprobe.nmissed, my_kretprobe.kp.symbol_name);
 }
 
-module_init(kretprobe_init)
-module_exit(kretprobe_exit)
+module_init(kretprobe_init);
+module_exit(kretprobe_exit);
 MODULE_LICENSE("GPL");
diff --git a/samples/tracepoints/tracepoint-sample.c b/samples/tracepoints/tracepoint-sample.c
index f4d89e0..d43db65 100644
--- a/samples/tracepoints/tracepoint-sample.c
+++ b/samples/tracepoints/tracepoint-sample.c
@@ -49,8 +49,8 @@ static void __exit sample_exit(void)
 	remove_proc_entry("tracepoint-sample", NULL);
 }
 
-module_init(sample_init)
-module_exit(sample_exit)
+module_init(sample_init);
+module_exit(sample_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mathieu Desnoyers");
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 75ea16f..0e6f705 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -531,7 +531,7 @@ static void __exit alsa_hwdep_exit(void)
 	snd_hwdep_proc_done();
 }
 
-module_init(alsa_hwdep_init)
-module_exit(alsa_hwdep_exit)
+module_init(alsa_hwdep_init);
+module_exit(alsa_hwdep_exit);
 
 EXPORT_SYMBOL(snd_hwdep_new);
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 6915692..1ae8f4d 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -529,8 +529,8 @@ static void __exit snd_mem_exit(void)
 }
 
 
-module_init(snd_mem_init)
-module_exit(snd_mem_exit)
+module_init(snd_mem_init);
+module_exit(snd_mem_exit);
 
 
 /*
diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index 18297f7..e9fd8e4 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -1409,7 +1409,7 @@ static void __exit alsa_mixer_oss_exit(void)
 	}
 }
 
-module_init(alsa_mixer_oss_init)
-module_exit(alsa_mixer_oss_exit)
+module_init(alsa_mixer_oss_init);
+module_exit(alsa_mixer_oss_exit);
 
 EXPORT_SYMBOL(snd_mixer_oss_ioctl_card);
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 08fde00..28a6d47 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -3106,5 +3106,5 @@ static void __exit alsa_pcm_oss_exit(void)
 	snd_pcm_notify(&snd_pcm_oss_notify, 1);
 }
 
-module_init(alsa_pcm_oss_init)
-module_exit(alsa_pcm_oss_exit)
+module_init(alsa_pcm_oss_init);
+module_exit(alsa_pcm_oss_exit);
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 1a3070b..9e3c67c 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1207,5 +1207,5 @@ static void __exit alsa_pcm_exit(void)
 	snd_pcm_proc_done();
 }
 
-module_init(alsa_pcm_init)
-module_exit(alsa_pcm_exit)
+module_init(alsa_pcm_init);
+module_exit(alsa_pcm_exit);
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index ebf6e49..a041915 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -1680,8 +1680,8 @@ static void __exit alsa_rawmidi_exit(void)
 	snd_ctl_unregister_ioctl_compat(snd_rawmidi_control_ioctl);
 }
 
-module_init(alsa_rawmidi_init)
-module_exit(alsa_rawmidi_exit)
+module_init(alsa_rawmidi_init);
+module_exit(alsa_rawmidi_exit);
 
 EXPORT_SYMBOL(snd_rawmidi_output_params);
 EXPORT_SYMBOL(snd_rawmidi_input_params);
diff --git a/sound/core/rtctimer.c b/sound/core/rtctimer.c
index e85e72b..ec944cc 100644
--- a/sound/core/rtctimer.c
+++ b/sound/core/rtctimer.c
@@ -175,8 +175,8 @@ static void __exit rtctimer_exit(void)
 /*
  * exported stuff
  */
-module_init(rtctimer_init)
-module_exit(rtctimer_exit)
+module_init(rtctimer_init);
+module_exit(rtctimer_exit);
 
 module_param(rtctimer_freq, int, 0444);
 MODULE_PARM_DESC(rtctimer_freq, "timer frequency in Hz");
diff --git a/sound/core/seq/oss/seq_oss.c b/sound/core/seq/oss/seq_oss.c
index 8d4d5e8..48e0a18 100644
--- a/sound/core/seq/oss/seq_oss.c
+++ b/sound/core/seq/oss/seq_oss.c
@@ -116,8 +116,8 @@ static void __exit alsa_seq_oss_exit(void)
 	unregister_device();
 }
 
-module_init(alsa_seq_oss_init)
-module_exit(alsa_seq_oss_exit)
+module_init(alsa_seq_oss_init);
+module_exit(alsa_seq_oss_exit);
 
 /*
  * ALSA minor device interface
diff --git a/sound/core/seq/seq.c b/sound/core/seq/seq.c
index 7121105..5482bf2 100644
--- a/sound/core/seq/seq.c
+++ b/sound/core/seq/seq.c
@@ -133,5 +133,5 @@ static void __exit alsa_seq_exit(void)
 	snd_sequencer_memory_done();
 }
 
-module_init(alsa_seq_init)
-module_exit(alsa_seq_exit)
+module_init(alsa_seq_init);
+module_exit(alsa_seq_exit);
diff --git a/sound/core/seq/seq_device.c b/sound/core/seq/seq_device.c
index 5cf8d65..4134c59 100644
--- a/sound/core/seq/seq_device.c
+++ b/sound/core/seq/seq_device.c
@@ -562,8 +562,8 @@ static void __exit alsa_seq_device_exit(void)
 		snd_printk(KERN_ERR "drivers not released (%d)\n", num_ops);
 }
 
-module_init(alsa_seq_device_init)
-module_exit(alsa_seq_device_exit)
+module_init(alsa_seq_device_init);
+module_exit(alsa_seq_device_exit);
 
 EXPORT_SYMBOL(snd_seq_device_load_drivers);
 EXPORT_SYMBOL(snd_seq_device_new);
diff --git a/sound/core/seq/seq_dummy.c b/sound/core/seq/seq_dummy.c
index dbc5507..37aadd5 100644
--- a/sound/core/seq/seq_dummy.c
+++ b/sound/core/seq/seq_dummy.c
@@ -257,5 +257,5 @@ static void __exit alsa_seq_dummy_exit(void)
 	delete_client();
 }
 
-module_init(alsa_seq_dummy_init)
-module_exit(alsa_seq_dummy_exit)
+module_init(alsa_seq_dummy_init);
+module_exit(alsa_seq_dummy_exit);
diff --git a/sound/core/seq/seq_midi.c b/sound/core/seq/seq_midi.c
index 64069db..dca4877 100644
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -477,5 +477,5 @@ static void __exit alsa_seq_midi_exit(void)
 	snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_MIDISYNTH);
 }
 
-module_init(alsa_seq_midi_init)
-module_exit(alsa_seq_midi_exit)
+module_init(alsa_seq_midi_init);
+module_exit(alsa_seq_midi_exit);
diff --git a/sound/core/seq/seq_midi_emul.c b/sound/core/seq/seq_midi_emul.c
index 6f64471..4b814e6 100644
--- a/sound/core/seq/seq_midi_emul.c
+++ b/sound/core/seq/seq_midi_emul.c
@@ -731,8 +731,8 @@ static void __exit alsa_seq_midi_emul_exit(void)
 {
 }
 
-module_init(alsa_seq_midi_emul_init)
-module_exit(alsa_seq_midi_emul_exit)
+module_init(alsa_seq_midi_emul_init);
+module_exit(alsa_seq_midi_emul_exit);
 
 EXPORT_SYMBOL(snd_midi_process_event);
 EXPORT_SYMBOL(snd_midi_channel_set_clear);
diff --git a/sound/core/seq/seq_midi_event.c b/sound/core/seq/seq_midi_event.c
index 37db7ba..f745d57 100644
--- a/sound/core/seq/seq_midi_event.c
+++ b/sound/core/seq/seq_midi_event.c
@@ -546,5 +546,5 @@ static void __exit alsa_seq_midi_event_exit(void)
 {
 }
 
-module_init(alsa_seq_midi_event_init)
-module_exit(alsa_seq_midi_event_exit)
+module_init(alsa_seq_midi_event_init);
+module_exit(alsa_seq_midi_event_exit);
diff --git a/sound/core/seq/seq_virmidi.c b/sound/core/seq/seq_virmidi.c
index 4b50e60..da79bd6 100644
--- a/sound/core/seq/seq_virmidi.c
+++ b/sound/core/seq/seq_virmidi.c
@@ -537,7 +537,7 @@ static void __exit alsa_virmidi_exit(void)
 {
 }
 
-module_init(alsa_virmidi_init)
-module_exit(alsa_virmidi_exit)
+module_init(alsa_virmidi_init);
+module_exit(alsa_virmidi_exit);
 
 EXPORT_SYMBOL(snd_virmidi_new);
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 6ddcf06..9af929f 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1981,8 +1981,8 @@ static void __exit alsa_timer_exit(void)
 #endif
 }
 
-module_init(alsa_timer_init)
-module_exit(alsa_timer_exit)
+module_init(alsa_timer_init);
+module_exit(alsa_timer_exit);
 
 EXPORT_SYMBOL(snd_timer_open);
 EXPORT_SYMBOL(snd_timer_close);
diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 8b5c36f..c7e2d19 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1262,5 +1262,5 @@ static void __exit alsa_card_loopback_exit(void)
 	loopback_unregister_all();
 }
 
-module_init(alsa_card_loopback_init)
-module_exit(alsa_card_loopback_exit)
+module_init(alsa_card_loopback_init);
+module_exit(alsa_card_loopback_exit);
diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index ad9434f..3c99b83 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -1153,5 +1153,5 @@ static void __exit alsa_card_dummy_exit(void)
 	snd_dummy_unregister_all();
 }
 
-module_init(alsa_card_dummy_init)
-module_exit(alsa_card_dummy_exit)
+module_init(alsa_card_dummy_init);
+module_exit(alsa_card_dummy_exit);
diff --git a/sound/drivers/mpu401/mpu401.c b/sound/drivers/mpu401/mpu401.c
index 86f5fbc..31fbee1 100644
--- a/sound/drivers/mpu401/mpu401.c
+++ b/sound/drivers/mpu401/mpu401.c
@@ -284,5 +284,5 @@ static void __exit alsa_card_mpu401_exit(void)
 	snd_mpu401_unregister_all();
 }
 
-module_init(alsa_card_mpu401_init)
-module_exit(alsa_card_mpu401_exit)
+module_init(alsa_card_mpu401_init);
+module_exit(alsa_card_mpu401_exit);
diff --git a/sound/drivers/mpu401/mpu401_uart.c b/sound/drivers/mpu401/mpu401_uart.c
index 1cff331..30b2ae3 100644
--- a/sound/drivers/mpu401/mpu401_uart.c
+++ b/sound/drivers/mpu401/mpu401_uart.c
@@ -628,5 +628,5 @@ static void __exit alsa_mpu401_uart_exit(void)
 {
 }
 
-module_init(alsa_mpu401_uart_init)
-module_exit(alsa_mpu401_uart_exit)
+module_init(alsa_mpu401_uart_init);
+module_exit(alsa_mpu401_uart_exit);
diff --git a/sound/drivers/mtpav.c b/sound/drivers/mtpav.c
index 7693079..46d9e93 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -788,5 +788,5 @@ static void __exit alsa_card_mtpav_exit(void)
 	platform_driver_unregister(&snd_mtpav_driver);
 }
 
-module_init(alsa_card_mtpav_init)
-module_exit(alsa_card_mtpav_exit)
+module_init(alsa_card_mtpav_init);
+module_exit(alsa_card_mtpav_exit);
diff --git a/sound/drivers/opl3/opl3_lib.c b/sound/drivers/opl3/opl3_lib.c
index 33d9a85..fbd3cc2 100644
--- a/sound/drivers/opl3/opl3_lib.c
+++ b/sound/drivers/opl3/opl3_lib.c
@@ -557,5 +557,5 @@ static void __exit alsa_opl3_exit(void)
 {
 }
 
-module_init(alsa_opl3_init)
-module_exit(alsa_opl3_exit)
+module_init(alsa_opl3_init);
+module_exit(alsa_opl3_exit);
diff --git a/sound/drivers/opl3/opl3_seq.c b/sound/drivers/opl3/opl3_seq.c
index 6839953..1072ddb 100644
--- a/sound/drivers/opl3/opl3_seq.c
+++ b/sound/drivers/opl3/opl3_seq.c
@@ -294,5 +294,5 @@ static void __exit alsa_opl3_seq_exit(void)
 	snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_OPL3);
 }
 
-module_init(alsa_opl3_seq_init)
-module_exit(alsa_opl3_seq_exit)
+module_init(alsa_opl3_seq_init);
+module_exit(alsa_opl3_seq_exit);
diff --git a/sound/drivers/opl4/opl4_lib.c b/sound/drivers/opl4/opl4_lib.c
index b953fb4..c7eeeeb 100644
--- a/sound/drivers/opl4/opl4_lib.c
+++ b/sound/drivers/opl4/opl4_lib.c
@@ -277,5 +277,5 @@ static void __exit alsa_opl4_exit(void)
 {
 }
 
-module_init(alsa_opl4_init)
-module_exit(alsa_opl4_exit)
+module_init(alsa_opl4_init);
+module_exit(alsa_opl4_exit);
diff --git a/sound/drivers/opl4/opl4_seq.c b/sound/drivers/opl4/opl4_seq.c
index 9919769..0df10e1 100644
--- a/sound/drivers/opl4/opl4_seq.c
+++ b/sound/drivers/opl4/opl4_seq.c
@@ -211,5 +211,5 @@ static void __exit alsa_opl4_synth_exit(void)
 	snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_OPL4);
 }
 
-module_init(alsa_opl4_synth_init)
-module_exit(alsa_opl4_synth_exit)
+module_init(alsa_opl4_synth_init);
+module_exit(alsa_opl4_synth_exit);
diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
index b2d0e8e..c539d3e 100644
--- a/sound/drivers/serial-u16550.c
+++ b/sound/drivers/serial-u16550.c
@@ -1046,5 +1046,5 @@ static void __exit alsa_card_serial_exit(void)
 	snd_serial_unregister_all();
 }
 
-module_init(alsa_card_serial_init)
-module_exit(alsa_card_serial_exit)
+module_init(alsa_card_serial_init);
+module_exit(alsa_card_serial_exit);
diff --git a/sound/drivers/virmidi.c b/sound/drivers/virmidi.c
index 9d97478..45eb5ee 100644
--- a/sound/drivers/virmidi.c
+++ b/sound/drivers/virmidi.c
@@ -193,5 +193,5 @@ static void __exit alsa_card_virmidi_exit(void)
 	snd_virmidi_unregister_all();
 }
 
-module_init(alsa_card_virmidi_init)
-module_exit(alsa_card_virmidi_exit)
+module_init(alsa_card_virmidi_init);
+module_exit(alsa_card_virmidi_exit);
diff --git a/sound/drivers/vx/vx_core.c b/sound/drivers/vx/vx_core.c
index b8e5159..02a6f8d 100644
--- a/sound/drivers/vx/vx_core.c
+++ b/sound/drivers/vx/vx_core.c
@@ -824,5 +824,5 @@ static void __exit alsa_vx_core_exit(void)
 {
 }
 
-module_init(alsa_vx_core_init)
-module_exit(alsa_vx_core_exit)
+module_init(alsa_vx_core_init);
+module_exit(alsa_vx_core_exit);
diff --git a/sound/i2c/cs8427.c b/sound/i2c/cs8427.c
index 6c2dc38..13335fc 100644
--- a/sound/i2c/cs8427.c
+++ b/sound/i2c/cs8427.c
@@ -612,5 +612,5 @@ static void __exit alsa_cs8427_module_exit(void)
 {
 }
 
-module_init(alsa_cs8427_module_init)
-module_exit(alsa_cs8427_module_exit)
+module_init(alsa_cs8427_module_init);
+module_exit(alsa_cs8427_module_exit);
diff --git a/sound/i2c/i2c.c b/sound/i2c/i2c.c
index 4677037..0366fd2 100644
--- a/sound/i2c/i2c.c
+++ b/sound/i2c/i2c.c
@@ -349,5 +349,5 @@ static void __exit alsa_i2c_exit(void)
 {
 }
 
-module_init(alsa_i2c_init)
-module_exit(alsa_i2c_exit)
+module_init(alsa_i2c_init);
+module_exit(alsa_i2c_exit);
diff --git a/sound/i2c/other/ak4xxx-adda.c b/sound/i2c/other/ak4xxx-adda.c
index cef813d..2c218b1 100644
--- a/sound/i2c/other/ak4xxx-adda.c
+++ b/sound/i2c/other/ak4xxx-adda.c
@@ -941,5 +941,5 @@ static void __exit alsa_akm4xxx_module_exit(void)
 {
 }
         
-module_init(alsa_akm4xxx_module_init)
-module_exit(alsa_akm4xxx_module_exit)
+module_init(alsa_akm4xxx_module_init);
+module_exit(alsa_akm4xxx_module_exit);
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index 582aace..45badfe 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -423,8 +423,8 @@ static void __exit alsa_tea575x_module_exit(void)
 {
 }
 
-module_init(alsa_tea575x_module_init)
-module_exit(alsa_tea575x_module_exit)
+module_init(alsa_tea575x_module_init);
+module_exit(alsa_tea575x_module_exit);
 
 EXPORT_SYMBOL(snd_tea575x_init);
 EXPORT_SYMBOL(snd_tea575x_exit);
diff --git a/sound/i2c/tea6330t.c b/sound/i2c/tea6330t.c
index 2d22310..0b79822 100644
--- a/sound/i2c/tea6330t.c
+++ b/sound/i2c/tea6330t.c
@@ -382,5 +382,5 @@ static void __exit alsa_tea6330t_exit(void)
 {
 }
 
-module_init(alsa_tea6330t_init)
-module_exit(alsa_tea6330t_exit)
+module_init(alsa_tea6330t_init);
+module_exit(alsa_tea6330t_exit);
diff --git a/sound/isa/ad1816a/ad1816a.c b/sound/isa/ad1816a/ad1816a.c
index 94b83b6..bb509f0 100644
--- a/sound/isa/ad1816a/ad1816a.c
+++ b/sound/isa/ad1816a/ad1816a.c
@@ -290,5 +290,5 @@ static void __exit alsa_card_ad1816a_exit(void)
 	pnp_unregister_card_driver(&ad1816a_pnpc_driver);
 }
 
-module_init(alsa_card_ad1816a_init)
-module_exit(alsa_card_ad1816a_exit)
+module_init(alsa_card_ad1816a_init);
+module_exit(alsa_card_ad1816a_exit);
diff --git a/sound/isa/als100.c b/sound/isa/als100.c
index 2d67c78..776f8fa 100644
--- a/sound/isa/als100.c
+++ b/sound/isa/als100.c
@@ -374,5 +374,5 @@ static void __exit alsa_card_als100_exit(void)
 	pnp_unregister_card_driver(&als100_pnpc_driver);
 }
 
-module_init(alsa_card_als100_init)
-module_exit(alsa_card_als100_exit)
+module_init(alsa_card_als100_init);
+module_exit(alsa_card_als100_exit);
diff --git a/sound/isa/azt2320.c b/sound/isa/azt2320.c
index 6a2c78e..e742b6c 100644
--- a/sound/isa/azt2320.c
+++ b/sound/isa/azt2320.c
@@ -350,5 +350,5 @@ static void __exit alsa_card_azt2320_exit(void)
 	pnp_unregister_card_driver(&azt2320_pnpc_driver);
 }
 
-module_init(alsa_card_azt2320_init)
-module_exit(alsa_card_azt2320_exit)
+module_init(alsa_card_azt2320_init);
+module_exit(alsa_card_azt2320_exit);
diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index 7bd5e33..f9095ca 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -778,5 +778,5 @@ static void __exit alsa_card_cmi8330_exit(void)
 		isa_unregister_driver(&snd_cmi8330_driver);
 }
 
-module_init(alsa_card_cmi8330_init)
-module_exit(alsa_card_cmi8330_exit)
+module_init(alsa_card_cmi8330_init);
+module_exit(alsa_card_cmi8330_exit);
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index 740c51a..a824b28 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -724,5 +724,5 @@ static void __exit alsa_card_cs423x_exit(void)
 		isa_unregister_driver(&cs423x_isa_driver);
 }
 
-module_init(alsa_card_cs423x_init)
-module_exit(alsa_card_cs423x_exit)
+module_init(alsa_card_cs423x_init);
+module_exit(alsa_card_cs423x_exit);
diff --git a/sound/isa/es1688/es1688_lib.c b/sound/isa/es1688/es1688_lib.c
index 1d47be8..7a20d7b 100644
--- a/sound/isa/es1688/es1688_lib.c
+++ b/sound/isa/es1688/es1688_lib.c
@@ -1042,5 +1042,5 @@ static void __exit alsa_es1688_exit(void)
 {
 }
 
-module_init(alsa_es1688_init)
-module_exit(alsa_es1688_exit)
+module_init(alsa_es1688_init);
+module_exit(alsa_es1688_exit);
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index c20baaf..dee75a9f 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -2430,5 +2430,5 @@ static void __exit alsa_card_es18xx_exit(void)
 		isa_unregister_driver(&snd_es18xx_isa_driver);
 }
 
-module_init(alsa_card_es18xx_init)
-module_exit(alsa_card_es18xx_exit)
+module_init(alsa_card_es18xx_init);
+module_exit(alsa_card_es18xx_exit);
diff --git a/sound/isa/gus/gus_main.c b/sound/isa/gus/gus_main.c
index 4490ee4..eea66d6 100644
--- a/sound/isa/gus/gus_main.c
+++ b/sound/isa/gus/gus_main.c
@@ -479,5 +479,5 @@ static void __exit alsa_gus_exit(void)
 {
 }
 
-module_init(alsa_gus_init)
-module_exit(alsa_gus_exit)
+module_init(alsa_gus_init);
+module_exit(alsa_gus_exit);
diff --git a/sound/isa/gus/gusmax.c b/sound/isa/gus/gusmax.c
index 41c3f44..312760f 100644
--- a/sound/isa/gus/gusmax.c
+++ b/sound/isa/gus/gusmax.c
@@ -383,5 +383,5 @@ static void __exit alsa_card_gusmax_exit(void)
 	isa_unregister_driver(&snd_gusmax_driver);
 }
 
-module_init(alsa_card_gusmax_init)
-module_exit(alsa_card_gusmax_exit)
+module_init(alsa_card_gusmax_init);
+module_exit(alsa_card_gusmax_exit);
diff --git a/sound/isa/gus/interwave.c b/sound/isa/gus/interwave.c
index a76bc8d..e15c3ab 100644
--- a/sound/isa/gus/interwave.c
+++ b/sound/isa/gus/interwave.c
@@ -943,5 +943,5 @@ static void __exit alsa_card_interwave_exit(void)
 		isa_unregister_driver(&snd_interwave_driver);
 }
 
-module_init(alsa_card_interwave_init)
-module_exit(alsa_card_interwave_exit)
+module_init(alsa_card_interwave_init);
+module_exit(alsa_card_interwave_exit);
diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
index f6cc0b9..f26738a 100644
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -967,5 +967,5 @@ static void __exit alsa_card_opl3sa2_exit(void)
 		isa_unregister_driver(&snd_opl3sa2_isa_driver);
 }
 
-module_init(alsa_card_opl3sa2_init)
-module_exit(alsa_card_opl3sa2_exit)
+module_init(alsa_card_opl3sa2_init);
+module_exit(alsa_card_opl3sa2_exit);
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index c24594c..47febfb 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -1676,5 +1676,5 @@ static void __exit alsa_card_miro_exit(void)
 #endif
 }
 
-module_init(alsa_card_miro_init)
-module_exit(alsa_card_miro_exit)
+module_init(alsa_card_miro_init);
+module_exit(alsa_card_miro_exit);
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index d7ccf28..7201457 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -1161,5 +1161,5 @@ static void __exit alsa_card_opti9xx_exit(void)
 #endif
 }
 
-module_init(alsa_card_opti9xx_init)
-module_exit(alsa_card_opti9xx_exit)
+module_init(alsa_card_opti9xx_init);
+module_exit(alsa_card_opti9xx_exit);
diff --git a/sound/isa/sb/emu8000_synth.c b/sound/isa/sb/emu8000_synth.c
index 4e3fcfb..c8542ab 100644
--- a/sound/isa/sb/emu8000_synth.c
+++ b/sound/isa/sb/emu8000_synth.c
@@ -132,5 +132,5 @@ static void __exit alsa_emu8000_exit(void)
 	snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_EMU8000);
 }
 
-module_init(alsa_emu8000_init)
-module_exit(alsa_emu8000_exit)
+module_init(alsa_emu8000_init);
+module_exit(alsa_emu8000_exit);
diff --git a/sound/isa/sb/jazz16.c b/sound/isa/sb/jazz16.c
index 410758c..dd05f5e 100644
--- a/sound/isa/sb/jazz16.c
+++ b/sound/isa/sb/jazz16.c
@@ -400,5 +400,5 @@ static void __exit alsa_card_jazz16_exit(void)
 	isa_unregister_driver(&snd_jazz16_driver);
 }
 
-module_init(alsa_card_jazz16_init)
-module_exit(alsa_card_jazz16_exit)
+module_init(alsa_card_jazz16_init);
+module_exit(alsa_card_jazz16_exit);
diff --git a/sound/isa/sb/sb16.c b/sound/isa/sb/sb16.c
index 39b8eca..fb145d8 100644
--- a/sound/isa/sb/sb16.c
+++ b/sound/isa/sb/sb16.c
@@ -695,5 +695,5 @@ static void __exit alsa_card_sb16_exit(void)
 		isa_unregister_driver(&snd_sb16_isa_driver);
 }
 
-module_init(alsa_card_sb16_init)
-module_exit(alsa_card_sb16_exit)
+module_init(alsa_card_sb16_init);
+module_exit(alsa_card_sb16_exit);
diff --git a/sound/isa/sb/sb16_csp.c b/sound/isa/sb/sb16_csp.c
index c1aa21e..426ffb6 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -1198,5 +1198,5 @@ static void __exit alsa_sb_csp_exit(void)
 {
 }
 
-module_init(alsa_sb_csp_init)
-module_exit(alsa_sb_csp_exit)
+module_init(alsa_sb_csp_init);
+module_exit(alsa_sb_csp_exit);
diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index 0bbcd47..0470812 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -921,5 +921,5 @@ static void __exit alsa_sb16_exit(void)
 {
 }
 
-module_init(alsa_sb16_init)
-module_exit(alsa_sb16_exit)
+module_init(alsa_sb16_init);
+module_exit(alsa_sb16_exit);
diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
index ab5cebe..f361024 100644
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -264,5 +264,5 @@ static void __exit alsa_card_sb8_exit(void)
 	isa_unregister_driver(&snd_sb8_driver);
 }
 
-module_init(alsa_card_sb8_init)
-module_exit(alsa_card_sb8_exit)
+module_init(alsa_card_sb8_init);
+module_exit(alsa_card_sb8_exit);
diff --git a/sound/isa/sb/sb8_main.c b/sound/isa/sb/sb8_main.c
index 24d4121..6ac4468 100644
--- a/sound/isa/sb/sb8_main.c
+++ b/sound/isa/sb/sb8_main.c
@@ -642,5 +642,5 @@ static void __exit alsa_sb8_exit(void)
 {
 }
 
-module_init(alsa_sb8_init)
-module_exit(alsa_sb8_exit)
+module_init(alsa_sb8_init);
+module_exit(alsa_sb8_exit);
diff --git a/sound/isa/sb/sb_common.c b/sound/isa/sb/sb_common.c
index 3ef9906..8f49b28 100644
--- a/sound/isa/sb/sb_common.c
+++ b/sound/isa/sb/sb_common.c
@@ -320,5 +320,5 @@ static void __exit alsa_sb_common_exit(void)
 {
 }
 
-module_init(alsa_sb_common_init)
-module_exit(alsa_sb_common_exit)
+module_init(alsa_sb_common_init);
+module_exit(alsa_sb_common_exit);
diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index d97d0f3..5fa77fb 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -724,5 +724,5 @@ static void __exit alsa_card_sc6000_exit(void)
 	isa_unregister_driver(&snd_sc6000_driver);
 }
 
-module_init(alsa_card_sc6000_init)
-module_exit(alsa_card_sc6000_exit)
+module_init(alsa_card_sc6000_init);
+module_exit(alsa_card_sc6000_exit);
diff --git a/sound/isa/wavefront/wavefront.c b/sound/isa/wavefront/wavefront.c
index e0a7327..6202749 100644
--- a/sound/isa/wavefront/wavefront.c
+++ b/sound/isa/wavefront/wavefront.c
@@ -683,5 +683,5 @@ static void __exit alsa_card_wavefront_exit(void)
 		isa_unregister_driver(&snd_wavefront_driver);
 }
 
-module_init(alsa_card_wavefront_init)
-module_exit(alsa_card_wavefront_exit)
+module_init(alsa_card_wavefront_init);
+module_exit(alsa_card_wavefront_exit);
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 9473fca..ace9235 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -2933,5 +2933,5 @@ static void __exit alsa_ac97_exit(void)
 {
 }
 
-module_init(alsa_ac97_init)
-module_exit(alsa_ac97_exit)
+module_init(alsa_ac97_init);
+module_exit(alsa_ac97_exit);
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index e8de831..c444210 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -2987,6 +2987,6 @@ static void __exit snd_asihpi_exit(void)
 	asihpi_exit();
 }
 
-module_init(snd_asihpi_init)
-module_exit(snd_asihpi_exit)
+module_init(snd_asihpi_init);
+module_exit(snd_asihpi_exit);
 
diff --git a/sound/pci/emu10k1/emu10k1_synth.c b/sound/pci/emu10k1/emu10k1_synth.c
index 4c41c90..d1e9efe 100644
--- a/sound/pci/emu10k1/emu10k1_synth.c
+++ b/sound/pci/emu10k1/emu10k1_synth.c
@@ -120,5 +120,5 @@ static void __exit alsa_emu10k1_synth_exit(void)
 	snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_EMU10K1_SYNTH);
 }
 
-module_init(alsa_emu10k1_synth_init)
-module_exit(alsa_emu10k1_synth_exit)
+module_init(alsa_emu10k1_synth_init);
+module_exit(alsa_emu10k1_synth_exit);
diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index d8b2d6d..716701a 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -5065,5 +5065,5 @@ static void __exit patch_analog_exit(void)
 	snd_hda_delete_codec_preset(&analog_list);
 }
 
-module_init(patch_analog_init)
-module_exit(patch_analog_exit)
+module_init(patch_analog_init);
+module_exit(patch_analog_exit);
diff --git a/sound/pci/hda/patch_ca0110.c b/sound/pci/hda/patch_ca0110.c
index 19ae14f..a25002f 100644
--- a/sound/pci/hda/patch_ca0110.c
+++ b/sound/pci/hda/patch_ca0110.c
@@ -572,5 +572,5 @@ static void __exit patch_ca0110_exit(void)
 	snd_hda_delete_codec_preset(&ca0110_list);
 }
 
-module_init(patch_ca0110_init)
-module_exit(patch_ca0110_exit)
+module_init(patch_ca0110_init);
+module_exit(patch_ca0110_exit);
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index d0d3540..388086c 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1098,5 +1098,5 @@ static void __exit patch_ca0132_exit(void)
 	snd_hda_delete_codec_preset(&ca0132_list);
 }
 
-module_init(patch_ca0132_init)
-module_exit(patch_ca0132_exit)
+module_init(patch_ca0132_init);
+module_exit(patch_ca0132_exit);
diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 9647ed4..e843fd2 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -2039,5 +2039,5 @@ static void __exit patch_cirrus_exit(void)
 	snd_hda_delete_codec_preset(&cirrus_list);
 }
 
-module_init(patch_cirrus_init)
-module_exit(patch_cirrus_exit)
+module_init(patch_cirrus_init);
+module_exit(patch_cirrus_exit);
diff --git a/sound/pci/hda/patch_cmedia.c b/sound/pci/hda/patch_cmedia.c
index c8fdaae..a7caa42 100644
--- a/sound/pci/hda/patch_cmedia.c
+++ b/sound/pci/hda/patch_cmedia.c
@@ -773,5 +773,5 @@ static void __exit patch_cmedia_exit(void)
 	snd_hda_delete_codec_preset(&cmedia_list);
 }
 
-module_init(patch_cmedia_init)
-module_exit(patch_cmedia_exit)
+module_init(patch_cmedia_init);
+module_exit(patch_cmedia_exit);
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 3acb582..e9c8747 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4641,5 +4641,5 @@ static void __exit patch_conexant_exit(void)
 	snd_hda_delete_codec_preset(&conexant_list);
 }
 
-module_init(patch_conexant_init)
-module_exit(patch_conexant_exit)
+module_init(patch_conexant_init);
+module_exit(patch_conexant_exit);
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index ad319d4..1c060dc 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1982,5 +1982,5 @@ static void __exit patch_hdmi_exit(void)
 	snd_hda_delete_codec_preset(&intel_list);
 }
 
-module_init(patch_hdmi_init)
-module_exit(patch_hdmi_exit)
+module_init(patch_hdmi_init);
+module_exit(patch_hdmi_exit);
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 224410e..880129b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6843,5 +6843,5 @@ static void __exit patch_realtek_exit(void)
 	snd_hda_delete_codec_preset(&realtek_list);
 }
 
-module_init(patch_realtek_init)
-module_exit(patch_realtek_exit)
+module_init(patch_realtek_init);
+module_exit(patch_realtek_exit);
diff --git a/sound/pci/hda/patch_si3054.c b/sound/pci/hda/patch_si3054.c
index 6679a50..c2221af 100644
--- a/sound/pci/hda/patch_si3054.c
+++ b/sound/pci/hda/patch_si3054.c
@@ -333,5 +333,5 @@ static void __exit patch_si3054_exit(void)
 	snd_hda_delete_codec_preset(&si3054_list);
 }
 
-module_init(patch_si3054_init)
-module_exit(patch_si3054_exit)
+module_init(patch_si3054_init);
+module_exit(patch_si3054_exit);
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 7db8228..3a89b53 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -6479,5 +6479,5 @@ static void __exit patch_sigmatel_exit(void)
 	snd_hda_delete_codec_preset(&sigmatel_list);
 }
 
-module_init(patch_sigmatel_init)
-module_exit(patch_sigmatel_exit)
+module_init(patch_sigmatel_init);
+module_exit(patch_sigmatel_exit);
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 82b3680..fb426fd 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -3924,5 +3924,5 @@ static void __exit patch_via_exit(void)
 	snd_hda_delete_codec_preset(&via_list);
 }
 
-module_init(patch_via_init)
-module_exit(patch_via_exit)
+module_init(patch_via_init);
+module_exit(patch_via_exit);
diff --git a/sound/pci/ice1712/ak4xxx.c b/sound/pci/ice1712/ak4xxx.c
index 3981823..53142ac 100644
--- a/sound/pci/ice1712/ak4xxx.c
+++ b/sound/pci/ice1712/ak4xxx.c
@@ -188,8 +188,8 @@ static void __exit alsa_ice1712_akm4xxx_module_exit(void)
 {
 }
         
-module_init(alsa_ice1712_akm4xxx_module_init)
-module_exit(alsa_ice1712_akm4xxx_module_exit)
+module_init(alsa_ice1712_akm4xxx_module_init);
+module_exit(alsa_ice1712_akm4xxx_module_exit);
 
 EXPORT_SYMBOL(snd_ice1712_akm4xxx_init);
 EXPORT_SYMBOL(snd_ice1712_akm4xxx_free);
diff --git a/sound/ppc/powermac.c b/sound/ppc/powermac.c
index 5a4e263..27bab50 100644
--- a/sound/ppc/powermac.c
+++ b/sound/ppc/powermac.c
@@ -191,5 +191,5 @@ static void __exit alsa_card_pmac_exit(void)
 	platform_driver_unregister(&snd_pmac_driver);
 }
 
-module_init(alsa_card_pmac_init)
-module_exit(alsa_card_pmac_exit)
+module_init(alsa_card_pmac_init);
+module_exit(alsa_card_pmac_exit);
diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index 9352207..2fdef8f 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -188,5 +188,5 @@ static void __exit alsa_emux_exit(void)
 {
 }
 
-module_init(alsa_emux_init)
-module_exit(alsa_emux_exit)
+module_init(alsa_emux_init);
+module_exit(alsa_emux_exit);
diff --git a/sound/synth/util_mem.c b/sound/synth/util_mem.c
index 8e34bc4..69488ac 100644
--- a/sound/synth/util_mem.c
+++ b/sound/synth/util_mem.c
@@ -207,5 +207,5 @@ static void __exit alsa_util_mem_exit(void)
 {
 }
 
-module_init(alsa_util_mem_init)
-module_exit(alsa_util_mem_exit)
+module_init(alsa_util_mem_init);
+module_exit(alsa_util_mem_exit);
diff --git a/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c b/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
index 66cace6..dd654bb 100644
--- a/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
+++ b/tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
@@ -104,8 +104,8 @@ static void __exit cpufreq_none(void)
 	return;
 }
 
-module_init(cpufreq_test_tsc)
-module_exit(cpufreq_none)
+module_init(cpufreq_test_tsc);
+module_exit(cpufreq_none);
 
 
 MODULE_AUTHOR("Dominik Brodowski");
-- 
1.7.10.3

