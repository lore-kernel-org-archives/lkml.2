Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1EPXlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:41:36 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:55056 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab1EPXlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:41:32 -0400
From: Felipe Balbi <balbi@ti.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [RESEND/PATCH 1/2] trivial: add missing ; at the end of module_init/module_exit
Date: Tue, 17 May 2011 02:41:09 +0300
Message-Id: <1305589270-5389-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
In-Reply-To: <1305589270-5389-1-git-send-email-balbi@ti.com>
References: <1305589270-5389-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the definition of module_init() and module_exit()
already adds the ;, but majority of drivers in
the kernel tree all add ; at the end of module_init()
module_exit().

After preprocessing we would have two semicolons
at a line. In order to avoid that, we add missing
semicolons to all drivers and on a later patch drop
the trailing semicolon from module_init() module_exit()
definitions.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 Documentation/DocBook/writing-an-alsa-driver.tmpl  |    8 ++++----
 arch/arm/plat-omap/iommu-debug.c                   |    4 ++--
 arch/ia64/kvm/vmm.c                                |    4 ++--
 arch/ia64/sn/kernel/mca.c                          |    2 +-
 arch/s390/hypfs/inode.c                            |    4 ++--
 arch/x86/kernel/msr.c                              |    2 +-
 arch/x86/kvm/svm.c                                 |    4 ++--
 arch/x86/kvm/vmx.c                                 |    4 ++--
 drivers/block/ataflop.c                            |    4 ++--
 drivers/block/cpqarray.c                           |    4 ++--
 drivers/block/drbd/drbd_main.c                     |    4 ++--
 drivers/block/floppy.c                             |    2 +-
 drivers/block/paride/aten.c                        |    4 ++--
 drivers/block/paride/bpck.c                        |    4 ++--
 drivers/block/paride/bpck6.c                       |    4 ++--
 drivers/block/paride/comm.c                        |    4 ++--
 drivers/block/paride/dstr.c                        |    4 ++--
 drivers/block/paride/epat.c                        |    4 ++--
 drivers/block/paride/epia.c                        |    4 ++--
 drivers/block/paride/fit2.c                        |    4 ++--
 drivers/block/paride/fit3.c                        |    4 ++--
 drivers/block/paride/friq.c                        |    4 ++--
 drivers/block/paride/frpw.c                        |    4 ++--
 drivers/block/paride/kbic.c                        |    4 ++--
 drivers/block/paride/ktti.c                        |    4 ++--
 drivers/block/paride/on20.c                        |    4 ++--
 drivers/block/paride/on26.c                        |    4 ++--
 drivers/block/paride/pcd.c                         |    4 ++--
 drivers/block/paride/pd.c                          |    4 ++--
 drivers/block/paride/pf.c                          |    4 ++--
 drivers/block/paride/pg.c                          |    4 ++--
 drivers/block/paride/pt.c                          |    4 ++--
 drivers/block/swim3.c                              |    2 +-
 drivers/gpio/bt8xxgpio.c                           |    4 ++--
 drivers/hwmon/adm1021.c                            |    4 ++--
 drivers/hwmon/adt7411.c                            |    4 ++--
 drivers/hwmon/coretemp.c                           |    4 ++--
 drivers/hwmon/k10temp.c                            |    4 ++--
 drivers/hwmon/k8temp.c                             |    4 ++--
 drivers/hwmon/pkgtemp.c                            |    4 ++--
 drivers/hwmon/via-cputemp.c                        |    4 ++--
 drivers/i2c/busses/i2c-amd756.c                    |    4 ++--
 drivers/md/dm-zero.c                               |    4 ++--
 drivers/md/md.c                                    |    2 +-
 drivers/media/media-devnode.c                      |    4 ++--
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |    4 ++--
 drivers/media/rc/keymaps/rc-alink-dtu-m.c          |    4 ++--
 drivers/media/rc/keymaps/rc-anysee.c               |    4 ++--
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        |    4 ++--
 drivers/media/rc/keymaps/rc-asus-pc39.c            |    4 ++--
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |    4 ++--
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c      |    4 ++--
 drivers/media/rc/keymaps/rc-avermedia.c            |    4 ++--
 drivers/media/rc/keymaps/rc-avertv-303.c           |    4 ++--
 drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c   |    4 ++--
 drivers/media/rc/keymaps/rc-behold-columbus.c      |    4 ++--
 drivers/media/rc/keymaps/rc-behold.c               |    4 ++--
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |    4 ++--
 drivers/media/rc/keymaps/rc-cinergy-1400.c         |    4 ++--
 drivers/media/rc/keymaps/rc-cinergy.c              |    4 ++--
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |    4 ++--
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |    4 ++--
 drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c  |    4 ++--
 drivers/media/rc/keymaps/rc-digittrade.c           |    4 ++--
 drivers/media/rc/keymaps/rc-dm1105-nec.c           |    4 ++--
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |    4 ++--
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   |    4 ++--
 drivers/media/rc/keymaps/rc-em-terratec.c          |    4 ++--
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    |    4 ++--
 drivers/media/rc/keymaps/rc-encore-enltv.c         |    4 ++--
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |    4 ++--
 drivers/media/rc/keymaps/rc-evga-indtube.c         |    4 ++--
 drivers/media/rc/keymaps/rc-eztv.c                 |    4 ++--
 drivers/media/rc/keymaps/rc-flydvb.c               |    4 ++--
 drivers/media/rc/keymaps/rc-flyvideo.c             |    4 ++--
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       |    4 ++--
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        |    4 ++--
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   |    4 ++--
 drivers/media/rc/keymaps/rc-gotview7135.c          |    4 ++--
 drivers/media/rc/keymaps/rc-hauppauge.c            |    4 ++--
 drivers/media/rc/keymaps/rc-imon-mce.c             |    4 ++--
 drivers/media/rc/keymaps/rc-imon-pad.c             |    4 ++--
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        |    4 ++--
 drivers/media/rc/keymaps/rc-kaiomy.c               |    4 ++--
 drivers/media/rc/keymaps/rc-kworld-315u.c          |    4 ++--
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |    4 ++--
 drivers/media/rc/keymaps/rc-leadtek-y04g0051.c     |    4 ++--
 drivers/media/rc/keymaps/rc-lirc.c                 |    4 ++--
 drivers/media/rc/keymaps/rc-lme2510.c              |    4 ++--
 drivers/media/rc/keymaps/rc-manli.c                |    4 ++--
 drivers/media/rc/keymaps/rc-msi-digivox-ii.c       |    4 ++--
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c      |    4 ++--
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |    4 ++--
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       |    4 ++--
 drivers/media/rc/keymaps/rc-nebula.c               |    4 ++--
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |    4 ++--
 drivers/media/rc/keymaps/rc-norwood.c              |    4 ++--
 drivers/media/rc/keymaps/rc-npgtech.c              |    4 ++--
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |    4 ++--
 drivers/media/rc/keymaps/rc-pinnacle-color.c       |    4 ++--
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        |    4 ++--
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |    4 ++--
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |    4 ++--
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |    4 ++--
 drivers/media/rc/keymaps/rc-pixelview-new.c        |    4 ++--
 drivers/media/rc/keymaps/rc-pixelview.c            |    4 ++--
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |    4 ++--
 drivers/media/rc/keymaps/rc-proteus-2309.c         |    4 ++--
 drivers/media/rc/keymaps/rc-purpletv.c             |    4 ++--
 drivers/media/rc/keymaps/rc-pv951.c                |    4 ++--
 drivers/media/rc/keymaps/rc-rc6-mce.c              |    4 ++--
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |    4 ++--
 drivers/media/rc/keymaps/rc-streamzap.c            |    4 ++--
 drivers/media/rc/keymaps/rc-tbs-nec.c              |    4 ++--
 drivers/media/rc/keymaps/rc-technisat-usb2.c       |    4 ++--
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  |    4 ++--
 drivers/media/rc/keymaps/rc-terratec-slim-2.c      |    4 ++--
 drivers/media/rc/keymaps/rc-terratec-slim.c        |    4 ++--
 drivers/media/rc/keymaps/rc-tevii-nec.c            |    4 ++--
 drivers/media/rc/keymaps/rc-total-media-in-hand.c  |    4 ++--
 drivers/media/rc/keymaps/rc-trekstor.c             |    4 ++--
 drivers/media/rc/keymaps/rc-tt-1500.c              |    4 ++--
 drivers/media/rc/keymaps/rc-twinhan1027.c          |    4 ++--
 drivers/media/rc/keymaps/rc-videomate-m1f.c        |    4 ++--
 drivers/media/rc/keymaps/rc-videomate-s350.c       |    4 ++--
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     |    4 ++--
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |    4 ++--
 drivers/media/rc/keymaps/rc-winfast.c              |    4 ++--
 drivers/media/video/v4l2-dev.c                     |    4 ++--
 drivers/mfd/htc-egpio.c                            |    2 +-
 drivers/misc/bh1780gli.c                           |    4 ++--
 drivers/net/arcnet/arc-rimi.c                      |    4 ++--
 drivers/net/arcnet/com20020-isa.c                  |    4 ++--
 drivers/net/arcnet/com20020-pci.c                  |    4 ++--
 drivers/net/arcnet/com90io.c                       |    4 ++--
 drivers/net/arm/at91_ether.c                       |    4 ++--
 drivers/net/hp100.c                                |    4 ++--
 drivers/net/tulip/xircom_cb.c                      |    4 ++--
 drivers/net/wireless/b43/main.c                    |    4 ++--
 drivers/net/wireless/b43legacy/main.c              |    4 ++--
 drivers/parisc/led.c                               |    2 +-
 drivers/parport/parport_atari.c                    |    4 ++--
 drivers/parport/parport_ax88796.c                  |    4 ++--
 drivers/parport/parport_mfc3.c                     |    4 ++--
 drivers/parport/parport_pc.c                       |    4 ++--
 drivers/parport/parport_sunbpp.c                   |    4 ++--
 drivers/parport/procfs.c                           |    4 ++--
 drivers/regulator/twl-regulator.c                  |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c                       |    4 ++--
 drivers/ssb/main.c                                 |    2 +-
 drivers/staging/intel_sst/intelmid.c               |    4 ++--
 drivers/staging/rts_pstor/rtsx.c                   |    4 ++--
 drivers/staging/zcache/zcache.c                    |    2 +-
 drivers/uio/uio.c                                  |    4 ++--
 fs/9p/v9fs.c                                       |    4 ++--
 fs/adfs/super.c                                    |    4 ++--
 fs/affs/super.c                                    |    4 ++--
 fs/autofs4/init.c                                  |    2 +-
 fs/befs/linuxvfs.c                                 |    4 ++--
 fs/bfs/inode.c                                     |    4 ++--
 fs/btrfs/super.c                                   |    4 ++--
 fs/cifs/cifsfs.c                                   |    4 ++--
 fs/cramfs/inode.c                                  |    4 ++--
 fs/devpts/inode.c                                  |    2 +-
 fs/ecryptfs/main.c                                 |    4 ++--
 fs/efs/super.c                                     |    4 ++--
 fs/exofs/super.c                                   |    4 ++--
 fs/ext2/super.c                                    |    4 ++--
 fs/ext3/super.c                                    |    4 ++--
 fs/ext4/super.c                                    |    4 ++--
 fs/fat/inode.c                                     |    4 ++--
 fs/fat/namei_msdos.c                               |    4 ++--
 fs/fat/namei_vfat.c                                |    4 ++--
 fs/fcntl.c                                         |    2 +-
 fs/hfs/super.c                                     |    4 ++--
 fs/hfsplus/super.c                                 |    4 ++--
 fs/hostfs/hostfs_kern.c                            |    4 ++--
 fs/hpfs/super.c                                    |    4 ++--
 fs/hppfs/hppfs.c                                   |    4 ++--
 fs/hugetlbfs/inode.c                               |    4 ++--
 fs/isofs/inode.c                                   |    4 ++--
 fs/jfs/super.c                                     |    4 ++--
 fs/mbcache.c                                       |    4 ++--
 fs/minix/inode.c                                   |    4 ++--
 fs/ncpfs/inode.c                                   |    4 ++--
 fs/nfs/inode.c                                     |    4 ++--
 fs/nfsd/nfsctl.c                                   |    4 ++--
 fs/nilfs2/super.c                                  |    4 ++--
 fs/nls/nls_ascii.c                                 |    4 ++--
 fs/nls/nls_cp1250.c                                |    4 ++--
 fs/nls/nls_cp1251.c                                |    4 ++--
 fs/nls/nls_cp1255.c                                |    4 ++--
 fs/nls/nls_cp437.c                                 |    4 ++--
 fs/nls/nls_cp737.c                                 |    4 ++--
 fs/nls/nls_cp775.c                                 |    4 ++--
 fs/nls/nls_cp850.c                                 |    4 ++--
 fs/nls/nls_cp852.c                                 |    4 ++--
 fs/nls/nls_cp855.c                                 |    4 ++--
 fs/nls/nls_cp857.c                                 |    4 ++--
 fs/nls/nls_cp860.c                                 |    4 ++--
 fs/nls/nls_cp861.c                                 |    4 ++--
 fs/nls/nls_cp862.c                                 |    4 ++--
 fs/nls/nls_cp863.c                                 |    4 ++--
 fs/nls/nls_cp864.c                                 |    4 ++--
 fs/nls/nls_cp865.c                                 |    4 ++--
 fs/nls/nls_cp866.c                                 |    4 ++--
 fs/nls/nls_cp869.c                                 |    4 ++--
 fs/nls/nls_cp874.c                                 |    4 ++--
 fs/nls/nls_cp932.c                                 |    4 ++--
 fs/nls/nls_cp936.c                                 |    4 ++--
 fs/nls/nls_cp949.c                                 |    4 ++--
 fs/nls/nls_cp950.c                                 |    4 ++--
 fs/nls/nls_euc-jp.c                                |    4 ++--
 fs/nls/nls_iso8859-1.c                             |    4 ++--
 fs/nls/nls_iso8859-13.c                            |    4 ++--
 fs/nls/nls_iso8859-14.c                            |    4 ++--
 fs/nls/nls_iso8859-15.c                            |    4 ++--
 fs/nls/nls_iso8859-2.c                             |    4 ++--
 fs/nls/nls_iso8859-3.c                             |    4 ++--
 fs/nls/nls_iso8859-4.c                             |    4 ++--
 fs/nls/nls_iso8859-5.c                             |    4 ++--
 fs/nls/nls_iso8859-6.c                             |    4 ++--
 fs/nls/nls_iso8859-7.c                             |    4 ++--
 fs/nls/nls_iso8859-9.c                             |    4 ++--
 fs/nls/nls_koi8-r.c                                |    4 ++--
 fs/nls/nls_koi8-ru.c                               |    4 ++--
 fs/nls/nls_koi8-u.c                                |    4 ++--
 fs/nls/nls_utf8.c                                  |    4 ++--
 fs/notify/dnotify/dnotify.c                        |    2 +-
 fs/ntfs/super.c                                    |    4 ++--
 fs/ocfs2/cluster/nodemanager.c                     |    4 ++--
 fs/ocfs2/dlmfs/dlmfs.c                             |    4 ++--
 fs/openpromfs/inode.c                              |    4 ++--
 fs/proc/vmcore.c                                   |    2 +-
 fs/pstore/inode.c                                  |    2 +-
 fs/qnx4/inode.c                                    |    4 ++--
 fs/ramfs/inode.c                                   |    4 ++--
 fs/sysv/super.c                                    |    4 ++--
 fs/udf/super.c                                     |    4 ++--
 fs/ufs/super.c                                     |    4 ++--
 kernel/kexec.c                                     |    4 ++--
 mm/huge_memory.c                                   |    2 +-
 mm/ksm.c                                           |    2 +-
 mm/page_alloc.c                                    |    2 +-
 mm/vmscan.c                                        |    2 +-
 mm/vmstat.c                                        |    2 +-
 net/9p/mod.c                                       |    4 ++--
 net/bridge/br.c                                    |    4 ++--
 net/dns_resolver/dns_key.c                         |    4 ++--
 net/sched/cls_basic.c                              |    4 ++--
 net/sched/cls_fw.c                                 |    4 ++--
 net/sched/cls_route.c                              |    4 ++--
 net/sched/cls_rsvp.h                               |    4 ++--
 net/sched/cls_tcindex.c                            |    4 ++--
 net/sched/cls_u32.c                                |    4 ++--
 net/sched/sch_atm.c                                |    4 ++--
 net/sched/sch_blackhole.c                          |    4 ++--
 net/sched/sch_cbq.c                                |    4 ++--
 net/sched/sch_choke.c                              |    4 ++--
 net/sched/sch_dsmark.c                             |    4 ++--
 net/sched/sch_gred.c                               |    4 ++--
 net/sched/sch_htb.c                                |    4 ++--
 net/sched/sch_ingress.c                            |    4 ++--
 net/sched/sch_multiq.c                             |    4 ++--
 net/sched/sch_netem.c                              |    4 ++--
 net/sched/sch_prio.c                               |    4 ++--
 net/sched/sch_red.c                                |    4 ++--
 net/sched/sch_sfb.c                                |    4 ++--
 net/sched/sch_sfq.c                                |    4 ++--
 net/sched/sch_tbf.c                                |    4 ++--
 net/sunrpc/auth_gss/auth_gss.c                     |    4 ++--
 samples/kprobes/jprobe_example.c                   |    4 ++--
 samples/kprobes/kprobe_example.c                   |    4 ++--
 samples/kprobes/kretprobe_example.c                |    4 ++--
 samples/tracepoints/tracepoint-sample.c            |    4 ++--
 sound/core/hwdep.c                                 |    4 ++--
 sound/core/memalloc.c                              |    4 ++--
 sound/core/oss/mixer_oss.c                         |    4 ++--
 sound/core/oss/pcm_oss.c                           |    4 ++--
 sound/core/pcm.c                                   |    4 ++--
 sound/core/rawmidi.c                               |    4 ++--
 sound/core/rtctimer.c                              |    4 ++--
 sound/core/seq/oss/seq_oss.c                       |    4 ++--
 sound/core/seq/seq.c                               |    4 ++--
 sound/core/seq/seq_device.c                        |    4 ++--
 sound/core/seq/seq_dummy.c                         |    4 ++--
 sound/core/seq/seq_midi.c                          |    4 ++--
 sound/core/seq/seq_midi_emul.c                     |    4 ++--
 sound/core/seq/seq_midi_event.c                    |    4 ++--
 sound/core/seq/seq_virmidi.c                       |    4 ++--
 sound/core/timer.c                                 |    4 ++--
 sound/drivers/aloop.c                              |    4 ++--
 sound/drivers/dummy.c                              |    4 ++--
 sound/drivers/ml403-ac97cr.c                       |    4 ++--
 sound/drivers/mpu401/mpu401.c                      |    4 ++--
 sound/drivers/mpu401/mpu401_uart.c                 |    4 ++--
 sound/drivers/mtpav.c                              |    4 ++--
 sound/drivers/opl3/opl3_lib.c                      |    4 ++--
 sound/drivers/opl3/opl3_seq.c                      |    4 ++--
 sound/drivers/opl4/opl4_lib.c                      |    4 ++--
 sound/drivers/opl4/opl4_seq.c                      |    4 ++--
 sound/drivers/serial-u16550.c                      |    4 ++--
 sound/drivers/virmidi.c                            |    4 ++--
 sound/drivers/vx/vx_core.c                         |    4 ++--
 sound/i2c/cs8427.c                                 |    4 ++--
 sound/i2c/i2c.c                                    |    4 ++--
 sound/i2c/other/ak4xxx-adda.c                      |    4 ++--
 sound/i2c/other/tea575x-tuner.c                    |    4 ++--
 sound/i2c/tea6330t.c                               |    4 ++--
 sound/isa/ad1816a/ad1816a.c                        |    4 ++--
 sound/isa/als100.c                                 |    4 ++--
 sound/isa/azt2320.c                                |    4 ++--
 sound/isa/cmi8330.c                                |    4 ++--
 sound/isa/cs423x/cs4236.c                          |    4 ++--
 sound/isa/es1688/es1688_lib.c                      |    4 ++--
 sound/isa/es18xx.c                                 |    4 ++--
 sound/isa/gus/gus_main.c                           |    4 ++--
 sound/isa/gus/gusmax.c                             |    4 ++--
 sound/isa/gus/interwave.c                          |    4 ++--
 sound/isa/opl3sa2.c                                |    4 ++--
 sound/isa/opti9xx/miro.c                           |    4 ++--
 sound/isa/opti9xx/opti92x-ad1848.c                 |    4 ++--
 sound/isa/sb/emu8000_synth.c                       |    4 ++--
 sound/isa/sb/jazz16.c                              |    4 ++--
 sound/isa/sb/sb16.c                                |    4 ++--
 sound/isa/sb/sb16_csp.c                            |    4 ++--
 sound/isa/sb/sb16_main.c                           |    4 ++--
 sound/isa/sb/sb8.c                                 |    4 ++--
 sound/isa/sb/sb8_main.c                            |    4 ++--
 sound/isa/sb/sb_common.c                           |    4 ++--
 sound/isa/sc6000.c                                 |    4 ++--
 sound/isa/wavefront/wavefront.c                    |    4 ++--
 sound/mips/sgio2audio.c                            |    4 ++--
 sound/pci/ac97/ac97_codec.c                        |    4 ++--
 sound/pci/ali5451/ali5451.c                        |    4 ++--
 sound/pci/als300.c                                 |    4 ++--
 sound/pci/als4000.c                                |    4 ++--
 sound/pci/asihpi/asihpi.c                          |    4 ++--
 sound/pci/atiixp.c                                 |    4 ++--
 sound/pci/atiixp_modem.c                           |    4 ++--
 sound/pci/au88x0/au88x0.c                          |    4 ++--
 sound/pci/azt3328.c                                |    4 ++--
 sound/pci/bt87x.c                                  |    4 ++--
 sound/pci/ca0106/ca0106_main.c                     |    4 ++--
 sound/pci/cmipci.c                                 |    4 ++--
 sound/pci/cs4281.c                                 |    4 ++--
 sound/pci/cs46xx/cs46xx.c                          |    4 ++--
 sound/pci/cs5530.c                                 |    4 ++--
 sound/pci/cs5535audio/cs5535audio.c                |    4 ++--
 sound/pci/ctxfi/xfi.c                              |    4 ++--
 sound/pci/echoaudio/echoaudio.c                    |    4 ++--
 sound/pci/emu10k1/emu10k1.c                        |    4 ++--
 sound/pci/emu10k1/emu10k1_synth.c                  |    4 ++--
 sound/pci/emu10k1/emu10k1x.c                       |    4 ++--
 sound/pci/ens1370.c                                |    4 ++--
 sound/pci/es1938.c                                 |    4 ++--
 sound/pci/es1968.c                                 |    4 ++--
 sound/pci/fm801.c                                  |    4 ++--
 sound/pci/hda/hda_intel.c                          |    4 ++--
 sound/pci/hda/patch_analog.c                       |    4 ++--
 sound/pci/hda/patch_ca0110.c                       |    4 ++--
 sound/pci/hda/patch_cirrus.c                       |    4 ++--
 sound/pci/hda/patch_cmedia.c                       |    4 ++--
 sound/pci/hda/patch_conexant.c                     |    4 ++--
 sound/pci/hda/patch_hdmi.c                         |    4 ++--
 sound/pci/hda/patch_realtek.c                      |    4 ++--
 sound/pci/hda/patch_si3054.c                       |    4 ++--
 sound/pci/hda/patch_sigmatel.c                     |    4 ++--
 sound/pci/hda/patch_via.c                          |    4 ++--
 sound/pci/ice1712/ak4xxx.c                         |    4 ++--
 sound/pci/ice1712/ice1712.c                        |    4 ++--
 sound/pci/ice1712/ice1724.c                        |    4 ++--
 sound/pci/intel8x0.c                               |    4 ++--
 sound/pci/intel8x0m.c                              |    4 ++--
 sound/pci/korg1212/korg1212.c                      |    4 ++--
 sound/pci/maestro3.c                               |    4 ++--
 sound/pci/mixart/mixart.c                          |    4 ++--
 sound/pci/nm256/nm256.c                            |    4 ++--
 sound/pci/oxygen/oxygen.c                          |    4 ++--
 sound/pci/oxygen/virtuoso.c                        |    4 ++--
 sound/pci/pcxhr/pcxhr.c                            |    4 ++--
 sound/pci/rme32.c                                  |    4 ++--
 sound/pci/rme96.c                                  |    4 ++--
 sound/pci/rme9652/hdsp.c                           |    4 ++--
 sound/pci/rme9652/hdspm.c                          |    4 ++--
 sound/pci/rme9652/rme9652.c                        |    4 ++--
 sound/pci/sonicvibes.c                             |    4 ++--
 sound/pci/trident/trident.c                        |    4 ++--
 sound/pci/via82xx.c                                |    4 ++--
 sound/pci/via82xx_modem.c                          |    4 ++--
 sound/pci/vx222/vx222.c                            |    4 ++--
 sound/pci/ymfpci/ymfpci.c                          |    4 ++--
 sound/ppc/powermac.c                               |    4 ++--
 sound/soc/sh/siu_dai.c                             |    4 ++--
 sound/synth/emux/emux.c                            |    4 ++--
 sound/synth/util_mem.c                             |    4 ++--
 sound/usb/caiaq/device.c                           |    4 ++--
 sound/usb/usx2y/us122l.c                           |    4 ++--
 sound/usb/usx2y/usbusx2y.c                         |    4 ++--
 404 files changed, 789 insertions(+), 789 deletions(-)

diff --git a/Documentation/DocBook/writing-an-alsa-driver.tmpl b/Documentation/DocBook/writing-an-alsa-driver.tmpl
index 58ced23..5d0d5a1 100644
--- a/Documentation/DocBook/writing-an-alsa-driver.tmpl
+++ b/Documentation/DocBook/writing-an-alsa-driver.tmpl
@@ -1215,8 +1215,8 @@
           pci_unregister_driver(&driver);
   }
 
-  module_init(alsa_card_mychip_init)
-  module_exit(alsa_card_mychip_exit)
+  module_init(alsa_card_mychip_init);
+  module_exit(alsa_card_mychip_exit);
 
   EXPORT_NO_SYMBOLS; /* for old kernels only */
 ]]>
@@ -1655,8 +1655,8 @@
           pci_unregister_driver(&driver);
   }
 
-  module_init(alsa_card_mychip_init)
-  module_exit(alsa_card_mychip_exit)
+  module_init(alsa_card_mychip_init);
+  module_exit(alsa_card_mychip_exit);
 ]]>
           </programlisting>
         </informalexample>
diff --git a/arch/arm/plat-omap/iommu-debug.c b/arch/arm/plat-omap/iommu-debug.c
index f07cf2f..f5e6ad4 100644
--- a/arch/arm/plat-omap/iommu-debug.c
+++ b/arch/arm/plat-omap/iommu-debug.c
@@ -405,13 +405,13 @@ err_out:
 	debugfs_remove_recursive(iommu_debug_root);
 	return err;
 }
-module_init(iommu_debug_init)
+module_init(iommu_debug_init);
 
 static void __exit iommu_debugfs_exit(void)
 {
 	debugfs_remove_recursive(iommu_debug_root);
 }
-module_exit(iommu_debugfs_exit)
+module_exit(iommu_debugfs_exit);
 
 MODULE_DESCRIPTION("omap iommu: debugfs interface");
 MODULE_AUTHOR("Hiroshi DOYU <Hiroshi.DOYU@nokia.com>");
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
index 6fe874f..6b5ce5b 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -511,8 +511,8 @@ static void __exit hypfs_exit(void)
 	kobject_put(s390_kobj);
 }
 
-module_init(hypfs_init)
-module_exit(hypfs_exit)
+module_init(hypfs_init);
+module_exit(hypfs_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael Holzheu <holzheu@de.ibm.com>");
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 12fcbe2..32fe006 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -290,7 +290,7 @@ static void __exit msr_exit(void)
 }
 
 module_init(msr_init);
-module_exit(msr_exit)
+module_exit(msr_exit);
 
 MODULE_AUTHOR("H. Peter Anvin <hpa@zytor.com>");
 MODULE_DESCRIPTION("x86 generic MSR driver");
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6bb15d5..8829241 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3969,5 +3969,5 @@ static void __exit svm_exit(void)
 	kvm_exit();
 }
 
-module_init(svm_init)
-module_exit(svm_exit)
+module_init(svm_init);
+module_exit(svm_exit);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5b4cdcb..f8cf8ea 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4546,5 +4546,5 @@ static void __exit vmx_exit(void)
 	kvm_exit();
 }
 
-module_init(vmx_init)
-module_exit(vmx_exit)
+module_init(vmx_init);
+module_exit(vmx_exit);
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index c871eae..f03f06b 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2052,7 +2052,7 @@ static void __exit atari_floppy_exit(void)
 	atari_stram_free( DMABuffer );
 }
 
-module_init(atari_floppy_init)
-module_exit(atari_floppy_exit)
+module_init(atari_floppy_init);
+module_exit(atari_floppy_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index b2fceb5..d402c47 100644
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
index 5b525c1..80fe17e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -4169,8 +4169,8 @@ const char *drbd_buildtag(void)
 	return buildtag;
 }
 
-module_init(drbd_init)
-module_exit(drbd_cleanup)
+module_init(drbd_init);
+module_exit(drbd_cleanup);
 
 EXPORT_SYMBOL(drbd_conn_str);
 EXPORT_SYMBOL(drbd_role_str);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 301d7a9..4f4353c 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4613,7 +4613,7 @@ MODULE_DEVICE_TABLE(pnp, floppy_pnpids);
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
index ad12452..557ecba 100644
--- a/drivers/block/paride/bpck6.c
+++ b/drivers/block/paride/bpck6.c
@@ -264,5 +264,5 @@ MODULE_LICENSE("GPL");
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
index 2f2ccf6..b4d0842 100644
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
index 21dfdb7..1a7e8b7 100644
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
index 7adeb1e..d281284 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -1003,5 +1003,5 @@ static void __exit pf_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(pf_init)
-module_exit(pf_exit)
+module_init(pf_init);
+module_exit(pf_exit);
diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index 6b9a200..c8ccc7a 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -720,5 +720,5 @@ static void __exit pg_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(pg_init)
-module_exit(pg_exit)
+module_init(pg_init);
+module_exit(pg_exit);
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 7179f79..9399fb7 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -1010,5 +1010,5 @@ static void __exit pt_exit(void)
 }
 
 MODULE_LICENSE("GPL");
-module_init(pt_init)
-module_exit(pt_exit)
+module_init(pt_init);
+module_exit(pt_exit);
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 4c10f56..fe7cd3b 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1207,7 +1207,7 @@ int swim3_init(void)
 	return 0;
 }
 
-module_init(swim3_init)
+module_init(swim3_init);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul Mackerras");
diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/bt8xxgpio.c
index aa4f09a..5d96035 100644
--- a/drivers/gpio/bt8xxgpio.c
+++ b/drivers/gpio/bt8xxgpio.c
@@ -335,13 +335,13 @@ static int __init bt8xxgpio_init(void)
 {
 	return pci_register_driver(&bt8xxgpio_pci_driver);
 }
-module_init(bt8xxgpio_init)
+module_init(bt8xxgpio_init);
 
 static void __exit bt8xxgpio_exit(void)
 {
 	pci_unregister_driver(&bt8xxgpio_pci_driver);
 }
-module_exit(bt8xxgpio_exit)
+module_exit(bt8xxgpio_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael Buesch");
diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index 1ad0a88..9030b87 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -469,5 +469,5 @@ MODULE_LICENSE("GPL");
 module_param(read_only, bool, 0);
 MODULE_PARM_DESC(read_only, "Don't set any values, read only mode");
 
-module_init(sensors_adm1021_init)
-module_exit(sensors_adm1021_exit)
+module_init(sensors_adm1021_init);
+module_exit(sensors_adm1021_exit);
diff --git a/drivers/hwmon/adt7411.c b/drivers/hwmon/adt7411.c
index 5cc3e37..f17c301 100644
--- a/drivers/hwmon/adt7411.c
+++ b/drivers/hwmon/adt7411.c
@@ -352,13 +352,13 @@ static int __init sensors_adt7411_init(void)
 {
 	return i2c_add_driver(&adt7411_driver);
 }
-module_init(sensors_adt7411_init)
+module_init(sensors_adt7411_init);
 
 static void __exit sensors_adt7411_exit(void)
 {
 	i2c_del_driver(&adt7411_driver);
 }
-module_exit(sensors_adt7411_exit)
+module_exit(sensors_adt7411_exit);
 
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de> and "
 	"Wolfram Sang <w.sang@pengutronix.de>");
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 194ca0a..5e73e81 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -599,5 +599,5 @@ MODULE_AUTHOR("Rudolf Marek <r.marek@assembler.cz>");
 MODULE_DESCRIPTION("Intel Core temperature monitor");
 MODULE_LICENSE("GPL");
 
-module_init(coretemp_init)
-module_exit(coretemp_exit)
+module_init(coretemp_init);
+module_exit(coretemp_exit);
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index 82bf65a..3235438 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -230,5 +230,5 @@ static void __exit k10temp_exit(void)
 	pci_unregister_driver(&k10temp_driver);
 }
 
-module_init(k10temp_init)
-module_exit(k10temp_exit)
+module_init(k10temp_init);
+module_exit(k10temp_exit);
diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index 418496f..2a8e3e6 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -352,5 +352,5 @@ MODULE_AUTHOR("Rudolf Marek <r.marek@assembler.cz>");
 MODULE_DESCRIPTION("AMD K8 core temperature monitor");
 MODULE_LICENSE("GPL");
 
-module_init(k8temp_init)
-module_exit(k8temp_exit)
+module_init(k8temp_init);
+module_exit(k8temp_exit);
diff --git a/drivers/hwmon/pkgtemp.c b/drivers/hwmon/pkgtemp.c
index 21c817d..8d07879 100644
--- a/drivers/hwmon/pkgtemp.c
+++ b/drivers/hwmon/pkgtemp.c
@@ -440,5 +440,5 @@ MODULE_AUTHOR("Fenghua Yu <fenghua.yu@intel.com>");
 MODULE_DESCRIPTION("Intel processor package temperature monitor");
 MODULE_LICENSE("GPL");
 
-module_init(pkgtemp_init)
-module_exit(pkgtemp_exit)
+module_init(pkgtemp_init);
+module_exit(pkgtemp_exit);
diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index 0d18de4..7a5da6d 100644
--- a/drivers/hwmon/via-cputemp.c
+++ b/drivers/hwmon/via-cputemp.c
@@ -342,5 +342,5 @@ MODULE_AUTHOR("Harald Welte <HaraldWelte@viatech.com>");
 MODULE_DESCRIPTION("VIA CPU temperature monitor");
 MODULE_LICENSE("GPL");
 
-module_init(via_cputemp_init)
-module_exit(via_cputemp_exit)
+module_init(via_cputemp_init);
+module_exit(via_cputemp_exit);
diff --git a/drivers/i2c/busses/i2c-amd756.c b/drivers/i2c/busses/i2c-amd756.c
index 03bcd07..6890150 100644
--- a/drivers/i2c/busses/i2c-amd756.c
+++ b/drivers/i2c/busses/i2c-amd756.c
@@ -426,5 +426,5 @@ MODULE_LICENSE("GPL");
 
 EXPORT_SYMBOL(amd756_smbus);
 
-module_init(amd756_init)
-module_exit(amd756_exit)
+module_init(amd756_init);
+module_exit(amd756_exit);
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
index 7d6f7f1..a42271c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7485,7 +7485,7 @@ static __exit void md_exit(void)
 }
 
 subsys_initcall(md_init);
-module_exit(md_exit)
+module_exit(md_exit);
 
 static int get_ro(char *buffer, struct kernel_param *kp)
 {
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index af5263c..801c3f0 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -312,8 +312,8 @@ static void __exit media_devnode_exit(void)
 	unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
 }
 
-module_init(media_devnode_init)
-module_exit(media_devnode_exit)
+module_init(media_devnode_init);
+module_exit(media_devnode_exit);
 
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
 MODULE_DESCRIPTION("Device node registration for media drivers");
diff --git a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
index 9a8752f..9a45b6c 100644
--- a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
+++ b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
@@ -82,8 +82,8 @@ static void __exit exit_rc_map_adstech_dvb_t_pci(void)
 	rc_map_unregister(&adstech_dvb_t_pci_map);
 }
 
-module_init(init_rc_map_adstech_dvb_t_pci)
-module_exit(exit_rc_map_adstech_dvb_t_pci)
+module_init(init_rc_map_adstech_dvb_t_pci);
+module_exit(exit_rc_map_adstech_dvb_t_pci);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-alink-dtu-m.c b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
index fe652e9..2467b6c 100644
--- a/drivers/media/rc/keymaps/rc-alink-dtu-m.c
+++ b/drivers/media/rc/keymaps/rc-alink-dtu-m.c
@@ -61,8 +61,8 @@ static void __exit exit_rc_map_alink_dtu_m(void)
 	rc_map_unregister(&alink_dtu_m_map);
 }
 
-module_init(init_rc_map_alink_dtu_m)
-module_exit(exit_rc_map_alink_dtu_m)
+module_init(init_rc_map_alink_dtu_m);
+module_exit(exit_rc_map_alink_dtu_m);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-anysee.c b/drivers/media/rc/keymaps/rc-anysee.c
index 884f1b5..6bd6e34 100644
--- a/drivers/media/rc/keymaps/rc-anysee.c
+++ b/drivers/media/rc/keymaps/rc-anysee.c
@@ -86,8 +86,8 @@ static void __exit exit_rc_map_anysee(void)
 	rc_map_unregister(&anysee_map);
 }
 
-module_init(init_rc_map_anysee)
-module_exit(exit_rc_map_anysee)
+module_init(init_rc_map_anysee);
+module_exit(exit_rc_map_anysee);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-apac-viewcomp.c b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
index 7af1882..a133c7b 100644
--- a/drivers/media/rc/keymaps/rc-apac-viewcomp.c
+++ b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
@@ -73,8 +73,8 @@ static void __exit exit_rc_map_apac_viewcomp(void)
 	rc_map_unregister(&apac_viewcomp_map);
 }
 
-module_init(init_rc_map_apac_viewcomp)
-module_exit(exit_rc_map_apac_viewcomp)
+module_init(init_rc_map_apac_viewcomp);
+module_exit(exit_rc_map_apac_viewcomp);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-asus-pc39.c b/drivers/media/rc/keymaps/rc-asus-pc39.c
index b248115..45ce097 100644
--- a/drivers/media/rc/keymaps/rc-asus-pc39.c
+++ b/drivers/media/rc/keymaps/rc-asus-pc39.c
@@ -84,8 +84,8 @@ static void __exit exit_rc_map_asus_pc39(void)
 	rc_map_unregister(&asus_pc39_map);
 }
 
-module_init(init_rc_map_asus_pc39)
-module_exit(exit_rc_map_asus_pc39)
+module_init(init_rc_map_asus_pc39);
+module_exit(exit_rc_map_asus_pc39);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
index f766b24..d1fd2ac 100644
--- a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
+++ b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
@@ -62,8 +62,8 @@ static void __exit exit_rc_map_ati_tv_wonder_hd_600(void)
 	rc_map_unregister(&ati_tv_wonder_hd_600_map);
 }
 
-module_init(init_rc_map_ati_tv_wonder_hd_600)
-module_exit(exit_rc_map_ati_tv_wonder_hd_600)
+module_init(init_rc_map_ati_tv_wonder_hd_600);
+module_exit(exit_rc_map_ati_tv_wonder_hd_600);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-a16d.c b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
index ec9beee..89033fe 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-a16d.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
@@ -68,8 +68,8 @@ static void __exit exit_rc_map_avermedia_a16d(void)
 	rc_map_unregister(&avermedia_a16d_map);
 }
 
-module_init(init_rc_map_avermedia_a16d)
-module_exit(exit_rc_map_avermedia_a16d)
+module_init(init_rc_map_avermedia_a16d);
+module_exit(exit_rc_map_avermedia_a16d);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
index bdf97b7..e0aa749 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
@@ -90,8 +90,8 @@ static void __exit exit_rc_map_avermedia_cardbus(void)
 	rc_map_unregister(&avermedia_cardbus_map);
 }
 
-module_init(init_rc_map_avermedia_cardbus)
-module_exit(exit_rc_map_avermedia_cardbus)
+module_init(init_rc_map_avermedia_cardbus);
+module_exit(exit_rc_map_avermedia_cardbus);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
index c25809d..657d375 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
@@ -71,8 +71,8 @@ static void __exit exit_rc_map_avermedia_dvbt(void)
 	rc_map_unregister(&avermedia_dvbt_map);
 }
 
-module_init(init_rc_map_avermedia_dvbt)
-module_exit(exit_rc_map_avermedia_dvbt)
+module_init(init_rc_map_avermedia_dvbt);
+module_exit(exit_rc_map_avermedia_dvbt);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index 3d2cbe4..f83293e 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -140,8 +140,8 @@ static void __exit exit_rc_map_avermedia_m135a(void)
 	rc_map_unregister(&avermedia_m135a_map);
 }
 
-module_init(init_rc_map_avermedia_m135a)
-module_exit(exit_rc_map_avermedia_m135a)
+module_init(init_rc_map_avermedia_m135a);
+module_exit(exit_rc_map_avermedia_m135a);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
index 8cd7f28..fd6bde3 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
@@ -88,8 +88,8 @@ static void __exit exit_rc_map_avermedia_m733a_rm_k6(void)
 	rc_map_unregister(&avermedia_m733a_rm_k6_map);
 }
 
-module_init(init_rc_map_avermedia_m733a_rm_k6)
-module_exit(exit_rc_map_avermedia_m733a_rm_k6)
+module_init(init_rc_map_avermedia_m733a_rm_k6);
+module_exit(exit_rc_map_avermedia_m733a_rm_k6);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
index 9d68af2..c43a98b 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-rm-ks.c
@@ -72,8 +72,8 @@ static void __exit exit_rc_map_avermedia_rm_ks(void)
 	rc_map_unregister(&avermedia_rm_ks_map);
 }
 
-module_init(init_rc_map_avermedia_rm_ks)
-module_exit(exit_rc_map_avermedia_rm_ks)
+module_init(init_rc_map_avermedia_rm_ks);
+module_exit(exit_rc_map_avermedia_rm_ks);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia.c b/drivers/media/rc/keymaps/rc-avermedia.c
index edfa715..3fe8b10 100644
--- a/drivers/media/rc/keymaps/rc-avermedia.c
+++ b/drivers/media/rc/keymaps/rc-avermedia.c
@@ -79,8 +79,8 @@ static void __exit exit_rc_map_avermedia(void)
 	rc_map_unregister(&avermedia_map);
 }
 
-module_init(init_rc_map_avermedia)
-module_exit(exit_rc_map_avermedia)
+module_init(init_rc_map_avermedia);
+module_exit(exit_rc_map_avermedia);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-avertv-303.c b/drivers/media/rc/keymaps/rc-avertv-303.c
index 32e9498..bd0d941 100644
--- a/drivers/media/rc/keymaps/rc-avertv-303.c
+++ b/drivers/media/rc/keymaps/rc-avertv-303.c
@@ -78,8 +78,8 @@ static void __exit exit_rc_map_avertv_303(void)
 	rc_map_unregister(&avertv_303_map);
 }
 
-module_init(init_rc_map_avertv_303)
-module_exit(exit_rc_map_avertv_303)
+module_init(init_rc_map_avertv_303);
+module_exit(exit_rc_map_avertv_303);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
index c3f6d62..9cd0f1c 100644
--- a/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
+++ b/drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c
@@ -95,8 +95,8 @@ static void __exit exit_rc_map_azurewave_ad_tu700(void)
 	rc_map_unregister(&azurewave_ad_tu700_map);
 }
 
-module_init(init_rc_map_azurewave_ad_tu700)
-module_exit(exit_rc_map_azurewave_ad_tu700)
+module_init(init_rc_map_azurewave_ad_tu700);
+module_exit(exit_rc_map_azurewave_ad_tu700);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
index 8bf058f..427189c 100644
--- a/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -101,8 +101,8 @@ static void __exit exit_rc_map_behold_columbus(void)
 	rc_map_unregister(&behold_columbus_map);
 }
 
-module_init(init_rc_map_behold_columbus)
-module_exit(exit_rc_map_behold_columbus)
+module_init(init_rc_map_behold_columbus);
+module_exit(exit_rc_map_behold_columbus);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index c909a23..8ea518b 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -134,8 +134,8 @@ static void __exit exit_rc_map_behold(void)
 	rc_map_unregister(&behold_map);
 }
 
-module_init(init_rc_map_behold)
-module_exit(exit_rc_map_behold)
+module_init(init_rc_map_behold);
+module_exit(exit_rc_map_behold);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
index 2f66e43..7215d26 100644
--- a/drivers/media/rc/keymaps/rc-budget-ci-old.c
+++ b/drivers/media/rc/keymaps/rc-budget-ci-old.c
@@ -86,8 +86,8 @@ static void __exit exit_rc_map_budget_ci_old(void)
 	rc_map_unregister(&budget_ci_old_map);
 }
 
-module_init(init_rc_map_budget_ci_old)
-module_exit(exit_rc_map_budget_ci_old)
+module_init(init_rc_map_budget_ci_old);
+module_exit(exit_rc_map_budget_ci_old);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-cinergy-1400.c b/drivers/media/rc/keymaps/rc-cinergy-1400.c
index 284534b..479b62e 100644
--- a/drivers/media/rc/keymaps/rc-cinergy-1400.c
+++ b/drivers/media/rc/keymaps/rc-cinergy-1400.c
@@ -77,8 +77,8 @@ static void __exit exit_rc_map_cinergy_1400(void)
 	rc_map_unregister(&cinergy_1400_map);
 }
 
-module_init(init_rc_map_cinergy_1400)
-module_exit(exit_rc_map_cinergy_1400)
+module_init(init_rc_map_cinergy_1400);
+module_exit(exit_rc_map_cinergy_1400);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
index cf3a6bf..99559f1 100644
--- a/drivers/media/rc/keymaps/rc-cinergy.c
+++ b/drivers/media/rc/keymaps/rc-cinergy.c
@@ -71,8 +71,8 @@ static void __exit exit_rc_map_cinergy(void)
 	rc_map_unregister(&cinergy_map);
 }
 
-module_init(init_rc_map_cinergy)
-module_exit(exit_rc_map_cinergy)
+module_init(init_rc_map_cinergy);
+module_exit(exit_rc_map_cinergy);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index 7a5f530..6db9292 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -117,8 +117,8 @@ static void __exit exit_rc_map(void)
 	rc_map_unregister(&dib0700_nec_map);
 }
 
-module_init(init_rc_map)
-module_exit(exit_rc_map)
+module_init(init_rc_map);
+module_exit(exit_rc_map);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
index 4af12e4..0225212 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-rc5.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
@@ -228,8 +228,8 @@ static void __exit exit_rc_map(void)
 	rc_map_unregister(&dib0700_rc5_map);
 }
 
-module_init(init_rc_map)
-module_exit(exit_rc_map)
+module_init(init_rc_map);
+module_exit(exit_rc_map);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
index f68b450..22ecbcf 100644
--- a/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
+++ b/drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c
@@ -91,8 +91,8 @@ static void __exit exit_rc_map_digitalnow_tinytwin(void)
 	rc_map_unregister(&digitalnow_tinytwin_map);
 }
 
-module_init(init_rc_map_digitalnow_tinytwin)
-module_exit(exit_rc_map_digitalnow_tinytwin)
+module_init(init_rc_map_digitalnow_tinytwin);
+module_exit(exit_rc_map_digitalnow_tinytwin);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-digittrade.c b/drivers/media/rc/keymaps/rc-digittrade.c
index 21d4987..d1408e8 100644
--- a/drivers/media/rc/keymaps/rc-digittrade.c
+++ b/drivers/media/rc/keymaps/rc-digittrade.c
@@ -75,8 +75,8 @@ static void __exit exit_rc_map_digittrade(void)
 	rc_map_unregister(&digittrade_map);
 }
 
-module_init(init_rc_map_digittrade)
-module_exit(exit_rc_map_digittrade)
+module_init(init_rc_map_digittrade);
+module_exit(exit_rc_map_digittrade);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-dm1105-nec.c b/drivers/media/rc/keymaps/rc-dm1105-nec.c
index d024fbf..2b5407b 100644
--- a/drivers/media/rc/keymaps/rc-dm1105-nec.c
+++ b/drivers/media/rc/keymaps/rc-dm1105-nec.c
@@ -69,8 +69,8 @@ static void __exit exit_rc_map_dm1105_nec(void)
 	rc_map_unregister(&dm1105_nec_map);
 }
 
-module_init(init_rc_map_dm1105_nec)
-module_exit(exit_rc_map_dm1105_nec)
+module_init(init_rc_map_dm1105_nec);
+module_exit(exit_rc_map_dm1105_nec);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
index 82c0200..2109718 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
@@ -71,8 +71,8 @@ static void __exit exit_rc_map_dntv_live_dvb_t(void)
 	rc_map_unregister(&dntv_live_dvb_t_map);
 }
 
-module_init(init_rc_map_dntv_live_dvb_t)
-module_exit(exit_rc_map_dntv_live_dvb_t)
+module_init(init_rc_map_dntv_live_dvb_t);
+module_exit(exit_rc_map_dntv_live_dvb_t);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
index 015e99d..5eeae36 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
@@ -90,8 +90,8 @@ static void __exit exit_rc_map_dntv_live_dvbt_pro(void)
 	rc_map_unregister(&dntv_live_dvbt_pro_map);
 }
 
-module_init(init_rc_map_dntv_live_dvbt_pro)
-module_exit(exit_rc_map_dntv_live_dvbt_pro)
+module_init(init_rc_map_dntv_live_dvbt_pro);
+module_exit(exit_rc_map_dntv_live_dvbt_pro);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-em-terratec.c b/drivers/media/rc/keymaps/rc-em-terratec.c
index 269d429..4620da0 100644
--- a/drivers/media/rc/keymaps/rc-em-terratec.c
+++ b/drivers/media/rc/keymaps/rc-em-terratec.c
@@ -62,8 +62,8 @@ static void __exit exit_rc_map_em_terratec(void)
 	rc_map_unregister(&em_terratec_map);
 }
 
-module_init(init_rc_map_em_terratec)
-module_exit(exit_rc_map_em_terratec)
+module_init(init_rc_map_em_terratec);
+module_exit(exit_rc_map_em_terratec);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
index e388698..ca675ee 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
@@ -74,8 +74,8 @@ static void __exit exit_rc_map_encore_enltv_fm53(void)
 	rc_map_unregister(&encore_enltv_fm53_map);
 }
 
-module_init(init_rc_map_encore_enltv_fm53)
-module_exit(exit_rc_map_encore_enltv_fm53)
+module_init(init_rc_map_encore_enltv_fm53);
+module_exit(exit_rc_map_encore_enltv_fm53);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
index e56ac6e..ad90690 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -105,8 +105,8 @@ static void __exit exit_rc_map_encore_enltv(void)
 	rc_map_unregister(&encore_enltv_map);
 }
 
-module_init(init_rc_map_encore_enltv)
-module_exit(exit_rc_map_encore_enltv)
+module_init(init_rc_map_encore_enltv);
+module_exit(exit_rc_map_encore_enltv);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
index b6264f1..a934725 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -83,8 +83,8 @@ static void __exit exit_rc_map_encore_enltv2(void)
 	rc_map_unregister(&encore_enltv2_map);
 }
 
-module_init(init_rc_map_encore_enltv2)
-module_exit(exit_rc_map_encore_enltv2)
+module_init(init_rc_map_encore_enltv2);
+module_exit(exit_rc_map_encore_enltv2);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-evga-indtube.c b/drivers/media/rc/keymaps/rc-evga-indtube.c
index a2bf24f..2704ff8 100644
--- a/drivers/media/rc/keymaps/rc-evga-indtube.c
+++ b/drivers/media/rc/keymaps/rc-evga-indtube.c
@@ -54,8 +54,8 @@ static void __exit exit_rc_map_evga_indtube(void)
 	rc_map_unregister(&evga_indtube_map);
 }
 
-module_init(init_rc_map_evga_indtube)
-module_exit(exit_rc_map_evga_indtube)
+module_init(init_rc_map_evga_indtube);
+module_exit(exit_rc_map_evga_indtube);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-eztv.c b/drivers/media/rc/keymaps/rc-eztv.c
index 1e8e5b2..5596a3b 100644
--- a/drivers/media/rc/keymaps/rc-eztv.c
+++ b/drivers/media/rc/keymaps/rc-eztv.c
@@ -89,8 +89,8 @@ static void __exit exit_rc_map_eztv(void)
 	rc_map_unregister(&eztv_map);
 }
 
-module_init(init_rc_map_eztv)
-module_exit(exit_rc_map_eztv)
+module_init(init_rc_map_eztv);
+module_exit(exit_rc_map_eztv);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
index a8b0f66..5b69ade 100644
--- a/drivers/media/rc/keymaps/rc-flydvb.c
+++ b/drivers/media/rc/keymaps/rc-flydvb.c
@@ -70,8 +70,8 @@ static void __exit exit_rc_map_flydvb(void)
 	rc_map_unregister(&flydvb_map);
 }
 
-module_init(init_rc_map_flydvb)
-module_exit(exit_rc_map_flydvb)
+module_init(init_rc_map_flydvb);
+module_exit(exit_rc_map_flydvb);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-flyvideo.c b/drivers/media/rc/keymaps/rc-flyvideo.c
index 5bbe683..66b29e3 100644
--- a/drivers/media/rc/keymaps/rc-flyvideo.c
+++ b/drivers/media/rc/keymaps/rc-flyvideo.c
@@ -63,8 +63,8 @@ static void __exit exit_rc_map_flyvideo(void)
 	rc_map_unregister(&flyvideo_map);
 }
 
-module_init(init_rc_map_flyvideo)
-module_exit(exit_rc_map_flyvideo)
+module_init(init_rc_map_flyvideo);
+module_exit(exit_rc_map_flyvideo);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
index c80b25c..9123bda 100644
--- a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
+++ b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
@@ -91,8 +91,8 @@ static void __exit exit_rc_map_fusionhdtv_mce(void)
 	rc_map_unregister(&fusionhdtv_mce_map);
 }
 
-module_init(init_rc_map_fusionhdtv_mce)
-module_exit(exit_rc_map_fusionhdtv_mce)
+module_init(init_rc_map_fusionhdtv_mce);
+module_exit(exit_rc_map_fusionhdtv_mce);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
index 068c9ea..b9db4e5 100644
--- a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
+++ b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
@@ -74,8 +74,8 @@ static void __exit exit_rc_map_gadmei_rm008z(void)
 	rc_map_unregister(&gadmei_rm008z_map);
 }
 
-module_init(init_rc_map_gadmei_rm008z)
-module_exit(exit_rc_map_gadmei_rm008z)
+module_init(init_rc_map_gadmei_rm008z);
+module_exit(exit_rc_map_gadmei_rm008z);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
index cdbbed4..6ca275a 100644
--- a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
+++ b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
@@ -77,8 +77,8 @@ static void __exit exit_rc_map_genius_tvgo_a11mce(void)
 	rc_map_unregister(&genius_tvgo_a11mce_map);
 }
 
-module_init(init_rc_map_genius_tvgo_a11mce)
-module_exit(exit_rc_map_genius_tvgo_a11mce)
+module_init(init_rc_map_genius_tvgo_a11mce);
+module_exit(exit_rc_map_genius_tvgo_a11mce);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-gotview7135.c b/drivers/media/rc/keymaps/rc-gotview7135.c
index a38bdde..bc04d9b 100644
--- a/drivers/media/rc/keymaps/rc-gotview7135.c
+++ b/drivers/media/rc/keymaps/rc-gotview7135.c
@@ -72,8 +72,8 @@ static void __exit exit_rc_map_gotview7135(void)
 	rc_map_unregister(&gotview7135_map);
 }
 
-module_init(init_rc_map_gotview7135)
-module_exit(exit_rc_map_gotview7135)
+module_init(init_rc_map_gotview7135);
+module_exit(exit_rc_map_gotview7135);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-hauppauge.c b/drivers/media/rc/keymaps/rc-hauppauge.c
index cd3db77..d2bb239 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge.c
@@ -234,8 +234,8 @@ static void __exit exit_rc_map_rc5_hauppauge_new(void)
 	rc_map_unregister(&rc5_hauppauge_new_map);
 }
 
-module_init(init_rc_map_rc5_hauppauge_new)
-module_exit(exit_rc_map_rc5_hauppauge_new)
+module_init(init_rc_map_rc5_hauppauge_new);
+module_exit(exit_rc_map_rc5_hauppauge_new);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-imon-mce.c b/drivers/media/rc/keymaps/rc-imon-mce.c
index 937a819..d89309f 100644
--- a/drivers/media/rc/keymaps/rc-imon-mce.c
+++ b/drivers/media/rc/keymaps/rc-imon-mce.c
@@ -135,8 +135,8 @@ static void __exit exit_rc_map_imon_mce(void)
 	rc_map_unregister(&imon_mce_map);
 }
 
-module_init(init_rc_map_imon_mce)
-module_exit(exit_rc_map_imon_mce)
+module_init(init_rc_map_imon_mce);
+module_exit(exit_rc_map_imon_mce);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-imon-pad.c b/drivers/media/rc/keymaps/rc-imon-pad.c
index 63d42bd..3a5c088 100644
--- a/drivers/media/rc/keymaps/rc-imon-pad.c
+++ b/drivers/media/rc/keymaps/rc-imon-pad.c
@@ -149,8 +149,8 @@ static void __exit exit_rc_map_imon_pad(void)
 	rc_map_unregister(&imon_pad_map);
 }
 
-module_init(init_rc_map_imon_pad)
-module_exit(exit_rc_map_imon_pad)
+module_init(init_rc_map_imon_pad);
+module_exit(exit_rc_map_imon_pad);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
index 1f59e16..aae50c7 100644
--- a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
+++ b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
@@ -81,8 +81,8 @@ static void __exit exit_rc_map_iodata_bctv7e(void)
 	rc_map_unregister(&iodata_bctv7e_map);
 }
 
-module_init(init_rc_map_iodata_bctv7e)
-module_exit(exit_rc_map_iodata_bctv7e)
+module_init(init_rc_map_iodata_bctv7e);
+module_exit(exit_rc_map_iodata_bctv7e);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
index f31dc5c..1bba8b4 100644
--- a/drivers/media/rc/keymaps/rc-kaiomy.c
+++ b/drivers/media/rc/keymaps/rc-kaiomy.c
@@ -80,8 +80,8 @@ static void __exit exit_rc_map_kaiomy(void)
 	rc_map_unregister(&kaiomy_map);
 }
 
-module_init(init_rc_map_kaiomy)
-module_exit(exit_rc_map_kaiomy)
+module_init(init_rc_map_kaiomy);
+module_exit(exit_rc_map_kaiomy);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
index 7f33edb..e14731e 100644
--- a/drivers/media/rc/keymaps/rc-kworld-315u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-315u.c
@@ -76,8 +76,8 @@ static void __exit exit_rc_map_kworld_315u(void)
 	rc_map_unregister(&kworld_315u_map);
 }
 
-module_init(init_rc_map_kworld_315u)
-module_exit(exit_rc_map_kworld_315u)
+module_init(init_rc_map_kworld_315u);
+module_exit(exit_rc_map_kworld_315u);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
index 08d1831..543c632 100644
--- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -92,8 +92,8 @@ static void __exit exit_rc_map_kworld_plus_tv_analog(void)
 	rc_map_unregister(&kworld_plus_tv_analog_map);
 }
 
-module_init(init_rc_map_kworld_plus_tv_analog)
-module_exit(exit_rc_map_kworld_plus_tv_analog)
+module_init(init_rc_map_kworld_plus_tv_analog);
+module_exit(exit_rc_map_kworld_plus_tv_analog);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
index 8faa54ff..ac4dae7 100644
--- a/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
+++ b/drivers/media/rc/keymaps/rc-leadtek-y04g0051.c
@@ -92,8 +92,8 @@ static void __exit exit_rc_map_leadtek_y04g0051(void)
 	rc_map_unregister(&leadtek_y04g0051_map);
 }
 
-module_init(init_rc_map_leadtek_y04g0051)
-module_exit(exit_rc_map_leadtek_y04g0051)
+module_init(init_rc_map_leadtek_y04g0051);
+module_exit(exit_rc_map_leadtek_y04g0051);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-lirc.c b/drivers/media/rc/keymaps/rc-lirc.c
index e8e23e2..f15d6f4 100644
--- a/drivers/media/rc/keymaps/rc-lirc.c
+++ b/drivers/media/rc/keymaps/rc-lirc.c
@@ -34,8 +34,8 @@ static void __exit exit_rc_map_lirc(void)
 	rc_map_unregister(&lirc_map);
 }
 
-module_init(init_rc_map_lirc)
-module_exit(exit_rc_map_lirc)
+module_init(init_rc_map_lirc);
+module_exit(exit_rc_map_lirc);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-lme2510.c b/drivers/media/rc/keymaps/rc-lme2510.c
index afae14f..b8af71b 100644
--- a/drivers/media/rc/keymaps/rc-lme2510.c
+++ b/drivers/media/rc/keymaps/rc-lme2510.c
@@ -103,8 +103,8 @@ static void __exit exit_rc_lme2510_map(void)
 	rc_map_unregister(&lme2510_map);
 }
 
-module_init(init_rc_lme2510_map)
-module_exit(exit_rc_lme2510_map)
+module_init(init_rc_lme2510_map);
+module_exit(exit_rc_lme2510_map);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
diff --git a/drivers/media/rc/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
index 23b2d04..e4cad39 100644
--- a/drivers/media/rc/keymaps/rc-manli.c
+++ b/drivers/media/rc/keymaps/rc-manli.c
@@ -127,8 +127,8 @@ static void __exit exit_rc_map_manli(void)
 	rc_map_unregister(&manli_map);
 }
 
-module_init(init_rc_map_manli)
-module_exit(exit_rc_map_manli)
+module_init(init_rc_map_manli);
+module_exit(exit_rc_map_manli);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
index 7b9a01b..32ca664 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-ii.c
@@ -60,8 +60,8 @@ static void __exit exit_rc_map_msi_digivox_ii(void)
 	rc_map_unregister(&msi_digivox_ii_map);
 }
 
-module_init(init_rc_map_msi_digivox_ii)
-module_exit(exit_rc_map_msi_digivox_ii)
+module_init(init_rc_map_msi_digivox_ii);
+module_exit(exit_rc_map_msi_digivox_ii);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
index ae9d06b..b8900a2 100644
--- a/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
+++ b/drivers/media/rc/keymaps/rc-msi-digivox-iii.c
@@ -78,8 +78,8 @@ static void __exit exit_rc_map_msi_digivox_iii(void)
 	rc_map_unregister(&msi_digivox_iii_map);
 }
 
-module_init(init_rc_map_msi_digivox_iii)
-module_exit(exit_rc_map_msi_digivox_iii)
+module_init(init_rc_map_msi_digivox_iii);
+module_exit(exit_rc_map_msi_digivox_iii);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
index 8e9969d..27e86ef 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
@@ -116,8 +116,8 @@ static void __exit exit_rc_map_msi_tvanywhere_plus(void)
 	rc_map_unregister(&msi_tvanywhere_plus_map);
 }
 
-module_init(init_rc_map_msi_tvanywhere_plus)
-module_exit(exit_rc_map_msi_tvanywhere_plus)
+module_init(init_rc_map_msi_tvanywhere_plus);
+module_exit(exit_rc_map_msi_tvanywhere_plus);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
index fdd213f..30bab6a 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
@@ -62,8 +62,8 @@ static void __exit exit_rc_map_msi_tvanywhere(void)
 	rc_map_unregister(&msi_tvanywhere_map);
 }
 
-module_init(init_rc_map_msi_tvanywhere)
-module_exit(exit_rc_map_msi_tvanywhere)
+module_init(init_rc_map_msi_tvanywhere);
+module_exit(exit_rc_map_msi_tvanywhere);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
index ddae20e..08ce43f 100644
--- a/drivers/media/rc/keymaps/rc-nebula.c
+++ b/drivers/media/rc/keymaps/rc-nebula.c
@@ -89,8 +89,8 @@ static void __exit exit_rc_map_nebula(void)
 	rc_map_unregister(&nebula_map);
 }
 
-module_init(init_rc_map_nebula)
-module_exit(exit_rc_map_nebula)
+module_init(init_rc_map_nebula);
+module_exit(exit_rc_map_nebula);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
index 26f114c..484fb94 100644
--- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -98,8 +98,8 @@ static void __exit exit_rc_map_nec_terratec_cinergy_xs(void)
 	rc_map_unregister(&nec_terratec_cinergy_xs_map);
 }
 
-module_init(init_rc_map_nec_terratec_cinergy_xs)
-module_exit(exit_rc_map_nec_terratec_cinergy_xs)
+module_init(init_rc_map_nec_terratec_cinergy_xs);
+module_exit(exit_rc_map_nec_terratec_cinergy_xs);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
index f9f2fa2..fdbc13c 100644
--- a/drivers/media/rc/keymaps/rc-norwood.c
+++ b/drivers/media/rc/keymaps/rc-norwood.c
@@ -78,8 +78,8 @@ static void __exit exit_rc_map_norwood(void)
 	rc_map_unregister(&norwood_map);
 }
 
-module_init(init_rc_map_norwood)
-module_exit(exit_rc_map_norwood)
+module_init(init_rc_map_norwood);
+module_exit(exit_rc_map_norwood);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-npgtech.c b/drivers/media/rc/keymaps/rc-npgtech.c
index 4aa588b..5fddf27 100644
--- a/drivers/media/rc/keymaps/rc-npgtech.c
+++ b/drivers/media/rc/keymaps/rc-npgtech.c
@@ -73,8 +73,8 @@ static void __exit exit_rc_map_npgtech(void)
 	rc_map_unregister(&npgtech_map);
 }
 
-module_init(init_rc_map_npgtech)
-module_exit(exit_rc_map_npgtech)
+module_init(init_rc_map_npgtech);
+module_exit(exit_rc_map_npgtech);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
index 7cdef6e..15a752c 100644
--- a/drivers/media/rc/keymaps/rc-pctv-sedna.c
+++ b/drivers/media/rc/keymaps/rc-pctv-sedna.c
@@ -73,8 +73,8 @@ static void __exit exit_rc_map_pctv_sedna(void)
 	rc_map_unregister(&pctv_sedna_map);
 }
 
-module_init(init_rc_map_pctv_sedna)
-module_exit(exit_rc_map_pctv_sedna)
+module_init(init_rc_map_pctv_sedna);
+module_exit(exit_rc_map_pctv_sedna);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-color.c b/drivers/media/rc/keymaps/rc-pinnacle-color.c
index 23b8c50..f478e9a 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-color.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-color.c
@@ -87,8 +87,8 @@ static void __exit exit_rc_map_pinnacle_color(void)
 	rc_map_unregister(&pinnacle_color_map);
 }
 
-module_init(init_rc_map_pinnacle_color)
-module_exit(exit_rc_map_pinnacle_color)
+module_init(init_rc_map_pinnacle_color);
+module_exit(exit_rc_map_pinnacle_color);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-grey.c b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
index 6ba8c36..4a22bd3 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-grey.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
@@ -82,8 +82,8 @@ static void __exit exit_rc_map_pinnacle_grey(void)
 	rc_map_unregister(&pinnacle_grey_map);
 }
 
-module_init(init_rc_map_pinnacle_grey)
-module_exit(exit_rc_map_pinnacle_grey)
+module_init(init_rc_map_pinnacle_grey);
+module_exit(exit_rc_map_pinnacle_grey);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
index bb10ffe..4684da4 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
@@ -66,8 +66,8 @@ static void __exit exit_rc_map_pinnacle_pctv_hd(void)
 	rc_map_unregister(&pinnacle_pctv_hd_map);
 }
 
-module_init(init_rc_map_pinnacle_pctv_hd)
-module_exit(exit_rc_map_pinnacle_pctv_hd)
+module_init(init_rc_map_pinnacle_pctv_hd);
+module_exit(exit_rc_map_pinnacle_pctv_hd);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-002t.c b/drivers/media/rc/keymaps/rc-pixelview-002t.c
index e5ab071..06cca30 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-002t.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-002t.c
@@ -70,8 +70,8 @@ static void __exit exit_rc_map_pixelview(void)
 	rc_map_unregister(&pixelview_map);
 }
 
-module_init(init_rc_map_pixelview)
-module_exit(exit_rc_map_pixelview)
+module_init(init_rc_map_pixelview);
+module_exit(exit_rc_map_pixelview);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
index 125fc39..d231e65 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -76,8 +76,8 @@ static void __exit exit_rc_map_pixelview(void)
 	rc_map_unregister(&pixelview_map);
 }
 
-module_init(init_rc_map_pixelview)
-module_exit(exit_rc_map_pixelview)
+module_init(init_rc_map_pixelview);
+module_exit(exit_rc_map_pixelview);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
index bd78d6ac1..2528fa8 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -76,8 +76,8 @@ static void __exit exit_rc_map_pixelview_new(void)
 	rc_map_unregister(&pixelview_new_map);
 }
 
-module_init(init_rc_map_pixelview_new)
-module_exit(exit_rc_map_pixelview_new)
+module_init(init_rc_map_pixelview_new);
+module_exit(exit_rc_map_pixelview_new);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
index 06187e7..a3c9ad5 100644
--- a/drivers/media/rc/keymaps/rc-pixelview.c
+++ b/drivers/media/rc/keymaps/rc-pixelview.c
@@ -75,8 +75,8 @@ static void __exit exit_rc_map_pixelview(void)
 	rc_map_unregister(&pixelview_map);
 }
 
-module_init(init_rc_map_pixelview)
-module_exit(exit_rc_map_pixelview)
+module_init(init_rc_map_pixelview);
+module_exit(exit_rc_map_pixelview);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
index 5f9d546..f82624f 100644
--- a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
+++ b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
@@ -74,8 +74,8 @@ static void __exit exit_rc_map_powercolor_real_angel(void)
 	rc_map_unregister(&powercolor_real_angel_map);
 }
 
-module_init(init_rc_map_powercolor_real_angel)
-module_exit(exit_rc_map_powercolor_real_angel)
+module_init(init_rc_map_powercolor_real_angel);
+module_exit(exit_rc_map_powercolor_real_angel);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-proteus-2309.c b/drivers/media/rc/keymaps/rc-proteus-2309.c
index 8a3a643..7abeb31 100644
--- a/drivers/media/rc/keymaps/rc-proteus-2309.c
+++ b/drivers/media/rc/keymaps/rc-proteus-2309.c
@@ -62,8 +62,8 @@ static void __exit exit_rc_map_proteus_2309(void)
 	rc_map_unregister(&proteus_2309_map);
 }
 
-module_init(init_rc_map_proteus_2309)
-module_exit(exit_rc_map_proteus_2309)
+module_init(init_rc_map_proteus_2309);
+module_exit(exit_rc_map_proteus_2309);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-purpletv.c b/drivers/media/rc/keymaps/rc-purpletv.c
index ef90296..f198acb 100644
--- a/drivers/media/rc/keymaps/rc-purpletv.c
+++ b/drivers/media/rc/keymaps/rc-purpletv.c
@@ -74,8 +74,8 @@ static void __exit exit_rc_map_purpletv(void)
 	rc_map_unregister(&purpletv_map);
 }
 
-module_init(init_rc_map_purpletv)
-module_exit(exit_rc_map_purpletv)
+module_init(init_rc_map_purpletv);
+module_exit(exit_rc_map_purpletv);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
index 5e8beee..d6c785f 100644
--- a/drivers/media/rc/keymaps/rc-pv951.c
+++ b/drivers/media/rc/keymaps/rc-pv951.c
@@ -71,8 +71,8 @@ static void __exit exit_rc_map_pv951(void)
 	rc_map_unregister(&pv951_map);
 }
 
-module_init(init_rc_map_pv951)
-module_exit(exit_rc_map_pv951)
+module_init(init_rc_map_pv951);
+module_exit(exit_rc_map_pv951);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
index 8dd519e..c13ac9b 100644
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
index 6813d11..46822fe 100644
--- a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
+++ b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
@@ -71,8 +71,8 @@ static void __exit exit_rc_map_real_audio_220_32_keys(void)
 	rc_map_unregister(&real_audio_220_32_keys_map);
 }
 
-module_init(init_rc_map_real_audio_220_32_keys)
-module_exit(exit_rc_map_real_audio_220_32_keys)
+module_init(init_rc_map_real_audio_220_32_keys);
+module_exit(exit_rc_map_real_audio_220_32_keys);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-streamzap.c b/drivers/media/rc/keymaps/rc-streamzap.c
index 92cc10d..1ae9d00 100644
--- a/drivers/media/rc/keymaps/rc-streamzap.c
+++ b/drivers/media/rc/keymaps/rc-streamzap.c
@@ -75,8 +75,8 @@ static void __exit exit_rc_map_streamzap(void)
 	rc_map_unregister(&streamzap_map);
 }
 
-module_init(init_rc_map_streamzap)
-module_exit(exit_rc_map_streamzap)
+module_init(init_rc_map_streamzap);
+module_exit(exit_rc_map_streamzap);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
index 7242ee6..ac7d9d8 100644
--- a/drivers/media/rc/keymaps/rc-tbs-nec.c
+++ b/drivers/media/rc/keymaps/rc-tbs-nec.c
@@ -68,8 +68,8 @@ static void __exit exit_rc_map_tbs_nec(void)
 	rc_map_unregister(&tbs_nec_map);
 }
 
-module_init(init_rc_map_tbs_nec)
-module_exit(exit_rc_map_tbs_nec)
+module_init(init_rc_map_tbs_nec);
+module_exit(exit_rc_map_tbs_nec);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-technisat-usb2.c b/drivers/media/rc/keymaps/rc-technisat-usb2.c
index 4afe577..35c5f57 100644
--- a/drivers/media/rc/keymaps/rc-technisat-usb2.c
+++ b/drivers/media/rc/keymaps/rc-technisat-usb2.c
@@ -86,8 +86,8 @@ static void __exit exit_rc_map(void)
 	rc_map_unregister(&technisat_usb2_map);
 }
 
-module_init(init_rc_map)
-module_exit(exit_rc_map)
+module_init(init_rc_map);
+module_exit(exit_rc_map);
 
 MODULE_AUTHOR("Patrick Boettcher <pboettcher@kernellabs.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
index bc38e34..7cab96a 100644
--- a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
@@ -85,8 +85,8 @@ static void __exit exit_rc_map_terratec_cinergy_xs(void)
 	rc_map_unregister(&terratec_cinergy_xs_map);
 }
 
-module_init(init_rc_map_terratec_cinergy_xs)
-module_exit(exit_rc_map_terratec_cinergy_xs)
+module_init(init_rc_map_terratec_cinergy_xs);
+module_exit(exit_rc_map_terratec_cinergy_xs);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-terratec-slim-2.c b/drivers/media/rc/keymaps/rc-terratec-slim-2.c
index 4409391..3d8381a 100644
--- a/drivers/media/rc/keymaps/rc-terratec-slim-2.c
+++ b/drivers/media/rc/keymaps/rc-terratec-slim-2.c
@@ -65,8 +65,8 @@ static void __exit exit_rc_map_terratec_slim_2(void)
 	rc_map_unregister(&terratec_slim_2_map);
 }
 
-module_init(init_rc_map_terratec_slim_2)
-module_exit(exit_rc_map_terratec_slim_2)
+module_init(init_rc_map_terratec_slim_2);
+module_exit(exit_rc_map_terratec_slim_2);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-terratec-slim.c b/drivers/media/rc/keymaps/rc-terratec-slim.c
index 1abafa5..12fd7be 100644
--- a/drivers/media/rc/keymaps/rc-terratec-slim.c
+++ b/drivers/media/rc/keymaps/rc-terratec-slim.c
@@ -72,8 +72,8 @@ static void __exit exit_rc_map_terratec_slim(void)
 	rc_map_unregister(&terratec_slim_map);
 }
 
-module_init(init_rc_map_terratec_slim)
-module_exit(exit_rc_map_terratec_slim)
+module_init(init_rc_map_terratec_slim);
+module_exit(exit_rc_map_terratec_slim);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-tevii-nec.c b/drivers/media/rc/keymaps/rc-tevii-nec.c
index ef5ba3f3..4b83cdc 100644
--- a/drivers/media/rc/keymaps/rc-tevii-nec.c
+++ b/drivers/media/rc/keymaps/rc-tevii-nec.c
@@ -81,8 +81,8 @@ static void __exit exit_rc_map_tevii_nec(void)
 	rc_map_unregister(&tevii_nec_map);
 }
 
-module_init(init_rc_map_tevii_nec)
-module_exit(exit_rc_map_tevii_nec)
+module_init(init_rc_map_tevii_nec);
+module_exit(exit_rc_map_tevii_nec);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-total-media-in-hand.c b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
index 20ac4e1..06a732a 100644
--- a/drivers/media/rc/keymaps/rc-total-media-in-hand.c
+++ b/drivers/media/rc/keymaps/rc-total-media-in-hand.c
@@ -78,8 +78,8 @@ static void __exit exit_rc_map_total_media_in_hand(void)
 	rc_map_unregister(&total_media_in_hand_map);
 }
 
-module_init(init_rc_map_total_media_in_hand)
-module_exit(exit_rc_map_total_media_in_hand)
+module_init(init_rc_map_total_media_in_hand);
+module_exit(exit_rc_map_total_media_in_hand);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-trekstor.c b/drivers/media/rc/keymaps/rc-trekstor.c
index f8190ea..a965997 100644
--- a/drivers/media/rc/keymaps/rc-trekstor.c
+++ b/drivers/media/rc/keymaps/rc-trekstor.c
@@ -73,8 +73,8 @@ static void __exit exit_rc_map_trekstor(void)
 	rc_map_unregister(&trekstor_map);
 }
 
-module_init(init_rc_map_trekstor)
-module_exit(exit_rc_map_trekstor)
+module_init(init_rc_map_trekstor);
+module_exit(exit_rc_map_trekstor);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
diff --git a/drivers/media/rc/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
index 295f373..92b2460 100644
--- a/drivers/media/rc/keymaps/rc-tt-1500.c
+++ b/drivers/media/rc/keymaps/rc-tt-1500.c
@@ -75,8 +75,8 @@ static void __exit exit_rc_map_tt_1500(void)
 	rc_map_unregister(&tt_1500_map);
 }
 
-module_init(init_rc_map_tt_1500)
-module_exit(exit_rc_map_tt_1500)
+module_init(init_rc_map_tt_1500);
+module_exit(exit_rc_map_tt_1500);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-twinhan1027.c b/drivers/media/rc/keymaps/rc-twinhan1027.c
index 8bf8df6..17c8663 100644
--- a/drivers/media/rc/keymaps/rc-twinhan1027.c
+++ b/drivers/media/rc/keymaps/rc-twinhan1027.c
@@ -80,8 +80,8 @@ static void __exit exit_rc_map_twinhan_vp1027(void)
 	rc_map_unregister(&twinhan_vp1027_map);
 }
 
-module_init(init_rc_map_twinhan_vp1027)
-module_exit(exit_rc_map_twinhan_vp1027)
+module_init(init_rc_map_twinhan_vp1027);
+module_exit(exit_rc_map_twinhan_vp1027);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sergey Ivanov <123kash@gmail.com>");
diff --git a/drivers/media/rc/keymaps/rc-videomate-m1f.c b/drivers/media/rc/keymaps/rc-videomate-m1f.c
index 4994d40..f69e54a 100644
--- a/drivers/media/rc/keymaps/rc-videomate-m1f.c
+++ b/drivers/media/rc/keymaps/rc-videomate-m1f.c
@@ -85,8 +85,8 @@ static void __exit exit_rc_map_videomate_m1f(void)
 	rc_map_unregister(&videomate_m1f_map);
 }
 
-module_init(init_rc_map_videomate_m1f)
-module_exit(exit_rc_map_videomate_m1f)
+module_init(init_rc_map_videomate_m1f);
+module_exit(exit_rc_map_videomate_m1f);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pavel Osnova <pvosnova@gmail.com>");
diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
index 9e474a6..d912d72 100644
--- a/drivers/media/rc/keymaps/rc-videomate-s350.c
+++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
@@ -78,8 +78,8 @@ static void __exit exit_rc_map_videomate_s350(void)
 	rc_map_unregister(&videomate_s350_map);
 }
 
-module_init(init_rc_map_videomate_s350)
-module_exit(exit_rc_map_videomate_s350)
+module_init(init_rc_map_videomate_s350);
+module_exit(exit_rc_map_videomate_s350);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
index 5f2a46e1..38f8bbf 100644
--- a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
+++ b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
@@ -80,8 +80,8 @@ static void __exit exit_rc_map_videomate_tv_pvr(void)
 	rc_map_unregister(&videomate_tv_pvr_map);
 }
 
-module_init(init_rc_map_videomate_tv_pvr)
-module_exit(exit_rc_map_videomate_tv_pvr)
+module_init(init_rc_map_videomate_tv_pvr);
+module_exit(exit_rc_map_videomate_tv_pvr);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
index bd8d021..3f3914a 100644
--- a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
+++ b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
@@ -75,8 +75,8 @@ static void __exit exit_rc_map_winfast_usbii_deluxe(void)
 	rc_map_unregister(&winfast_usbii_deluxe_map);
 }
 
-module_init(init_rc_map_winfast_usbii_deluxe)
-module_exit(exit_rc_map_winfast_usbii_deluxe)
+module_init(init_rc_map_winfast_usbii_deluxe);
+module_exit(exit_rc_map_winfast_usbii_deluxe);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/rc/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
index 0062ca2..095ed14 100644
--- a/drivers/media/rc/keymaps/rc-winfast.c
+++ b/drivers/media/rc/keymaps/rc-winfast.c
@@ -95,8 +95,8 @@ static void __exit exit_rc_map_winfast(void)
 	rc_map_unregister(&winfast_map);
 }
 
-module_init(init_rc_map_winfast)
-module_exit(exit_rc_map_winfast)
+module_init(init_rc_map_winfast);
+module_exit(exit_rc_map_winfast);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 6dc7196..062f56f 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -786,8 +786,8 @@ static void __exit videodev_exit(void)
 	unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
 }
 
-module_init(videodev_init)
-module_exit(videodev_exit)
+module_init(videodev_init);
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
diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index d07cd67..6b1f3d0 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -265,8 +265,8 @@ static void __exit bh1780_exit(void)
 	i2c_del_driver(&bh1780_driver);
 }
 
-module_init(bh1780_init)
-module_exit(bh1780_exit)
+module_init(bh1780_init);
+module_exit(bh1780_exit);
 
 MODULE_DESCRIPTION("BH1780GLI Ambient Light Sensor Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/arcnet/arc-rimi.c b/drivers/net/arcnet/arc-rimi.c
index 9efbbba..e1daff6 100644
--- a/drivers/net/arcnet/arc-rimi.c
+++ b/drivers/net/arcnet/arc-rimi.c
@@ -393,5 +393,5 @@ static int __init arcrimi_setup(char *s)
 __setup("arcrimi=", arcrimi_setup);
 #endif				/* MODULE */
 
-module_init(arc_rimi_init)
-module_exit(arc_rimi_exit)
+module_init(arc_rimi_init);
+module_exit(arc_rimi_exit);
diff --git a/drivers/net/arcnet/com20020-isa.c b/drivers/net/arcnet/com20020-isa.c
index 3727282..1bbaf6b 100644
--- a/drivers/net/arcnet/com20020-isa.c
+++ b/drivers/net/arcnet/com20020-isa.c
@@ -216,5 +216,5 @@ __setup("com20020=", com20020isa_setup);
 
 #endif				/* MODULE */
 
-module_init(com20020_init)
-module_exit(com20020_exit)
+module_init(com20020_init);
+module_exit(com20020_exit);
diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 48a1dbf..8b8341a 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -191,5 +191,5 @@ static void __exit com20020pci_cleanup(void)
 	pci_unregister_driver(&com20020pci_driver);
 }
 
-module_init(com20020pci_init)
-module_exit(com20020pci_cleanup)
+module_init(com20020pci_init);
+module_exit(com20020pci_cleanup);
diff --git a/drivers/net/arcnet/com90io.c b/drivers/net/arcnet/com90io.c
index eb27976..ada4f44 100644
--- a/drivers/net/arcnet/com90io.c
+++ b/drivers/net/arcnet/com90io.c
@@ -428,5 +428,5 @@ static void __exit com90io_exit(void)
 	free_netdev(dev);
 }
 
-module_init(com90io_init)
-module_exit(com90io_exit)
+module_init(com90io_init);
+module_exit(com90io_exit);
diff --git a/drivers/net/arm/at91_ether.c b/drivers/net/arm/at91_ether.c
index e07b314..9d746e4 100644
--- a/drivers/net/arm/at91_ether.c
+++ b/drivers/net/arm/at91_ether.c
@@ -1244,8 +1244,8 @@ static void __exit at91ether_exit(void)
 	platform_driver_unregister(&at91ether_driver);
 }
 
-module_init(at91ether_init)
-module_exit(at91ether_exit)
+module_init(at91ether_init);
+module_exit(at91ether_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("AT91RM9200 EMAC Ethernet driver");
diff --git a/drivers/net/hp100.c b/drivers/net/hp100.c
index 8e10d2f..7d14b23 100644
--- a/drivers/net/hp100.c
+++ b/drivers/net/hp100.c
@@ -3066,5 +3066,5 @@ static void __exit hp100_module_exit(void)
 #endif
 }
 
-module_init(hp100_module_init)
-module_exit(hp100_module_exit)
+module_init(hp100_module_init);
+module_exit(hp100_module_exit);
diff --git a/drivers/net/tulip/xircom_cb.c b/drivers/net/tulip/xircom_cb.c
index 5a73752..1fc2dbf 100644
--- a/drivers/net/tulip/xircom_cb.c
+++ b/drivers/net/tulip/xircom_cb.c
@@ -1247,6 +1247,6 @@ static void __exit xircom_exit(void)
 	pci_unregister_driver(&xircom_ops);
 }
 
-module_init(xircom_init)
-module_exit(xircom_exit)
+module_init(xircom_init);
+module_exit(xircom_exit);
 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 5af40d9..5f4bd31 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5149,5 +5149,5 @@ static void __exit b43_exit(void)
 	b43_debugfs_exit();
 }
 
-module_init(b43_init)
-module_exit(b43_exit)
+module_init(b43_init);
+module_exit(b43_exit);
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index c7fd73e..aff8f11 100644
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
index 0b28fcc..8f14e1a 100644
--- a/drivers/parport/parport_atari.c
+++ b/drivers/parport/parport_atari.c
@@ -229,5 +229,5 @@ MODULE_DESCRIPTION("Parport Driver for Atari builtin Port");
 MODULE_SUPPORTED_DEVICE("Atari builtin Parallel Port");
 MODULE_LICENSE("GPL");
 
-module_init(parport_atari_init)
-module_exit(parport_atari_exit)
+module_init(parport_atari_init);
+module_exit(parport_atari_exit);
diff --git a/drivers/parport/parport_ax88796.c b/drivers/parport/parport_ax88796.c
index 2c5ac2b..a4a7393 100644
--- a/drivers/parport/parport_ax88796.c
+++ b/drivers/parport/parport_ax88796.c
@@ -430,8 +430,8 @@ static void __exit parport_ax88796_exit(void)
 	platform_driver_unregister(&axdrv);
 }
 
-module_init(parport_ax88796_init)
-module_exit(parport_ax88796_exit)
+module_init(parport_ax88796_init);
+module_exit(parport_ax88796_exit);
 
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("AX88796 Parport parallel port driver");
diff --git a/drivers/parport/parport_mfc3.c b/drivers/parport/parport_mfc3.c
index 362db31..8df7c11 100644
--- a/drivers/parport/parport_mfc3.c
+++ b/drivers/parport/parport_mfc3.c
@@ -401,5 +401,5 @@ MODULE_DESCRIPTION("Parport Driver for Multiface 3 expansion cards Paralllel Por
 MODULE_SUPPORTED_DEVICE("Multiface 3 Parallel Port");
 MODULE_LICENSE("GPL");
 
-module_init(parport_mfc3_init)
-module_exit(parport_mfc3_exit)
+module_init(parport_mfc3_init);
+module_exit(parport_mfc3_exit);
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index bc8ce48..171adee 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -3661,5 +3661,5 @@ static void __exit parport_pc_exit(void)
 MODULE_AUTHOR("Phil Blundell, Tim Waugh, others");
 MODULE_DESCRIPTION("PC-style parallel port driver");
 MODULE_LICENSE("GPL");
-module_init(parport_pc_init)
-module_exit(parport_pc_exit)
+module_init(parport_pc_init);
+module_exit(parport_pc_exit);
diff --git a/drivers/parport/parport_sunbpp.c b/drivers/parport/parport_sunbpp.c
index 910c5a2..9f9c34a 100644
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -407,5 +407,5 @@ MODULE_SUPPORTED_DEVICE("Sparc Bidirectional Parallel Port");
 MODULE_VERSION("2.0");
 MODULE_LICENSE("GPL");
 
-module_init(parport_sunbpp_init)
-module_exit(parport_sunbpp_exit)
+module_init(parport_sunbpp_init);
+module_exit(parport_sunbpp_exit);
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
index 6a29285..dcf0d87 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -695,7 +695,7 @@ static void __exit twlreg_exit(void)
 {
 	platform_driver_unregister(&twlreg_driver);
 }
-module_exit(twlreg_exit)
+module_exit(twlreg_exit);
 
 MODULE_DESCRIPTION("TWL regulator driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 54bdf6d..4e2ff5b 100644
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
index e05ba6e..a720edd 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1428,4 +1428,4 @@ static void __exit ssb_modexit(void)
 	b43_pci_ssb_bridge_exit();
 	bus_unregister(&ssb_bustype);
 }
-module_exit(ssb_modexit)
+module_exit(ssb_modexit);
diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index d207636..c1d2bfb 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -1213,6 +1213,6 @@ static void __exit alsa_card_intelmad_exit(void)
 	return platform_driver_unregister(&snd_intelmad_driver);
 }
 
-module_init(alsa_card_intelmad_init)
-module_exit(alsa_card_intelmad_exit)
+module_init(alsa_card_intelmad_init);
+module_exit(alsa_card_intelmad_exit);
 
diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 02525d5..45e1090 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -1119,6 +1119,6 @@ static void __exit rtsx_exit(void)
 	printk(KERN_INFO "%s module exit\n", CR_DRIVER_NAME);
 }
 
-module_init(rtsx_init)
-module_exit(rtsx_exit)
+module_init(rtsx_init);
+module_exit(rtsx_exit);
 
diff --git a/drivers/staging/zcache/zcache.c b/drivers/staging/zcache/zcache.c
index b8a2b30..d221622 100644
--- a/drivers/staging/zcache/zcache.c
+++ b/drivers/staging/zcache/zcache.c
@@ -1655,4 +1655,4 @@ out:
 	return ret;
 }
 
-module_init(zcache_init)
+module_init(zcache_init);
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 51fe179..2acb5a1 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -900,6 +900,6 @@ static void __exit uio_exit(void)
 	release_uio_class();
 }
 
-module_init(uio_init)
-module_exit(uio_exit)
+module_init(uio_init);
+module_exit(uio_exit);
 MODULE_LICENSE("GPL v2");
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index c82b017..04376d6 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -590,8 +590,8 @@ static void __exit exit_v9fs(void)
 	unregister_filesystem(&v9fs_fs_type);
 }
 
-module_init(init_v9fs)
-module_exit(exit_v9fs)
+module_init(init_v9fs);
+module_exit(exit_v9fs);
 
 MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
 MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index c8bf36a..aadc1da 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -538,6 +538,6 @@ static void __exit exit_adfs_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_adfs_fs)
-module_exit(exit_adfs_fs)
+module_init(init_adfs_fs);
+module_exit(exit_adfs_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/affs/super.c b/fs/affs/super.c
index b31507d..170338f 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -622,5 +622,5 @@ static void __exit exit_affs_fs(void)
 MODULE_DESCRIPTION("Amiga filesystem support for Linux");
 MODULE_LICENSE("GPL");
 
-module_init(init_affs_fs)
-module_exit(exit_affs_fs)
+module_init(init_affs_fs);
+module_exit(exit_affs_fs);
diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
index c038727..6a49620 100644
--- a/fs/autofs4/init.c
+++ b/fs/autofs4/init.c
@@ -47,5 +47,5 @@ static void __exit exit_autofs4_fs(void)
 }
 
 module_init(init_autofs4_fs) 
-module_exit(exit_autofs4_fs)
+module_exit(exit_autofs4_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 54b8c28..4a0ddfc 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -970,5 +970,5 @@ Macros that typecheck the init and exit functions,
 ensures that they are called at init and cleanup,
 and eliminates warnings about unused functions.
 */
-module_init(init_befs_fs)
-module_exit(exit_befs_fs)
+module_init(init_befs_fs);
+module_exit(exit_befs_fs);
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index a8e37f8..0781e56 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -492,5 +492,5 @@ static void __exit exit_bfs_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_bfs_fs)
-module_exit(exit_bfs_fs)
+module_init(init_bfs_fs);
+module_exit(exit_bfs_fs);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0ac712e..46c0de8 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1244,7 +1244,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_exit_compress();
 }
 
-module_init(init_btrfs_fs)
-module_exit(exit_btrfs_fs)
+module_init(init_btrfs_fs);
+module_exit(exit_btrfs_fs);
 
 MODULE_LICENSE("GPL");
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5c412b3..94c407b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1085,5 +1085,5 @@ MODULE_DESCRIPTION
     ("VFS to access servers complying with the SNIA CIFS Specification "
      "e.g. Samba and Windows");
 MODULE_VERSION(CIFS_VERSION);
-module_init(init_cifs)
-module_exit(exit_cifs)
+module_init(init_cifs);
+module_exit(exit_cifs);
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index e141939..9524de3 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -594,6 +594,6 @@ static void __exit exit_cramfs_fs(void)
 	unregister_filesystem(&cramfs_fs_type);
 }
 
-module_init(init_cramfs_fs)
-module_exit(exit_cramfs_fs)
+module_init(init_cramfs_fs);
+module_exit(exit_cramfs_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 2f27e57..9e69bfd 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -569,4 +569,4 @@ static int __init init_devpts_fs(void)
 	}
 	return err;
 }
-module_init(init_devpts_fs)
+module_init(init_devpts_fs);
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 89b93389..7b03101 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -918,5 +918,5 @@ MODULE_DESCRIPTION("eCryptfs");
 
 MODULE_LICENSE("GPL");
 
-module_init(ecryptfs_init)
-module_exit(ecryptfs_exit)
+module_init(ecryptfs_init);
+module_exit(ecryptfs_exit);
diff --git a/fs/efs/super.c b/fs/efs/super.c
index 0f31acb..52220cc 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -147,8 +147,8 @@ static void __exit exit_efs_fs(void) {
 	destroy_inodecache();
 }
 
-module_init(init_efs_fs)
-module_exit(exit_efs_fs)
+module_init(init_efs_fs);
+module_exit(exit_efs_fs);
 
 static efs_block_t efs_validate_vh(struct volume_header *vh) {
 	int		i;
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 06065bd..bab5f29 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -997,5 +997,5 @@ MODULE_AUTHOR("Avishay Traeger <avishay@gmail.com>");
 MODULE_DESCRIPTION("exofs");
 MODULE_LICENSE("GPL");
 
-module_init(init_exofs)
-module_exit(exit_exofs)
+module_init(init_exofs);
+module_exit(exit_exofs);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 0a78dae..dd0c621 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1520,5 +1520,5 @@ static void __exit exit_ext2_fs(void)
 	exit_ext2_xattr();
 }
 
-module_init(init_ext2_fs)
-module_exit(exit_ext2_fs)
+module_init(init_ext2_fs);
+module_exit(exit_ext2_fs);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 3c6a9e0..f4b7805 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -3078,5 +3078,5 @@ static void __exit exit_ext3_fs(void)
 MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
 MODULE_DESCRIPTION("Second Extended Filesystem with journaling extensions");
 MODULE_LICENSE("GPL");
-module_init(init_ext3_fs)
-module_exit(exit_ext3_fs)
+module_init(init_ext3_fs);
+module_exit(exit_ext3_fs);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8553dfb..4c277f7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4947,5 +4947,5 @@ static void __exit ext4_exit_fs(void)
 MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
 MODULE_DESCRIPTION("Fourth Extended Filesystem");
 MODULE_LICENSE("GPL");
-module_init(ext4_init_fs)
-module_exit(ext4_exit_fs)
+module_init(ext4_init_fs);
+module_exit(ext4_exit_fs);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 8d68690..4e13375 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1606,7 +1606,7 @@ static void __exit exit_fat_fs(void)
 	fat_destroy_inodecache();
 }
 
-module_init(init_fat_fs)
-module_exit(exit_fat_fs)
+module_init(init_fat_fs);
+module_exit(exit_fat_fs);
 
 MODULE_LICENSE("GPL");
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 7114990..fe81f76 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -698,5 +698,5 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Werner Almesberger");
 MODULE_DESCRIPTION("MS-DOS filesystem support");
 
-module_init(init_msdos_fs)
-module_exit(exit_msdos_fs)
+module_init(init_msdos_fs);
+module_exit(exit_msdos_fs);
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index adae3fb..6b73747 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1106,5 +1106,5 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("VFAT filesystem support");
 MODULE_AUTHOR("Gordon Chaffee");
 
-module_init(init_vfat_fs)
-module_exit(exit_vfat_fs)
+module_init(init_vfat_fs);
+module_exit(exit_vfat_fs);
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 22764c7..8a80c44 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -850,4 +850,4 @@ static int __init fcntl_init(void)
 	return 0;
 }
 
-module_init(fcntl_init)
+module_init(fcntl_init);
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 1b55f70..d46bad4 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -489,5 +489,5 @@ static void __exit exit_hfs_fs(void)
 	kmem_cache_destroy(hfs_inode_cachep);
 }
 
-module_init(init_hfs_fs)
-module_exit(exit_hfs_fs)
+module_init(init_hfs_fs);
+module_exit(exit_hfs_fs);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index b49b555..7c1261f 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -589,5 +589,5 @@ static void __exit exit_hfsplus_fs(void)
 	kmem_cache_destroy(hfsplus_inode_cachep);
 }
 
-module_init(init_hfsplus_fs)
-module_exit(exit_hfsplus_fs)
+module_init(init_hfsplus_fs);
+module_exit(exit_hfsplus_fs);
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 2638c834e..5fe7eb4 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -999,6 +999,6 @@ static void __exit exit_hostfs(void)
 	unregister_filesystem(&hostfs_type);
 }
 
-module_init(init_hostfs)
-module_exit(exit_hostfs)
+module_init(init_hostfs);
+module_exit(exit_hostfs);
 MODULE_LICENSE("GPL");
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 98580a3..41b49cd 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -707,6 +707,6 @@ static void __exit exit_hpfs_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_hpfs_fs)
-module_exit(exit_hpfs_fs)
+module_init(init_hpfs_fs);
+module_exit(exit_hpfs_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index 87ed48e..bd75295 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -780,6 +780,6 @@ static void __exit exit_hppfs(void)
 	unregister_filesystem(&hppfs_type);
 }
 
-module_init(init_hppfs)
-module_exit(exit_hppfs)
+module_init(init_hppfs);
+module_exit(exit_hppfs);
 MODULE_LICENSE("GPL");
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index b9eeb1c..15b6b6c 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1033,7 +1033,7 @@ static void __exit exit_hugetlbfs_fs(void)
 	bdi_destroy(&hugetlbfs_backing_dev_info);
 }
 
-module_init(init_hugetlbfs_fs)
-module_exit(exit_hugetlbfs_fs)
+module_init(init_hugetlbfs_fs);
+module_exit(exit_hugetlbfs_fs);
 
 MODULE_LICENSE("GPL");
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 3db5ba4..761bc45 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1571,8 +1571,8 @@ static void __exit exit_iso9660_fs(void)
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
index 06c8a67..fa77c68 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -897,5 +897,5 @@ static void __exit exit_jfs_fs(void)
 	kmem_cache_destroy(jfs_inode_cachep);
 }
 
-module_init(init_jfs_fs)
-module_exit(exit_jfs_fs)
+module_init(init_jfs_fs);
+module_exit(exit_jfs_fs);
diff --git a/fs/mbcache.c b/fs/mbcache.c
index 2f174be..bdc8933 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -613,6 +613,6 @@ static void __exit exit_mbcache(void)
 	unregister_shrinker(&mb_cache_shrinker);
 }
 
-module_init(init_mbcache)
-module_exit(exit_mbcache)
+module_init(init_mbcache);
+module_exit(exit_mbcache);
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index adcdc0a..a2eb8f9 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -655,7 +655,7 @@ static void __exit exit_minix_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_minix_fs)
-module_exit(exit_minix_fs)
+module_init(init_minix_fs);
+module_exit(exit_minix_fs);
 MODULE_LICENSE("GPL");
 
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 0250e4c..90b9231b 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -1069,6 +1069,6 @@ static void __exit exit_ncp_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_ncp_fs)
-module_exit(exit_ncp_fs)
+module_init(init_ncp_fs);
+module_exit(exit_ncp_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 57bb31a..cc9e2f7 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1645,5 +1645,5 @@ MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
 MODULE_LICENSE("GPL");
 module_param(enable_ino64, bool, 0644);
 
-module_init(init_nfs_fs)
-module_exit(exit_nfs_fs)
+module_init(init_nfs_fs);
+module_exit(exit_nfs_fs);
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 1f5eae4..30d3c91 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1530,5 +1530,5 @@ static void __exit exit_nfsd(void)
 
 MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
 MODULE_LICENSE("GPL");
-module_init(init_nfsd)
-module_exit(exit_nfsd)
+module_init(init_nfsd);
+module_exit(exit_nfsd);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 062cca0..bb93d63 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1329,5 +1329,5 @@ static void __exit exit_nilfs_fs(void)
 	unregister_filesystem(&nilfs_fs_type);
 }
 
-module_init(init_nilfs_fs)
-module_exit(exit_nilfs_fs)
+module_init(init_nilfs_fs);
+module_exit(exit_nilfs_fs);
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
index cc7f5fb..fa0bf36 100644
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
index e7bc1d75..8988308 100644
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
index b52706d..e55843d 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -3202,5 +3202,5 @@ module_param(debug_msgs, bool, 0);
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
index 8c5c0ed..2c51180 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -721,5 +721,5 @@ static void __exit exit_dlmfs_fs(void)
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
 
-module_init(init_dlmfs_fs)
-module_exit(exit_dlmfs_fs)
+module_init(init_dlmfs_fs);
+module_exit(exit_dlmfs_fs);
diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index a2a5bff..ff5a747 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -468,6 +468,6 @@ static void __exit exit_openprom_fs(void)
 	kmem_cache_destroy(op_inode_cachep);
 }
 
-module_init(init_openprom_fs)
-module_exit(exit_openprom_fs)
+module_init(init_openprom_fs);
+module_exit(exit_openprom_fs);
 MODULE_LICENSE("GPL");
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 74802bc5..049d6ec 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -652,4 +652,4 @@ static int __init vmcore_init(void)
 		proc_vmcore->size = vmcore_size;
 	return 0;
 }
-module_init(vmcore_init)
+module_init(vmcore_init);
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 977ed27..0da8706 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -305,7 +305,7 @@ static int __init init_pstore_fs(void)
 {
 	return register_filesystem(&pstore_fs_type);
 }
-module_init(init_pstore_fs)
+module_init(init_pstore_fs);
 
 MODULE_AUTHOR("Tony Luck <tony.luck@intel.com>");
 MODULE_LICENSE("GPL");
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 2b06466..8a308e8 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -498,7 +498,7 @@ static void __exit exit_qnx4_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_qnx4_fs)
-module_exit(exit_qnx4_fs)
+module_init(init_qnx4_fs);
+module_exit(exit_qnx4_fs);
 MODULE_LICENSE("GPL");
 
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index eacb166..d6c2f40 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -294,8 +294,8 @@ static void __exit exit_ramfs_fs(void)
 	unregister_filesystem(&ramfs_fs_type);
 }
 
-module_init(init_ramfs_fs)
-module_exit(exit_ramfs_fs)
+module_init(init_ramfs_fs);
+module_exit(exit_ramfs_fs);
 
 int __init init_rootfs(void)
 {
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index f60c196..c08e1e0 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -584,7 +584,7 @@ static void __exit exit_sysv_fs(void)
 	sysv_destroy_icache();
 }
 
-module_init(init_sysv_fs)
-module_exit(exit_sysv_fs)
+module_init(init_sysv_fs);
+module_exit(exit_sysv_fs);
 MODULE_ALIAS("v7");
 MODULE_LICENSE("GPL");
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 7b27b06..fb92184 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -234,8 +234,8 @@ static void __exit exit_udf_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_udf_fs)
-module_exit(exit_udf_fs)
+module_init(init_udf_fs);
+module_exit(exit_udf_fs);
 
 static int udf_sb_alloc_partition_maps(struct super_block *sb, u32 count)
 {
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 3915ade..fa685e2 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1506,6 +1506,6 @@ static void __exit exit_ufs_fs(void)
 	destroy_inodecache();
 }
 
-module_init(init_ufs_fs)
-module_exit(exit_ufs_fs)
+module_init(init_ufs_fs);
+module_exit(exit_ufs_fs);
 MODULE_LICENSE("GPL");
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 87b77de..e924817 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1213,7 +1213,7 @@ static int __init crash_notes_memory_init(void)
 	}
 	return 0;
 }
-module_init(crash_notes_memory_init)
+module_init(crash_notes_memory_init);
 
 
 /*
@@ -1487,7 +1487,7 @@ static int __init crash_save_vmcoreinfo_init(void)
 	return 0;
 }
 
-module_init(crash_save_vmcoreinfo_init)
+module_init(crash_save_vmcoreinfo_init);
 
 /*
  * Move into place and start executing a preloaded standalone
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 83326ad..a121158 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -547,7 +547,7 @@ static int __init hugepage_init(void)
 out:
 	return err;
 }
-module_init(hugepage_init)
+module_init(hugepage_init);
 
 static int __init setup_transparent_hugepage(char *str)
 {
diff --git a/mm/ksm.c b/mm/ksm.c
index 942dfc7..70dffaa 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2017,4 +2017,4 @@ out_free:
 out:
 	return err;
 }
-module_init(ksm_init)
+module_init(ksm_init);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9f8a97b..ae6ebe1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5134,7 +5134,7 @@ static int __init init_per_zone_wmark_min(void)
 	setup_per_zone_inactive_ratio();
 	return 0;
 }
-module_init(init_per_zone_wmark_min)
+module_init(init_per_zone_wmark_min);
 
 /*
  * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f6b435c..47733ce 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2874,7 +2874,7 @@ static int __init kswapd_init(void)
 	return 0;
 }
 
-module_init(kswapd_init)
+module_init(kswapd_init);
 
 #ifdef CONFIG_NUMA
 /*
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 897ea9e..f330d6c0e1 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1212,7 +1212,7 @@ static int __init setup_vmstat(void)
 #endif
 	return 0;
 }
-module_init(setup_vmstat)
+module_init(setup_vmstat);
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_COMPACTION)
 #include <linux/debugfs.h>
diff --git a/net/9p/mod.c b/net/9p/mod.c
index cf8a412..8f0bc5b 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -165,8 +165,8 @@ static void __exit exit_p9(void)
 	p9_trans_fd_exit();
 }
 
-module_init(init_p9)
-module_exit(exit_p9)
+module_init(init_p9);
+module_exit(exit_p9);
 
 MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
 MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 84bbb82..3d92780 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -100,7 +100,7 @@ static void __exit br_deinit(void)
 	br_fdb_fini();
 }
 
-module_init(br_init)
-module_exit(br_deinit)
+module_init(br_init);
+module_exit(br_deinit);
 MODULE_LICENSE("GPL");
 MODULE_VERSION(BR_VERSION);
diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index cfa7a5e..139852c 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -302,6 +302,6 @@ static void __exit exit_dns_resolver(void)
 	       key_type_dns_resolver.name);
 }
 
-module_init(init_dns_resolver)
-module_exit(exit_dns_resolver)
+module_init(init_dns_resolver);
+module_exit(exit_dns_resolver);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index 8be8872..5d19eec 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -300,7 +300,7 @@ static void __exit exit_basic(void)
 	unregister_tcf_proto_ops(&cls_basic_ops);
 }
 
-module_init(init_basic)
-module_exit(exit_basic)
+module_init(init_basic);
+module_exit(exit_basic);
 MODULE_LICENSE("GPL");
 
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index 26e7bc4..9df683a 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -394,6 +394,6 @@ static void __exit exit_fw(void)
 	unregister_tcf_proto_ops(&cls_fw_ops);
 }
 
-module_init(init_fw)
-module_exit(exit_fw)
+module_init(init_fw);
+module_exit(exit_fw);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index a9079053..6ad7c3c 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -622,6 +622,6 @@ static void __exit exit_route4(void)
 	unregister_tcf_proto_ops(&cls_route4_ops);
 }
 
-module_init(init_route4)
-module_exit(exit_route4)
+module_init(init_route4);
+module_exit(exit_route4);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index 402c44b..1cca93e 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -667,5 +667,5 @@ static void __exit exit_rsvp(void)
 	unregister_tcf_proto_ops(&RSVP_OPS);
 }
 
-module_init(init_rsvp)
-module_exit(exit_rsvp)
+module_init(init_rsvp);
+module_exit(exit_rsvp);
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 36667fa..7a9d980 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -502,6 +502,6 @@ static void __exit exit_tcindex(void)
 	unregister_tcf_proto_ops(&cls_tcindex_ops);
 }
 
-module_init(init_tcindex)
-module_exit(exit_tcindex)
+module_init(init_tcindex);
+module_exit(exit_tcindex);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 3b93fc0..e2daad5 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -812,6 +812,6 @@ static void __exit exit_u32(void)
 	unregister_tcf_proto_ops(&cls_u32_ops);
 }
 
-module_init(init_u32)
-module_exit(exit_u32)
+module_init(init_u32);
+module_exit(exit_u32);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 3f08158..4fdb88d 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -685,6 +685,6 @@ static void __exit atm_exit(void)
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
index 24d94c0..6c9b60d 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -2070,6 +2070,6 @@ static void __exit cbq_module_exit(void)
 {
 	unregister_qdisc(&cbq_qdisc_ops);
 }
-module_init(cbq_module_init)
-module_exit(cbq_module_exit)
+module_init(cbq_module_init);
+module_exit(cbq_module_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index 06afbae..426403e 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -682,7 +682,7 @@ static void __exit choke_module_exit(void)
 	unregister_qdisc(&choke_qdisc_ops);
 }
 
-module_init(choke_module_init)
-module_exit(choke_module_exit)
+module_init(choke_module_init);
+module_exit(choke_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 2c79020..efcd3f7 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -503,7 +503,7 @@ static void __exit dsmark_module_exit(void)
 	unregister_qdisc(&dsmark_qdisc_ops);
 }
 
-module_init(dsmark_module_init)
-module_exit(dsmark_module_exit)
+module_init(dsmark_module_init);
+module_exit(dsmark_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index b9493a0..cad5b68 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -602,7 +602,7 @@ static void __exit gred_module_exit(void)
 	unregister_qdisc(&gred_qdisc_ops);
 }
 
-module_init(gred_module_init)
-module_exit(gred_module_exit)
+module_init(gred_module_init);
+module_exit(gred_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 29b942c..af6393e 100644
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
index edc1950..9f5558f 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -435,7 +435,7 @@ static void __exit multiq_module_exit(void)
 	unregister_qdisc(&multiq_qdisc_ops);
 }
 
-module_init(multiq_module_init)
-module_exit(multiq_module_exit)
+module_init(multiq_module_init);
+module_exit(multiq_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 69c35f6..f6dd6a6 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -971,6 +971,6 @@ static void __exit netem_module_exit(void)
 {
 	unregister_qdisc(&netem_qdisc_ops);
 }
-module_init(netem_module_init)
-module_exit(netem_module_exit)
+module_init(netem_module_init);
+module_exit(netem_module_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 2a318f2..66211d8 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -399,7 +399,7 @@ static void __exit prio_module_exit(void)
 	unregister_qdisc(&prio_qdisc_ops);
 }
 
-module_init(prio_module_init)
-module_exit(prio_module_exit)
+module_init(prio_module_init);
+module_exit(prio_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 6649463..43f36bb 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -353,7 +353,7 @@ static void __exit red_module_exit(void)
 	unregister_qdisc(&red_qdisc_ops);
 }
 
-module_init(red_module_init)
-module_exit(red_module_exit)
+module_init(red_module_init);
+module_exit(red_module_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 0a833d0..2426ef9 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -700,8 +700,8 @@ static void __exit sfb_module_exit(void)
 	unregister_qdisc(&sfb_qdisc_ops);
 }
 
-module_init(sfb_module_init)
-module_exit(sfb_module_exit)
+module_init(sfb_module_init);
+module_exit(sfb_module_exit);
 
 MODULE_DESCRIPTION("Stochastic Fair Blue queue discipline");
 MODULE_AUTHOR("Juliusz Chroboczek");
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index c2e628d..8ce6063 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -720,6 +720,6 @@ static void __exit sfq_module_exit(void)
 {
 	unregister_qdisc(&sfq_qdisc_ops);
 }
-module_init(sfq_module_init)
-module_exit(sfq_module_exit)
+module_init(sfq_module_init);
+module_exit(sfq_module_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 1dcfb52..5cf2209 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -459,6 +459,6 @@ static void __exit tbf_module_exit(void)
 {
 	unregister_qdisc(&tbf_qdisc_ops);
 }
-module_init(tbf_module_init)
-module_exit(tbf_module_exit)
+module_init(tbf_module_init);
+module_exit(tbf_module_exit);
 MODULE_LICENSE("GPL");
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 339ba64..c6c961d 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1642,5 +1642,5 @@ module_param_named(expired_cred_retry_delay,
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
index a70ee7f..5baa167 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -523,7 +523,7 @@ static void __exit alsa_hwdep_exit(void)
 	snd_hwdep_proc_done();
 }
 
-module_init(alsa_hwdep_init)
-module_exit(alsa_hwdep_exit)
+module_init(alsa_hwdep_init);
+module_exit(alsa_hwdep_exit);
 
 EXPORT_SYMBOL(snd_hwdep_new);
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 16bd9c0..fd2159e 100644
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
index d8359cf..91549ee 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -1408,7 +1408,7 @@ static void __exit alsa_mixer_oss_exit(void)
 	}
 }
 
-module_init(alsa_mixer_oss_init)
-module_exit(alsa_mixer_oss_exit)
+module_init(alsa_mixer_oss_init);
+module_exit(alsa_mixer_oss_exit);
 
 EXPORT_SYMBOL(snd_mixer_oss_ioctl_card);
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 23c34a0..082015c 100644
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
index ee9abb2..3ca5b37 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1166,5 +1166,5 @@ static void __exit alsa_pcm_exit(void)
 	snd_pcm_proc_done();
 }
 
-module_init(alsa_pcm_init)
-module_exit(alsa_pcm_exit)
+module_init(alsa_pcm_init);
+module_exit(alsa_pcm_exit);
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index cbbed0d..e544cfaa 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -1695,8 +1695,8 @@ static void __exit alsa_rawmidi_exit(void)
 	snd_ctl_unregister_ioctl_compat(snd_rawmidi_control_ioctl);
 }
 
-module_init(alsa_rawmidi_init)
-module_exit(alsa_rawmidi_exit)
+module_init(alsa_rawmidi_init);
+module_exit(alsa_rawmidi_exit);
 
 EXPORT_SYMBOL(snd_rawmidi_output_params);
 EXPORT_SYMBOL(snd_rawmidi_input_params);
diff --git a/sound/core/rtctimer.c b/sound/core/rtctimer.c
index 0851cd1..cdb2b28 100644
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
index a1f1a2f..564a4b7 100644
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
index 119fddb6..f600927 100644
--- a/sound/core/seq/seq.c
+++ b/sound/core/seq/seq.c
@@ -132,5 +132,5 @@ static void __exit alsa_seq_exit(void)
 	snd_sequencer_memory_done();
 }
 
-module_init(alsa_seq_init)
-module_exit(alsa_seq_exit)
+module_init(alsa_seq_init);
+module_exit(alsa_seq_exit);
diff --git a/sound/core/seq/seq_device.c b/sound/core/seq/seq_device.c
index 1f99767..4be8a51 100644
--- a/sound/core/seq/seq_device.c
+++ b/sound/core/seq/seq_device.c
@@ -561,8 +561,8 @@ static void __exit alsa_seq_device_exit(void)
 		snd_printk(KERN_ERR "drivers not released (%d)\n", num_ops);
 }
 
-module_init(alsa_seq_device_init)
-module_exit(alsa_seq_device_exit)
+module_init(alsa_seq_device_init);
+module_exit(alsa_seq_device_exit);
 
 EXPORT_SYMBOL(snd_seq_device_load_drivers);
 EXPORT_SYMBOL(snd_seq_device_new);
diff --git a/sound/core/seq/seq_dummy.c b/sound/core/seq/seq_dummy.c
index 1d7d90c..d985553 100644
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
index ebaf1b5..60b08c8 100644
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
index 07c6631..f8bad3d 100644
--- a/sound/core/seq/seq_midi_emul.c
+++ b/sound/core/seq/seq_midi_emul.c
@@ -730,8 +730,8 @@ static void __exit alsa_seq_midi_emul_exit(void)
 {
 }
 
-module_init(alsa_seq_midi_emul_init)
-module_exit(alsa_seq_midi_emul_exit)
+module_init(alsa_seq_midi_emul_init);
+module_exit(alsa_seq_midi_emul_exit);
 
 EXPORT_SYMBOL(snd_midi_process_event);
 EXPORT_SYMBOL(snd_midi_channel_set_clear);
diff --git a/sound/core/seq/seq_midi_event.c b/sound/core/seq/seq_midi_event.c
index b5d6ea4..133339f 100644
--- a/sound/core/seq/seq_midi_event.c
+++ b/sound/core/seq/seq_midi_event.c
@@ -545,5 +545,5 @@ static void __exit alsa_seq_midi_event_exit(void)
 {
 }
 
-module_init(alsa_seq_midi_event_init)
-module_exit(alsa_seq_midi_event_exit)
+module_init(alsa_seq_midi_event_init);
+module_exit(alsa_seq_midi_event_exit);
diff --git a/sound/core/seq/seq_virmidi.c b/sound/core/seq/seq_virmidi.c
index 86e7739..1f4e75a 100644
--- a/sound/core/seq/seq_virmidi.c
+++ b/sound/core/seq/seq_virmidi.c
@@ -536,7 +536,7 @@ static void __exit alsa_virmidi_exit(void)
 {
 }
 
-module_init(alsa_virmidi_init)
-module_exit(alsa_virmidi_exit)
+module_init(alsa_virmidi_init);
+module_exit(alsa_virmidi_exit);
 
 EXPORT_SYMBOL(snd_virmidi_new);
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 7c1cbf0..01befe1 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1975,8 +1975,8 @@ static void __exit alsa_timer_exit(void)
 #endif
 }
 
-module_init(alsa_timer_init)
-module_exit(alsa_timer_exit)
+module_init(alsa_timer_init);
+module_exit(alsa_timer_exit);
 
 EXPORT_SYMBOL(snd_timer_open);
 EXPORT_SYMBOL(snd_timer_close);
diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index a0da775..7aa114d 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1253,5 +1253,5 @@ static void __exit alsa_card_loopback_exit(void)
 	loopback_unregister_all();
 }
 
-module_init(alsa_card_loopback_init)
-module_exit(alsa_card_loopback_exit)
+module_init(alsa_card_loopback_init);
+module_exit(alsa_card_loopback_exit);
diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 7f41990..379de25 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -1153,5 +1153,5 @@ static void __exit alsa_card_dummy_exit(void)
 	snd_dummy_unregister_all();
 }
 
-module_init(alsa_card_dummy_init)
-module_exit(alsa_card_dummy_exit)
+module_init(alsa_card_dummy_init);
+module_exit(alsa_card_dummy_exit);
diff --git a/sound/drivers/ml403-ac97cr.c b/sound/drivers/ml403-ac97cr.c
index 5cfcb90..06fd3fa 100644
--- a/sound/drivers/ml403-ac97cr.c
+++ b/sound/drivers/ml403-ac97cr.c
@@ -1351,5 +1351,5 @@ static void __exit alsa_card_ml403_ac97cr_exit(void)
 	platform_driver_unregister(&snd_ml403_ac97cr_driver);
 }
 
-module_init(alsa_card_ml403_ac97cr_init)
-module_exit(alsa_card_ml403_ac97cr_exit)
+module_init(alsa_card_ml403_ac97cr_init);
+module_exit(alsa_card_ml403_ac97cr_exit);
diff --git a/sound/drivers/mpu401/mpu401.c b/sound/drivers/mpu401/mpu401.c
index 149d05a..c0f40bf 100644
--- a/sound/drivers/mpu401/mpu401.c
+++ b/sound/drivers/mpu401/mpu401.c
@@ -285,5 +285,5 @@ static void __exit alsa_card_mpu401_exit(void)
 	snd_mpu401_unregister_all();
 }
 
-module_init(alsa_card_mpu401_init)
-module_exit(alsa_card_mpu401_exit)
+module_init(alsa_card_mpu401_init);
+module_exit(alsa_card_mpu401_exit);
diff --git a/sound/drivers/mpu401/mpu401_uart.c b/sound/drivers/mpu401/mpu401_uart.c
index 2af0999..b655cc9 100644
--- a/sound/drivers/mpu401/mpu401_uart.c
+++ b/sound/drivers/mpu401/mpu401_uart.c
@@ -627,5 +627,5 @@ static void __exit alsa_mpu401_uart_exit(void)
 {
 }
 
-module_init(alsa_mpu401_uart_init)
-module_exit(alsa_mpu401_uart_exit)
+module_init(alsa_mpu401_uart_init);
+module_exit(alsa_mpu401_uart_exit);
diff --git a/sound/drivers/mtpav.c b/sound/drivers/mtpav.c
index 5c426df..a716221 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -787,5 +787,5 @@ static void __exit alsa_card_mtpav_exit(void)
 	platform_driver_unregister(&snd_mtpav_driver);
 }
 
-module_init(alsa_card_mtpav_init)
-module_exit(alsa_card_mtpav_exit)
+module_init(alsa_card_mtpav_init);
+module_exit(alsa_card_mtpav_exit);
diff --git a/sound/drivers/opl3/opl3_lib.c b/sound/drivers/opl3/opl3_lib.c
index 6e31e46..7ed35e7 100644
--- a/sound/drivers/opl3/opl3_lib.c
+++ b/sound/drivers/opl3/opl3_lib.c
@@ -556,5 +556,5 @@ static void __exit alsa_opl3_exit(void)
 {
 }
 
-module_init(alsa_opl3_init)
-module_exit(alsa_opl3_exit)
+module_init(alsa_opl3_init);
+module_exit(alsa_opl3_exit);
diff --git a/sound/drivers/opl3/opl3_seq.c b/sound/drivers/opl3/opl3_seq.c
index 2d33f53..3420d62 100644
--- a/sound/drivers/opl3/opl3_seq.c
+++ b/sound/drivers/opl3/opl3_seq.c
@@ -293,5 +293,5 @@ static void __exit alsa_opl3_seq_exit(void)
 	snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_OPL3);
 }
 
-module_init(alsa_opl3_seq_init)
-module_exit(alsa_opl3_seq_exit)
+module_init(alsa_opl3_seq_init);
+module_exit(alsa_opl3_seq_exit);
diff --git a/sound/drivers/opl4/opl4_lib.c b/sound/drivers/opl4/opl4_lib.c
index f07e38d..44ad4a8 100644
--- a/sound/drivers/opl4/opl4_lib.c
+++ b/sound/drivers/opl4/opl4_lib.c
@@ -276,5 +276,5 @@ static void __exit alsa_opl4_exit(void)
 {
 }
 
-module_init(alsa_opl4_init)
-module_exit(alsa_opl4_exit)
+module_init(alsa_opl4_init);
+module_exit(alsa_opl4_exit);
diff --git a/sound/drivers/opl4/opl4_seq.c b/sound/drivers/opl4/opl4_seq.c
index 43d8a2b..9daa525 100644
--- a/sound/drivers/opl4/opl4_seq.c
+++ b/sound/drivers/opl4/opl4_seq.c
@@ -210,5 +210,5 @@ static void __exit alsa_opl4_synth_exit(void)
 	snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_OPL4);
 }
 
-module_init(alsa_opl4_synth_init)
-module_exit(alsa_opl4_synth_exit)
+module_init(alsa_opl4_synth_init);
+module_exit(alsa_opl4_synth_exit);
diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
index a25fb7b..40d4c59 100644
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
index f4cd493..713ab93 100644
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
index 19c6e37..75ca9af 100644
--- a/sound/drivers/vx/vx_core.c
+++ b/sound/drivers/vx/vx_core.c
@@ -823,5 +823,5 @@ static void __exit alsa_vx_core_exit(void)
 {
 }
 
-module_init(alsa_vx_core_init)
-module_exit(alsa_vx_core_exit)
+module_init(alsa_vx_core_init);
+module_exit(alsa_vx_core_exit);
diff --git a/sound/i2c/cs8427.c b/sound/i2c/cs8427.c
index 04ae870..7ea6e70 100644
--- a/sound/i2c/cs8427.c
+++ b/sound/i2c/cs8427.c
@@ -611,5 +611,5 @@ static void __exit alsa_cs8427_module_exit(void)
 {
 }
 
-module_init(alsa_cs8427_module_init)
-module_exit(alsa_cs8427_module_exit)
+module_init(alsa_cs8427_module_init);
+module_exit(alsa_cs8427_module_exit);
diff --git a/sound/i2c/i2c.c b/sound/i2c/i2c.c
index eb7c7d0..fc7f419 100644
--- a/sound/i2c/i2c.c
+++ b/sound/i2c/i2c.c
@@ -348,5 +348,5 @@ static void __exit alsa_i2c_exit(void)
 {
 }
 
-module_init(alsa_i2c_init)
-module_exit(alsa_i2c_exit)
+module_init(alsa_i2c_init);
+module_exit(alsa_i2c_exit);
diff --git a/sound/i2c/other/ak4xxx-adda.c b/sound/i2c/other/ak4xxx-adda.c
index 57ccba8..beb287a 100644
--- a/sound/i2c/other/ak4xxx-adda.c
+++ b/sound/i2c/other/ak4xxx-adda.c
@@ -940,5 +940,5 @@ static void __exit alsa_akm4xxx_module_exit(void)
 {
 }
         
-module_init(alsa_akm4xxx_module_init)
-module_exit(alsa_akm4xxx_module_exit)
+module_init(alsa_akm4xxx_module_init);
+module_exit(alsa_akm4xxx_module_exit);
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index ee538f1..eab8f98 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -358,8 +358,8 @@ static void __exit alsa_tea575x_module_exit(void)
 {
 }
 
-module_init(alsa_tea575x_module_init)
-module_exit(alsa_tea575x_module_exit)
+module_init(alsa_tea575x_module_init);
+module_exit(alsa_tea575x_module_exit);
 
 EXPORT_SYMBOL(snd_tea575x_init);
 EXPORT_SYMBOL(snd_tea575x_exit);
diff --git a/sound/i2c/tea6330t.c b/sound/i2c/tea6330t.c
index 0e3a9f2..2be283e 100644
--- a/sound/i2c/tea6330t.c
+++ b/sound/i2c/tea6330t.c
@@ -381,5 +381,5 @@ static void __exit alsa_tea6330t_exit(void)
 {
 }
 
-module_init(alsa_tea6330t_init)
-module_exit(alsa_tea6330t_exit)
+module_init(alsa_tea6330t_init);
+module_exit(alsa_tea6330t_exit);
diff --git a/sound/isa/ad1816a/ad1816a.c b/sound/isa/ad1816a/ad1816a.c
index 3cb75bc..da24045 100644
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
index 20becc8..fd52730 100644
--- a/sound/isa/als100.c
+++ b/sound/isa/als100.c
@@ -375,5 +375,5 @@ static void __exit alsa_card_als100_exit(void)
 	pnp_unregister_card_driver(&als100_pnpc_driver);
 }
 
-module_init(alsa_card_als100_init)
-module_exit(alsa_card_als100_exit)
+module_init(alsa_card_als100_init);
+module_exit(alsa_card_als100_exit);
diff --git a/sound/isa/azt2320.c b/sound/isa/azt2320.c
index aac8dc1..c66740f 100644
--- a/sound/isa/azt2320.c
+++ b/sound/isa/azt2320.c
@@ -351,5 +351,5 @@ static void __exit alsa_card_azt2320_exit(void)
 	pnp_unregister_card_driver(&azt2320_pnpc_driver);
 }
 
-module_init(alsa_card_azt2320_init)
-module_exit(alsa_card_azt2320_exit)
+module_init(alsa_card_azt2320_init);
+module_exit(alsa_card_azt2320_exit);
diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index fe79a16..264a7a2 100644
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
index 999dc1e..7a47688 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -725,5 +725,5 @@ static void __exit alsa_card_cs423x_exit(void)
 		isa_unregister_driver(&cs423x_isa_driver);
 }
 
-module_init(alsa_card_cs423x_init)
-module_exit(alsa_card_cs423x_exit)
+module_init(alsa_card_cs423x_init);
+module_exit(alsa_card_cs423x_exit);
diff --git a/sound/isa/es1688/es1688_lib.c b/sound/isa/es1688/es1688_lib.c
index 0767620..636546c 100644
--- a/sound/isa/es1688/es1688_lib.c
+++ b/sound/isa/es1688/es1688_lib.c
@@ -1041,5 +1041,5 @@ static void __exit alsa_es1688_exit(void)
 {
 }
 
-module_init(alsa_es1688_init)
-module_exit(alsa_es1688_exit)
+module_init(alsa_es1688_init);
+module_exit(alsa_es1688_exit);
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index fb4d6b3..31d337e 100644
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
index 12eb98f..ec1ea9c 100644
--- a/sound/isa/gus/gus_main.c
+++ b/sound/isa/gus/gus_main.c
@@ -478,5 +478,5 @@ static void __exit alsa_gus_exit(void)
 {
 }
 
-module_init(alsa_gus_init)
-module_exit(alsa_gus_exit)
+module_init(alsa_gus_init);
+module_exit(alsa_gus_exit);
diff --git a/sound/isa/gus/gusmax.c b/sound/isa/gus/gusmax.c
index 3e4a58b..f4d2f84 100644
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
index c7b80e4..783bd98 100644
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
index 9b915e2..625fbbd 100644
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -966,5 +966,5 @@ static void __exit alsa_card_opl3sa2_exit(void)
 		isa_unregister_driver(&snd_opl3sa2_isa_driver);
 }
 
-module_init(alsa_card_opl3sa2_init)
-module_exit(alsa_card_opl3sa2_exit)
+module_init(alsa_card_opl3sa2_init);
+module_exit(alsa_card_opl3sa2_exit);
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index 8c24102..31a245d 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -1677,5 +1677,5 @@ static void __exit alsa_card_miro_exit(void)
 #endif
 }
 
-module_init(alsa_card_miro_init)
-module_exit(alsa_card_miro_exit)
+module_init(alsa_card_miro_init);
+module_exit(alsa_card_miro_exit);
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index c35dc68..4bcce68 100644
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
index 0c7905c..c301809 100644
--- a/sound/isa/sb/emu8000_synth.c
+++ b/sound/isa/sb/emu8000_synth.c
@@ -131,5 +131,5 @@ static void __exit alsa_emu8000_exit(void)
 	snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_EMU8000);
 }
 
-module_init(alsa_emu8000_init)
-module_exit(alsa_emu8000_exit)
+module_init(alsa_emu8000_init);
+module_exit(alsa_emu8000_exit);
diff --git a/sound/isa/sb/jazz16.c b/sound/isa/sb/jazz16.c
index 8ccbcdd..1cec8da 100644
--- a/sound/isa/sb/jazz16.c
+++ b/sound/isa/sb/jazz16.c
@@ -401,5 +401,5 @@ static void __exit alsa_card_jazz16_exit(void)
 	isa_unregister_driver(&snd_jazz16_driver);
 }
 
-module_init(alsa_card_jazz16_init)
-module_exit(alsa_card_jazz16_exit)
+module_init(alsa_card_jazz16_init);
+module_exit(alsa_card_jazz16_exit);
diff --git a/sound/isa/sb/sb16.c b/sound/isa/sb/sb16.c
index 4d1c5a3..82c5b63 100644
--- a/sound/isa/sb/sb16.c
+++ b/sound/isa/sb/sb16.c
@@ -694,5 +694,5 @@ static void __exit alsa_card_sb16_exit(void)
 		isa_unregister_driver(&snd_sb16_isa_driver);
 }
 
-module_init(alsa_card_sb16_init)
-module_exit(alsa_card_sb16_exit)
+module_init(alsa_card_sb16_init);
+module_exit(alsa_card_sb16_exit);
diff --git a/sound/isa/sb/sb16_csp.c b/sound/isa/sb/sb16_csp.c
index bdc8dde4..e5b475d 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -1197,5 +1197,5 @@ static void __exit alsa_sb_csp_exit(void)
 {
 }
 
-module_init(alsa_sb_csp_init)
-module_exit(alsa_sb_csp_exit)
+module_init(alsa_sb_csp_init);
+module_exit(alsa_sb_csp_exit);
diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index 2a6cc1c..ced1a0d 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -920,5 +920,5 @@ static void __exit alsa_sb16_exit(void)
 {
 }
 
-module_init(alsa_sb16_init)
-module_exit(alsa_sb16_exit)
+module_init(alsa_sb16_init);
+module_exit(alsa_sb16_exit);
diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
index 2259e3f..f978fb9 100644
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
index 7d84c9f..5e03669 100644
--- a/sound/isa/sb/sb8_main.c
+++ b/sound/isa/sb/sb8_main.c
@@ -641,5 +641,5 @@ static void __exit alsa_sb8_exit(void)
 {
 }
 
-module_init(alsa_sb8_init)
-module_exit(alsa_sb8_exit)
+module_init(alsa_sb8_init);
+module_exit(alsa_sb8_exit);
diff --git a/sound/isa/sb/sb_common.c b/sound/isa/sb/sb_common.c
index eae6c1c..f857986 100644
--- a/sound/isa/sb/sb_common.c
+++ b/sound/isa/sb/sb_common.c
@@ -319,5 +319,5 @@ static void __exit alsa_sb_common_exit(void)
 {
 }
 
-module_init(alsa_sb_common_init)
-module_exit(alsa_sb_common_exit)
+module_init(alsa_sb_common_init);
+module_exit(alsa_sb_common_exit);
diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index 9a8bbf6..e0d32c9 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -725,5 +725,5 @@ static void __exit alsa_card_sc6000_exit(void)
 	isa_unregister_driver(&snd_sc6000_driver);
 }
 
-module_init(alsa_card_sc6000_init)
-module_exit(alsa_card_sc6000_exit)
+module_init(alsa_card_sc6000_init);
+module_exit(alsa_card_sc6000_exit);
diff --git a/sound/isa/wavefront/wavefront.c b/sound/isa/wavefront/wavefront.c
index 711670e..6709e50 100644
--- a/sound/isa/wavefront/wavefront.c
+++ b/sound/isa/wavefront/wavefront.c
@@ -684,5 +684,5 @@ static void __exit alsa_card_wavefront_exit(void)
 		isa_unregister_driver(&snd_wavefront_driver);
 }
 
-module_init(alsa_card_wavefront_init)
-module_exit(alsa_card_wavefront_exit)
+module_init(alsa_card_wavefront_init);
+module_exit(alsa_card_wavefront_exit);
diff --git a/sound/mips/sgio2audio.c b/sound/mips/sgio2audio.c
index 717604c..f5a7372 100644
--- a/sound/mips/sgio2audio.c
+++ b/sound/mips/sgio2audio.c
@@ -985,5 +985,5 @@ static void __exit alsa_card_sgio2audio_exit(void)
 	platform_driver_unregister(&sgio2audio_driver);
 }
 
-module_init(alsa_card_sgio2audio_init)
-module_exit(alsa_card_sgio2audio_exit)
+module_init(alsa_card_sgio2audio_init);
+module_exit(alsa_card_sgio2audio_exit);
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 7f4d619..bb1b4bc 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -2933,5 +2933,5 @@ static void __exit alsa_ac97_exit(void)
 {
 }
 
-module_init(alsa_ac97_init)
-module_exit(alsa_ac97_exit)
+module_init(alsa_ac97_init);
+module_exit(alsa_ac97_exit);
diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 5c6e322..42252f7 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -2315,5 +2315,5 @@ static void __exit alsa_card_ali_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_ali_init)
-module_exit(alsa_card_ali_exit)
+module_init(alsa_card_ali_init);
+module_exit(alsa_card_ali_exit);
diff --git a/sound/pci/als300.c b/sound/pci/als300.c
index d7653cb..6adf6dc 100644
--- a/sound/pci/als300.c
+++ b/sound/pci/als300.c
@@ -866,5 +866,5 @@ static void __exit alsa_card_als300_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_als300_init)
-module_exit(alsa_card_als300_exit)
+module_init(alsa_card_als300_init);
+module_exit(alsa_card_als300_exit);
diff --git a/sound/pci/als4000.c b/sound/pci/als4000.c
index 0e247cb..de97453 100644
--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -1056,5 +1056,5 @@ static void __exit alsa_card_als4000_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_als4000_init)
-module_exit(alsa_card_als4000_exit)
+module_init(alsa_card_als4000_init);
+module_exit(alsa_card_als4000_exit);
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index f8ccc96..9037a16 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -2991,6 +2991,6 @@ static void __exit snd_asihpi_exit(void)
 	asihpi_exit();
 }
 
-module_init(snd_asihpi_init)
-module_exit(snd_asihpi_exit)
+module_init(snd_asihpi_init);
+module_exit(snd_asihpi_exit);
 
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 3119cd9..5766f4c 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1722,5 +1722,5 @@ static void __exit alsa_card_atiixp_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_atiixp_init)
-module_exit(alsa_card_atiixp_exit)
+module_init(alsa_card_atiixp_init);
+module_exit(alsa_card_atiixp_exit);
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 2f74c2f..7e16439 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1353,5 +1353,5 @@ static void __exit alsa_card_atiixp_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_atiixp_init)
-module_exit(alsa_card_atiixp_exit)
+module_init(alsa_card_atiixp_init);
+module_exit(alsa_card_atiixp_exit);
diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
index 7b72c88..0841678 100644
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -393,5 +393,5 @@ static void __exit alsa_card_vortex_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_vortex_init)
-module_exit(alsa_card_vortex_exit)
+module_init(alsa_card_vortex_init);
+module_exit(alsa_card_vortex_exit);
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 9b7a634..f12286d 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -2888,5 +2888,5 @@ alsa_card_azf3328_exit(void)
 	snd_azf3328_dbgcallleave();
 }
 
-module_init(alsa_card_azf3328_init)
-module_exit(alsa_card_azf3328_exit)
+module_init(alsa_card_azf3328_init);
+module_exit(alsa_card_azf3328_exit);
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index 2958a05..5e37f84 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -983,5 +983,5 @@ static void __exit alsa_card_bt87x_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_bt87x_init)
-module_exit(alsa_card_bt87x_exit)
+module_init(alsa_card_bt87x_init);
+module_exit(alsa_card_bt87x_exit);
diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index 4377592..4149365 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -1955,5 +1955,5 @@ static void __exit alsa_card_ca0106_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_ca0106_init)
-module_exit(alsa_card_ca0106_exit)
+module_init(alsa_card_ca0106_init);
+module_exit(alsa_card_ca0106_exit);
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index f4e5735..91d54ca 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -3418,5 +3418,5 @@ static void __exit alsa_card_cmipci_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_cmipci_init)
-module_exit(alsa_card_cmipci_exit)
+module_init(alsa_card_cmipci_init);
+module_exit(alsa_card_cmipci_exit);
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index 6772070..e221f73 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -2105,5 +2105,5 @@ static void __exit alsa_card_cs4281_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_cs4281_init)
-module_exit(alsa_card_cs4281_exit)
+module_init(alsa_card_cs4281_init);
+module_exit(alsa_card_cs4281_exit);
diff --git a/sound/pci/cs46xx/cs46xx.c b/sound/pci/cs46xx/cs46xx.c
index 767fa7f..d2a9537 100644
--- a/sound/pci/cs46xx/cs46xx.c
+++ b/sound/pci/cs46xx/cs46xx.c
@@ -182,5 +182,5 @@ static void __exit alsa_card_cs46xx_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_cs46xx_init)
-module_exit(alsa_card_cs46xx_exit)
+module_init(alsa_card_cs46xx_init);
+module_exit(alsa_card_cs46xx_exit);
diff --git a/sound/pci/cs5530.c b/sound/pci/cs5530.c
index bc07e27..1b93e5b 100644
--- a/sound/pci/cs5530.c
+++ b/sound/pci/cs5530.c
@@ -301,6 +301,6 @@ static void __exit alsa_card_cs5530_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_cs5530_init)
-module_exit(alsa_card_cs5530_exit)
+module_init(alsa_card_cs5530_init);
+module_exit(alsa_card_cs5530_exit);
 
diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index afb8037..68d7c0a 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -415,8 +415,8 @@ static void __exit alsa_card_cs5535audio_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_cs5535audio_init)
-module_exit(alsa_card_cs5535audio_exit)
+module_init(alsa_card_cs5535audio_init);
+module_exit(alsa_card_cs5535audio_exit);
 
 MODULE_AUTHOR("Jaya Kumar");
 MODULE_LICENSE("GPL");
diff --git a/sound/pci/ctxfi/xfi.c b/sound/pci/ctxfi/xfi.c
index f42e7e1..eb2ff28 100644
--- a/sound/pci/ctxfi/xfi.c
+++ b/sound/pci/ctxfi/xfi.c
@@ -163,5 +163,5 @@ static void __exit ct_card_exit(void)
 	pci_unregister_driver(&ct_driver);
 }
 
-module_init(ct_card_init)
-module_exit(ct_card_exit)
+module_init(ct_card_init);
+module_exit(ct_card_exit);
diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index 20763dd..46b9305 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -2354,5 +2354,5 @@ static void __exit alsa_card_echo_exit(void)
 }
 
 
-module_init(alsa_card_echo_init)
-module_exit(alsa_card_echo_exit)
+module_init(alsa_card_echo_init);
+module_exit(alsa_card_echo_exit);
diff --git a/sound/pci/emu10k1/emu10k1.c b/sound/pci/emu10k1/emu10k1.c
index aff8387..d1a4424 100644
--- a/sound/pci/emu10k1/emu10k1.c
+++ b/sound/pci/emu10k1/emu10k1.c
@@ -284,5 +284,5 @@ static void __exit alsa_card_emu10k1_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_emu10k1_init)
-module_exit(alsa_card_emu10k1_exit)
+module_init(alsa_card_emu10k1_init);
+module_exit(alsa_card_emu10k1_exit);
diff --git a/sound/pci/emu10k1/emu10k1_synth.c b/sound/pci/emu10k1/emu10k1_synth.c
index ad7b714..721c1df 100644
--- a/sound/pci/emu10k1/emu10k1_synth.c
+++ b/sound/pci/emu10k1/emu10k1_synth.c
@@ -119,5 +119,5 @@ static void __exit alsa_emu10k1_synth_exit(void)
 	snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_EMU10K1_SYNTH);
 }
 
-module_init(alsa_emu10k1_synth_init)
-module_exit(alsa_emu10k1_synth_exit)
+module_init(alsa_emu10k1_synth_init);
+module_exit(alsa_emu10k1_synth_exit);
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index 0c701e4..658c7d2 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -1631,5 +1631,5 @@ static void __exit alsa_card_emu10k1x_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_emu10k1x_init)
-module_exit(alsa_card_emu10k1x_exit)
+module_init(alsa_card_emu10k1x_init);
+module_exit(alsa_card_emu10k1x_exit);
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index 863eafe..fd5c3fd 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -2509,5 +2509,5 @@ static void __exit alsa_card_ens137x_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_ens137x_init)
-module_exit(alsa_card_ens137x_exit)
+module_init(alsa_card_ens137x_init);
+module_exit(alsa_card_ens137x_exit);
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index 553b752..17e243c 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -1902,5 +1902,5 @@ static void __exit alsa_card_es1938_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_es1938_init)
-module_exit(alsa_card_es1938_exit)
+module_init(alsa_card_es1938_init);
+module_exit(alsa_card_es1938_exit);
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 7c17f45..8aa742c 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2867,5 +2867,5 @@ static void __exit alsa_card_es1968_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_es1968_init)
-module_exit(alsa_card_es1968_exit)
+module_init(alsa_card_es1968_init);
+module_exit(alsa_card_es1968_exit);
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index e1baad7..ebbc4b0 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1618,5 +1618,5 @@ static void __exit alsa_card_fm801_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_fm801_init)
-module_exit(alsa_card_fm801_exit)
+module_init(alsa_card_fm801_init);
+module_exit(alsa_card_fm801_exit);
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 70a9d32..6bbc1f3 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2850,5 +2850,5 @@ static void __exit alsa_card_azx_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_azx_init)
-module_exit(alsa_card_azx_exit)
+module_init(alsa_card_azx_init);
+module_exit(alsa_card_azx_exit);
diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 2942d2a..55a788d 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -4984,5 +4984,5 @@ static void __exit patch_analog_exit(void)
 	snd_hda_delete_codec_preset(&analog_list);
 }
 
-module_init(patch_analog_init)
-module_exit(patch_analog_exit)
+module_init(patch_analog_init);
+module_exit(patch_analog_exit);
diff --git a/sound/pci/hda/patch_ca0110.c b/sound/pci/hda/patch_ca0110.c
index 46c8bf4..22b9f8c 100644
--- a/sound/pci/hda/patch_ca0110.c
+++ b/sound/pci/hda/patch_ca0110.c
@@ -568,5 +568,5 @@ static void __exit patch_ca0110_exit(void)
 	snd_hda_delete_codec_preset(&ca0110_list);
 }
 
-module_init(patch_ca0110_init)
-module_exit(patch_ca0110_exit)
+module_init(patch_ca0110_init);
+module_exit(patch_ca0110_exit);
diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 067982f..5d292fcc 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -1310,5 +1310,5 @@ static void __exit patch_cirrus_exit(void)
 	snd_hda_delete_codec_preset(&cirrus_list);
 }
 
-module_init(patch_cirrus_init)
-module_exit(patch_cirrus_exit)
+module_init(patch_cirrus_init);
+module_exit(patch_cirrus_exit);
diff --git a/sound/pci/hda/patch_cmedia.c b/sound/pci/hda/patch_cmedia.c
index 1f8bbcd..82b862a 100644
--- a/sound/pci/hda/patch_cmedia.c
+++ b/sound/pci/hda/patch_cmedia.c
@@ -772,5 +772,5 @@ static void __exit patch_cmedia_exit(void)
 	snd_hda_delete_codec_preset(&cmedia_list);
 }
 
-module_init(patch_cmedia_init)
-module_exit(patch_cmedia_exit)
+module_init(patch_cmedia_init);
+module_exit(patch_cmedia_exit);
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index ad97d93..d493472 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3901,5 +3901,5 @@ static void __exit patch_conexant_exit(void)
 	snd_hda_delete_codec_preset(&conexant_list);
 }
 
-module_init(patch_conexant_init)
-module_exit(patch_conexant_exit)
+module_init(patch_conexant_init);
+module_exit(patch_conexant_exit);
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 715615a..daa2bce 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1745,5 +1745,5 @@ static void __exit patch_hdmi_exit(void)
 	snd_hda_delete_codec_preset(&intel_list);
 }
 
-module_init(patch_hdmi_init)
-module_exit(patch_hdmi_exit)
+module_init(patch_hdmi_init);
+module_exit(patch_hdmi_exit);
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c82979a..62ee385 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -20163,5 +20163,5 @@ static void __exit patch_realtek_exit(void)
 	snd_hda_delete_codec_preset(&realtek_list);
 }
 
-module_init(patch_realtek_init)
-module_exit(patch_realtek_exit)
+module_init(patch_realtek_init);
+module_exit(patch_realtek_exit);
diff --git a/sound/pci/hda/patch_si3054.c b/sound/pci/hda/patch_si3054.c
index f419ee8..58c8e8b 100644
--- a/sound/pci/hda/patch_si3054.c
+++ b/sound/pci/hda/patch_si3054.c
@@ -331,5 +331,5 @@ static void __exit patch_si3054_exit(void)
 	snd_hda_delete_codec_preset(&si3054_list);
 }
 
-module_init(patch_si3054_init)
-module_exit(patch_si3054_exit)
+module_init(patch_si3054_init);
+module_exit(patch_si3054_exit);
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 94d19c0..3f2ecc2 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -6430,5 +6430,5 @@ static void __exit patch_sigmatel_exit(void)
 	snd_hda_delete_codec_preset(&sigmatel_list);
 }
 
-module_init(patch_sigmatel_init)
-module_exit(patch_sigmatel_exit)
+module_init(patch_sigmatel_init);
+module_exit(patch_sigmatel_exit);
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 0997031..382dab4 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -6103,5 +6103,5 @@ static void __exit patch_via_exit(void)
 	snd_hda_delete_codec_preset(&via_list);
 }
 
-module_init(patch_via_init)
-module_exit(patch_via_exit)
+module_init(patch_via_init);
+module_exit(patch_via_exit);
diff --git a/sound/pci/ice1712/ak4xxx.c b/sound/pci/ice1712/ak4xxx.c
index 90d560c..cc1a37a 100644
--- a/sound/pci/ice1712/ak4xxx.c
+++ b/sound/pci/ice1712/ak4xxx.c
@@ -187,8 +187,8 @@ static void __exit alsa_ice1712_akm4xxx_module_exit(void)
 {
 }
         
-module_init(alsa_ice1712_akm4xxx_module_init)
-module_exit(alsa_ice1712_akm4xxx_module_exit)
+module_init(alsa_ice1712_akm4xxx_module_init);
+module_exit(alsa_ice1712_akm4xxx_module_exit);
 
 EXPORT_SYMBOL(snd_ice1712_akm4xxx_init);
 EXPORT_SYMBOL(snd_ice1712_akm4xxx_free);
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index f4594d7..2097d54 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2818,5 +2818,5 @@ static void __exit alsa_card_ice1712_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_ice1712_init)
-module_exit(alsa_card_ice1712_exit)
+module_init(alsa_card_ice1712_init);
+module_exit(alsa_card_ice1712_exit);
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index c1498fa..d659eef 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2822,5 +2822,5 @@ static void __exit alsa_card_ice1724_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_ice1724_init)
-module_exit(alsa_card_ice1724_exit)
+module_init(alsa_card_ice1724_init);
+module_exit(alsa_card_ice1724_exit);
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 6c896db..7ee2dbe 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -3287,5 +3287,5 @@ static void __exit alsa_card_intel8x0_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_intel8x0_init)
-module_exit(alsa_card_intel8x0_exit)
+module_init(alsa_card_intel8x0_init);
+module_exit(alsa_card_intel8x0_exit);
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 27709f0..35c8356 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -1346,5 +1346,5 @@ static void __exit alsa_card_intel8x0m_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_intel8x0m_init)
-module_exit(alsa_card_intel8x0m_exit)
+module_init(alsa_card_intel8x0m_init);
+module_exit(alsa_card_intel8x0m_exit);
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index 6d79570..b9abcb3 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -2493,5 +2493,5 @@ static void __exit alsa_card_korg1212_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_korg1212_init)
-module_exit(alsa_card_korg1212_exit)
+module_init(alsa_card_korg1212_init);
+module_exit(alsa_card_korg1212_exit);
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 3c40d72..d50782a 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -2905,5 +2905,5 @@ static void __exit alsa_card_m3_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_m3_init)
-module_exit(alsa_card_m3_exit)
+module_init(alsa_card_m3_init);
+module_exit(alsa_card_m3_exit);
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index 6c3fd4d..5dcc680 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1397,5 +1397,5 @@ static void __exit alsa_card_mixart_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_mixart_init)
-module_exit(alsa_card_mixart_exit)
+module_init(alsa_card_mixart_init);
+module_exit(alsa_card_mixart_exit);
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index 5a60492..01fc8ba 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -1764,5 +1764,5 @@ static void __exit alsa_card_nm256_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_nm256_init)
-module_exit(alsa_card_nm256_exit)
+module_init(alsa_card_nm256_init);
+module_exit(alsa_card_nm256_exit);
diff --git a/sound/pci/oxygen/oxygen.c b/sound/pci/oxygen/oxygen.c
index d7e8ddd..5582011 100644
--- a/sound/pci/oxygen/oxygen.c
+++ b/sound/pci/oxygen/oxygen.c
@@ -879,5 +879,5 @@ static void __exit alsa_card_oxygen_exit(void)
 	pci_unregister_driver(&oxygen_driver);
 }
 
-module_init(alsa_card_oxygen_init)
-module_exit(alsa_card_oxygen_exit)
+module_init(alsa_card_oxygen_init);
+module_exit(alsa_card_oxygen_exit);
diff --git a/sound/pci/oxygen/virtuoso.c b/sound/pci/oxygen/virtuoso.c
index 469010a..13abe96 100644
--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -109,5 +109,5 @@ static void __exit alsa_card_xonar_exit(void)
 	pci_unregister_driver(&xonar_driver);
 }
 
-module_init(alsa_card_xonar_init)
-module_exit(alsa_card_xonar_exit)
+module_init(alsa_card_xonar_init);
+module_exit(alsa_card_xonar_exit);
diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
index 95cfde2..9533c62 100644
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -1624,5 +1624,5 @@ static void __exit pcxhr_module_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(pcxhr_module_init)
-module_exit(pcxhr_module_exit)
+module_init(pcxhr_module_init);
+module_exit(pcxhr_module_exit);
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index 3c04524..5e5a3f0 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -2001,5 +2001,5 @@ static void __exit alsa_card_rme32_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_rme32_init)
-module_exit(alsa_card_rme32_exit)
+module_init(alsa_card_rme32_init);
+module_exit(alsa_card_rme32_exit);
diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
index 9ff247f..3ab1c05 100644
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -2412,5 +2412,5 @@ static void __exit alsa_card_rme96_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_rme96_init)
-module_exit(alsa_card_rme96_exit)
+module_init(alsa_card_rme96_init);
+module_exit(alsa_card_rme96_exit);
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index 2d83324..4b2c8af 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -5653,5 +5653,5 @@ static void __exit alsa_card_hdsp_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_hdsp_init)
-module_exit(alsa_card_hdsp_exit)
+module_init(alsa_card_hdsp_init);
+module_exit(alsa_card_hdsp_exit);
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 949691a..cae61c3 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -6792,5 +6792,5 @@ static void __exit alsa_card_hdspm_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_hdspm_init)
-module_exit(alsa_card_hdspm_exit)
+module_init(alsa_card_hdspm_init);
+module_exit(alsa_card_hdspm_exit);
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index c492af5..6248028 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -2648,5 +2648,5 @@ static void __exit alsa_card_hammerfall_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_hammerfall_init)
-module_exit(alsa_card_hammerfall_exit)
+module_init(alsa_card_hammerfall_init);
+module_exit(alsa_card_hammerfall_exit);
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index 337b9fa..1230538 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -1546,5 +1546,5 @@ static void __exit alsa_card_sonicvibes_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_sonicvibes_init)
-module_exit(alsa_card_sonicvibes_exit)
+module_init(alsa_card_sonicvibes_init);
+module_exit(alsa_card_sonicvibes_exit);
diff --git a/sound/pci/trident/trident.c b/sound/pci/trident/trident.c
index 6d05818..c65dfc9 100644
--- a/sound/pci/trident/trident.c
+++ b/sound/pci/trident/trident.c
@@ -192,5 +192,5 @@ static void __exit alsa_card_trident_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_trident_init)
-module_exit(alsa_card_trident_exit)
+module_init(alsa_card_trident_init);
+module_exit(alsa_card_trident_exit);
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 8c5f8b5..617cf53 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2631,5 +2631,5 @@ static void __exit alsa_card_via82xx_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_via82xx_init)
-module_exit(alsa_card_via82xx_exit)
+module_init(alsa_card_via82xx_init);
+module_exit(alsa_card_via82xx_exit);
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index f7e8bbbe..944c1b9 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -1244,5 +1244,5 @@ static void __exit alsa_card_via82xx_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_via82xx_init)
-module_exit(alsa_card_via82xx_exit)
+module_init(alsa_card_via82xx_init);
+module_exit(alsa_card_via82xx_exit);
diff --git a/sound/pci/vx222/vx222.c b/sound/pci/vx222/vx222.c
index 99a9a81..9f67529 100644
--- a/sound/pci/vx222/vx222.c
+++ b/sound/pci/vx222/vx222.c
@@ -310,5 +310,5 @@ static void __exit alsa_card_vx222_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_vx222_init)
-module_exit(alsa_card_vx222_exit)
+module_init(alsa_card_vx222_init);
+module_exit(alsa_card_vx222_exit);
diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 80c6821..2464428 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -365,5 +365,5 @@ static void __exit alsa_card_ymfpci_exit(void)
 	pci_unregister_driver(&driver);
 }
 
-module_init(alsa_card_ymfpci_init)
-module_exit(alsa_card_ymfpci_exit)
+module_init(alsa_card_ymfpci_init);
+module_exit(alsa_card_ymfpci_exit);
diff --git a/sound/ppc/powermac.c b/sound/ppc/powermac.c
index a2b69b8..4478943 100644
--- a/sound/ppc/powermac.c
+++ b/sound/ppc/powermac.c
@@ -191,5 +191,5 @@ static void __exit alsa_card_pmac_exit(void)
 	platform_driver_unregister(&snd_pmac_driver);
 }
 
-module_init(alsa_card_pmac_init)
-module_exit(alsa_card_pmac_exit)
+module_init(alsa_card_pmac_init);
+module_exit(alsa_card_pmac_exit);
diff --git a/sound/soc/sh/siu_dai.c b/sound/soc/sh/siu_dai.c
index 4973c29..4455d4d 100644
--- a/sound/soc/sh/siu_dai.c
+++ b/sound/soc/sh/siu_dai.c
@@ -861,8 +861,8 @@ static void __exit siu_exit(void)
 	platform_driver_unregister(&siu_driver);
 }
 
-module_init(siu_init)
-module_exit(siu_exit)
+module_init(siu_init);
+module_exit(siu_exit);
 
 MODULE_AUTHOR("Carlos Munoz <carlos@kenati.com>");
 MODULE_DESCRIPTION("ALSA SoC SH7722 SIU driver");
diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index f16a3fc..f4a382e 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -187,5 +187,5 @@ static void __exit alsa_emux_exit(void)
 {
 }
 
-module_init(alsa_emux_init)
-module_exit(alsa_emux_exit)
+module_init(alsa_emux_init);
+module_exit(alsa_emux_exit);
diff --git a/sound/synth/util_mem.c b/sound/synth/util_mem.c
index c85522e..65a9fa9 100644
--- a/sound/synth/util_mem.c
+++ b/sound/synth/util_mem.c
@@ -206,5 +206,5 @@ static void __exit alsa_util_mem_exit(void)
 {
 }
 
-module_init(alsa_util_mem_init)
-module_exit(alsa_util_mem_exit)
+module_init(alsa_util_mem_init);
+module_exit(alsa_util_mem_exit);
diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index 45bc4a2..437cd0e 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -542,6 +542,6 @@ static void __exit snd_module_exit(void)
 	usb_deregister(&snd_usb_driver);
 }
 
-module_init(snd_module_init)
-module_exit(snd_module_exit)
+module_init(snd_module_init);
+module_exit(snd_module_exit);
 
diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 084e6fc..2ec3ef9 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -782,5 +782,5 @@ static void __exit snd_us122l_module_exit(void)
 	usb_deregister(&snd_us122l_usb_driver);
 }
 
-module_init(snd_us122l_module_init)
-module_exit(snd_us122l_module_exit)
+module_init(snd_us122l_module_init);
+module_exit(snd_us122l_module_exit);
diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index cbd37f2..4619f0d 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -469,5 +469,5 @@ static void __exit snd_usX2Y_module_exit(void)
 	usb_deregister(&snd_usX2Y_usb_driver);
 }
 
-module_init(snd_usX2Y_module_init)
-module_exit(snd_usX2Y_module_exit)
+module_init(snd_usX2Y_module_init);
+module_exit(snd_usX2Y_module_exit);
-- 
1.7.4.1.343.ga91df

