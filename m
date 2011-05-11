Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab1EKQrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:47:23 -0400
Received: from outbound005.roc2.bluetie.com ([208.89.132.145]:40321 "EHLO
	outbound005.roc2.bluetie.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754971Ab1EKQrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:47:20 -0400
X-Greylist: delayed 3681 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 12:47:20 EDT
X-CMAE-OUT-Analysis: v=1.1 cv=dCdVYeM+4VlzGC5d032K9XjiLNhscsavJSUjPTSG7Ag=
 c=1 sm=1 a=i-wQWBNYtOgA:10 a=IkcTkHD0fZMA:10 a=PWRYt1JR07sjTPb3Zz0A:9
 a=Lb-oTySLLyQONCdKD90A:7 a=QEXdDO2ut3YA:10 a=Wkq6KJFhTf9Ox5xu:21
 a=HvdBdLMMOAk8WP_2:21 a=+8qXc097eLrkhNZCekYbQQ==:117
X-CMAE-OUT-Score: 0.00
Message-ID: <20110511053137.21183@web007.roc2.bluetie.com>
X-HTTP-Received: from psycho-logic.excite [212.178.105.234] by web007.roc2.bluetie.com (BlueTie WebMail ); Wed, 11 May 2011 05:31:37 -0400
X-Mailer: BlueTie MTA
Date: Wed, 11 May 2011 05:31:37 -0400
To: linux-kernel@vger.kernel.org
From: "Full Name" <psycho-logic@excite.com>
Importance: normal
Subject: mvsas issues
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4BGlu9D004040

Hi there,

for a while I've been following the issues with the mvsas controllers, especially in combination with SATA drives. Since version 2.6.36 I thought it was quite stable, the local processes at least didn't throw off the 8 disk raid-6 array we have and I didn't really see any errors at all.

Even on the 2.6.38 we run now (ubuntu 11.04 64 bit server) it was stable. Emphasis on the was... all was fine until I started exporting the volume through samba and above all, nfs. There's some vmdk's on the volume now, which get put there by a backup application over samba. This works reasonably, but then vmware esx will attach to it over NFS and that's when the real misery starts. It's completely unusable over NFS, errors aren't more than a couple of minutes apart when ESX generates traffic and due to bus resets etc. this means there is hardly any data coming from it whatsoever.

The errors we see are below. This box doesn't really run production yet, but it will have to in a couple of weeks. In the mean time however I can test/gather whatever is required.

Kind regards,

================ mdadm details on /dev/md4 ========================

Other RAID sets not posted as they're attached to local SATA controllers. They data they house must be stable so we moved them off the marvell(ous misery) controller

root@datavault:/var/log# mdadm --detail /dev/md4
/dev/md4:
        Version : 0.90
  Creation Time : Wed Dec  1 13:43:11 2010
     Raid Level : raid6
     Array Size : 11721086976 (11178.10 GiB 12002.39 GB)
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Wed May 11 11:22:25 2011
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 2cdc8fe9:e24fb941:c4e8ec2d:2a80eff0 (local to host datavault)
         Events : 0.45

    Number   Major   Minor   RaidDevice State
       0       8       96        0      active sync   /dev/sdg
       1       8      160        1      active sync   /dev/sdk
       2       8      128        2      active sync   /dev/sdi
       3       8      176        3      active sync   /dev/sdl
       4       8      112        4      active sync   /dev/sdh
       5       8      144        5      active sync   /dev/sdj
       6       8       80        6      active sync   /dev/sdf
       7       8       64        7      active sync   /dev/sde


================= lspci =================
root@datavault:/var/log# lspci
00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 12)
00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 Root Port (rev 12)
00:06.0 PCI bridge: Intel Corporation Core Processor Secondary PCI Express Root Port (rev 12)
00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05)
00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 5 (rev 05)
00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 (rev 05)
00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a5)
00:1f.0 ISA bridge: Intel Corporation 3400 Series Chipset LPC Interface Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 05)
01:00.0 SCSI storage controller: Marvell Technology Group Ltd. MV64460/64461/64462 System Controller, Revision B (rev 01)
02:00.0 SCSI storage controller: Marvell Technology Group Ltd. MV64460/64461/64462 System Controller, Revision B (rev 01)
04:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
05:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
06:03.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200eW WPCM450 (rev 0a)


================ uname -a ===================
root@datavault:/var/log# uname -a
Linux datavault 2.6.38-8-server #42-Ubuntu SMP Mon Apr 11 03:49:04 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux


================ piece of log from /var/log/syslog ==========================

May 11 10:57:19 datavault kernel: [1107478.903123] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880132dc0000 task=ffff88008af32d80 slot=ffff880132de4538 slot_idx=x1
May 11 10:57:19 datavault kernel: [1107478.903136] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
May 11 10:57:19 datavault kernel: [1107478.903207] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x89800.
May 11 10:57:19 datavault kernel: [1107478.903212] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x1001
May 11 10:57:19 datavault kernel: [1107478.903220] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2111:phy7 Unplug Notice
May 11 10:57:19 datavault kernel: [1107478.913277] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x199800.
May 11 10:57:19 datavault kernel: [1107478.913279] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x1081
May 11 10:57:19 datavault kernel: [1107478.917506] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x199800.
May 11 10:57:19 datavault kernel: [1107478.917511] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x10000
May 11 10:57:19 datavault kernel: [1107478.917516] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[7]
May 11 10:57:19 datavault kernel: [1107479.027492] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1224:port 7 attach dev info is 1
May 11 10:57:19 datavault kernel: [1107479.027495] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1226:port 7 attach sas addr is 7
May 11 10:57:19 datavault kernel: [1107479.027500] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 378:phy 7 byte dmaded.
May 11 10:57:21 datavault kernel: [1107481.122546] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[3]:rc= 0
May 11 10:57:21 datavault kernel: [1107481.122564] ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
May 11 10:57:21 datavault kernel: [1107481.207659] ata14: status=0x01 { Error }
May 11 10:57:21 datavault kernel: [1107481.207664] ata14: error=0x04 { DriveStatusError }
May 11 10:59:47 datavault kernel: [1107626.944438] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff88012f100000 task=ffff880097f95c00 slot=ffff88012f124590 slot_idx=x2
May 11 10:59:47 datavault kernel: [1107626.944450] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
May 11 10:59:47 datavault kernel: [1107626.944483] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x89800.
May 11 10:59:47 datavault kernel: [1107626.944486] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x1001
May 11 10:59:47 datavault kernel: [1107626.944494] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2111:phy0 Unplug Notice
May 11 10:59:47 datavault kernel: [1107626.954513] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x199800.
May 11 10:59:47 datavault kernel: [1107626.954516] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x1081
May 11 10:59:47 datavault kernel: [1107626.958066] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x199800.
May 11 10:59:47 datavault kernel: [1107626.958070] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x10000
May 11 10:59:47 datavault kernel: [1107626.958074] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[0]
May 11 10:59:47 datavault kernel: [1107627.068075] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1224:port 0 attach dev info is 0
May 11 10:59:47 datavault kernel: [1107627.068080] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1226:port 0 attach sas addr is 0
May 11 10:59:47 datavault kernel: [1107627.068093] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 378:phy 0 byte dmaded.
May 11 10:59:49 datavault kernel: [1107629.163848] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[0]:rc= 0
May 11 10:59:49 datavault kernel: [1107629.163858] ata7: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
May 11 10:59:49 datavault kernel: [1107629.163860] ata7.00: device reported invalid CHS sector 0
May 11 10:59:49 datavault kernel: [1107629.163861] ata7: status=0x01 { Error }
May 11 10:59:49 datavault kernel: [1107629.163863] ata7: error=0x04 { DriveStatusError }
May 11 11:02:39 datavault kernel: [1107798.819642] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880132dc0000 task=ffff88000c2c8540 slot=ffff880132de4590 slot_idx=x2
May 11 11:02:39 datavault kernel: [1107798.819652] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
May 11 11:02:39 datavault kernel: [1107798.819674] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x89800.
May 11 11:02:39 datavault kernel: [1107798.819678] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x1001
May 11 11:02:39 datavault kernel: [1107798.819684] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2111:phy7 Unplug Notice
May 11 11:02:39 datavault kernel: [1107798.829759] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x199800.
May 11 11:02:39 datavault kernel: [1107798.829765] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x1081
May 11 11:02:39 datavault kernel: [1107798.834168] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x199800.
May 11 11:02:39 datavault kernel: [1107798.834172] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x10000
May 11 11:02:39 datavault kernel: [1107798.834177] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[7]
May 11 11:02:39 datavault kernel: [1107798.944173] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1224:port 7 attach dev info is 1
May 11 11:02:39 datavault kernel: [1107798.944176] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1226:port 7 attach sas addr is 7
May 11 11:02:39 datavault kernel: [1107798.944181] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 378:phy 7 byte dmaded.
May 11 11:02:41 datavault kernel: [1107801.039070] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[3]:rc= 0
May 11 11:02:41 datavault kernel: [1107801.039083] ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
May 11 11:02:41 datavault kernel: [1107801.123629] ata14.00: device reported invalid CHS sector 0
May 11 11:02:41 datavault kernel: [1107801.123632] ata14: status=0x01 { Error }
May 11 11:02:41 datavault kernel: [1107801.123636] ata14: error=0x04 { DriveStatusError }
May 11 11:05:07 datavault kernel: [1107946.780999] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff88012f100000 task=ffff88012299a4c0 slot=ffff88012f124538 slot_idx=x1
May 11 11:05:07 datavault kernel: [1107946.781014] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
May 11 11:05:07 datavault kernel: [1107946.781067] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 3 ctrl sts=0x89800.
May 11 11:05:07 datavault kernel: [1107946.781073] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 3 irq sts = 0x1001
May 11 11:05:07 datavault kernel: [1107946.781082] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2111:phy3 Unplug Notice
May 11 11:05:07 datavault kernel: [1107946.791102] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 3 ctrl sts=0x199800.
May 11 11:05:07 datavault kernel: [1107946.791108] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 3 irq sts = 0x1081
May 11 11:05:07 datavault kernel: [1107946.794890] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2083:port 3 ctrl sts=0x199800.
May 11 11:05:07 datavault kernel: [1107946.794895] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2085:Port 3 irq sts = 0x10000
May 11 11:05:07 datavault kernel: [1107946.794899] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[3]
May 11 11:05:07 datavault kernel: [1107946.904897] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1224:port 3 attach dev info is 8000000
May 11 11:05:07 datavault kernel: [1107946.904902] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1226:port 3 attach sas addr is 3
May 11 11:05:07 datavault kernel: [1107946.904911] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 378:phy 3 byte dmaded.
May 11 11:05:09 datavault kernel: [1107949.000397] /build/buildd/linux-2.6.38/drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[3]:rc= 0
May 11 11:05:09 datavault kernel: [1107949.000410] ata10: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
May 11 11:05:09 datavault kernel: [1107949.081915] ata10.00: device reported invalid CHS sector 0
May 11 11:05:09 datavault kernel: [1107949.081919] ata10: status=0x01 { Error }
May 11 11:05:09 datavault kernel: [1107949.081922] ata10: error=0x04 { DriveStatusError }


============= misc of possible interest ==========

root@datavault:/var/log# cat /etc/exports 
# /etc/exports: the access control list for filesystems which may be exported
#		to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
#
/mnt/export		*(anonuid=65534,anongid=65534,sync,no_root_squash,rw)



root@datavault:/var/log# mount
/dev/md1 on / type ext4 (rw,errors=remount-ro)
proc on /proc type proc (rw,noexec,nosuid,nodev)
none on /sys type sysfs (rw,noexec,nosuid,nodev)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
none on /sys/kernel/debug type debugfs (rw)
none on /sys/kernel/security type securityfs (rw)
none on /dev type devtmpfs (rw,mode=0755)
none on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=0620)
none on /dev/shm type tmpfs (rw,nosuid,nodev)
none on /var/run type tmpfs (rw,nosuid,mode=0755)
none on /var/lock type tmpfs (rw,noexec,nosuid,nodev)
/dev/md0 on /boot type ext2 (rw)
/dev/md3 on /mnt/bhome2 type ext4 (rw)
/dev/md2 on /mnt/bhome1 type ext4 (rw)
/dev/md4 on /mnt/export type ext4 (rw)
nfsd on /proc/fs/nfsd type nfsd (rw)



root@datavault:/var/log# nfsstat 
Server rpc stats:
calls      badcalls   badauth    badclnt    xdrcall
8845295    0          0          0          0       

Server nfs v2:
null         getattr      setattr      root         lookup       readlink     
14      100% 0         0% 0         0% 0         0% 0         0% 0         0% 
read         wrcache      write        create       remove       rename       
0         0% 0         0% 0         0% 0         0% 0         0% 0         0% 
link         symlink      mkdir        rmdir        readdir      fsstat       
0         0% 0         0% 0         0% 0         0% 0         0% 0         0% 

Server nfs v3:
null         getattr      setattr      lookup       access       readlink     
4         0% 11650     0% 536       0% 472178    5% 37691     0% 0         0% 
read         write        create       mkdir        symlink      mknod        
2603621  29% 5713221  64% 147       0% 1         0% 0         0% 0         0% 
remove       rmdir        rename       link         readdir      readdirplus  
123       0% 2         0% 32        0% 0         0% 13        0% 2346      0% 
fsstat       fsinfo       pathconf     commit       
2718      0% 2         0% 1         0% 1028      0% 



