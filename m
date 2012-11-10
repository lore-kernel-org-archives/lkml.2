Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2KJSdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 13:33:46 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47034 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2KJSdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 13:33:40 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
Date: Sat, 10 Nov 2012 19:33:37 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc4-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: Kim Jaegeuk <jaegeuk.kim@gmail.com>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-fsdevel@vger.kernel.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com> <201211021439.02797.Martin@lichtvoll.de> <CAOtxgye-sqJFe17EyfJQ0RrMwQqsPbDv5m+4cJT0BjnRnGv56w@mail.gmail.com> (sfid-20121105_204523_384093_CECB414C)
In-Reply-To: <CAOtxgye-sqJFe17EyfJQ0RrMwQqsPbDv5m+4cJT0BjnRnGv56w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211101933.38434.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 2. November 2012 schrieb Kim Jaegeuk:
> 2012/11/2 Martin Steigerwald <Martin@lichtvoll.de>
> 
> > Am Mittwoch, 31. Oktober 2012 schrieb Jaegeuk Kim:
> > > Change log from v2:
> > >  o Fix compilation error for arm [Max]
> > >  o Move proc entries to debugfs [Greg]
> > >  o Add i_atime, i_generation, etc [Neil]
> > >  o Support NFS export [Changman]
> > >  o Move the f2fs magic number [Marco]
> > >  o Add s_time_gran [Marco]
> > >  o Fix f2fs_truncate [Marco]
> > >  o Enhance f2fs document [Vyacheslav]
> > >  o Support uuid and add additional comments [Vyacheslav]
> > >  o Change superblock offset [Vyacheslav]
> > >  o Fix some bugs and return values [Vyacheslav]
> > >  o Improve initial mount time [Jaegeuk]
> > >  o Fix f2fs-tools environment [Mike]
> > > 
> > > I've set up a git tree in sf.net for f2fs-tools.
> > > Please download f2fs-tools by tag: for_patch_set_v3.
> > 
> > I like to try this out.
> > 
> > Do you have kernel code available in some git repo? I didn´t find
> > anything on git.kernel.org? Otherwise I take the patches from your
> > mails.
> 
> At this moment, there is no f2fs-repo yet in public.
> If f2fs is merged, I'd like to make a dev tree somewhere.
> I really want to make the dev tree in kernel.org later, but it totally
> depends on the maintainers' decision.
> Before then, I apologize to retrieve f2fs sources from LKML.

After getting behind an USB blocks a CPU on my laptop problem I tried f2fs.


Some first tests on a 2GB extrememory USB 2.0 stick:

[  239.731162] usb 1-1.1: new high-speed USB device number 8 using ehci_hcd
[  239.818325] usb 1-1.1: New USB device found, idVendor=1307, idProduct=0163
[  239.818339] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  239.818346] usb 1-1.1: Product: USB Mass Storage Device
[  239.818352] usb 1-1.1: Manufacturer: USBest Technology
[  239.818357] usb 1-1.1: SerialNumber: […]
[  239.820595] scsi9 : usb-storage 1-1.1:1.0
[  240.821487] scsi 9:0:0:0: Direct-Access     TinyDisk 2007-05-12       0.00 PQ: 0 ANSI: 2
[  240.825217] sd 9:0:0:0: Attached scsi generic sg2 type 0
[  240.826318] sd 9:0:0:0: [sdb] 4095999 512-byte logical blocks: (2.09 GB/1.95 GiB)
[  240.827126] sd 9:0:0:0: [sdb] Write Protect is off
[  240.827143] sd 9:0:0:0: [sdb] Mode Sense: 00 00 00 00
[  240.828161] sd 9:0:0:0: [sdb] Asking for cache data failed
[  240.828174] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[  240.833414] sd 9:0:0:0: [sdb] Asking for cache data failed
[  240.833428] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[  240.894728]  sdb: unknown partition table
[  240.899104] sd 9:0:0:0: [sdb] Asking for cache data failed
[  240.899109] sd 9:0:0:0: [sdb] Assuming drive cache: write through
[  240.899113] sd 9:0:0:0: [sdb] Attached SCSI removable disk
merkaba:~> fdisk /dev/sdb
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x7babe038.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-4095998, default 2048): 
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-4095998, default 4095998): 
Using default value 4095998

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
merkaba:~> dmesg | tail -1         
[  276.342638]  sdb: sdb1



merkaba:~> mkfs.f2fs /dev/sdb1
Info: sector size = 512
Info: total sectors = 4093951 (in 512bytes)
Info: zone aligned segment0 blkaddr: 256
Info: This device doesn't support TRIM
Info: format successful
merkaba:~> mount /dev/sdb1 /mnt/zeit
mount: you must specify the filesystem type
merkaba:~#32> mount -t f2fs /dev/sdb1 /mnt/zeit
merkaba:~> df -hT /mnt/zeit
Dateisystem    Typ  Größe Benutzt Verf. Verw% Eingehängt auf
/dev/sdb1      f2fs  2,0G    147M  1,8G    8% /mnt/zeit


merkaba:~> dd if=/dev/zero of=/mnt/zeit/zeros bs=1M count=200 conv=fsync
200+0 Datensätze ein
200+0 Datensätze aus
209715200 Bytes (210 MB) kopiert, 14,4896 s, 14,5 MB/s

merkaba:~> echo 3 > /proc/sys/vm/drop_caches; dd if=/mnt/zeit/zeros of=/dev/null bs=1M count=200
200+0 Datensätze ein
200+0 Datensätze aus
209715200 Bytes (210 MB) kopiert, 8,7358 s, 24,0 MB/s
merkaba:~> umount /mnt/zeit  



merkaba:~> mkfs.ext4 /dev/sdb1
mke2fs 1.42.5 (29-Jul-2012)
Dateisystem-Label=
OS-Typ: Linux
Blockgröße=4096 (log=2)
Fragmentgröße=4096 (log=2)
Stride=0 Blöcke, Stripebreite=0 Blöcke
128000 Inodes, 511743 Blöcke
25587 Blöcke (5.00%) reserviert für den Superuser
Erster Datenblock=0
Maximale Dateisystem-Blöcke=524288000
16 Blockgruppen
32768 Blöcke pro Gruppe, 32768 Fragmente pro Gruppe
8000 Inodes pro Gruppe
Superblock-Sicherungskopien gespeichert in den Blöcken: 
        32768, 98304, 163840, 229376, 294912

Platz für Gruppentabellen wird angefordert: erledigt                        
Inode-Tabellen werden geschrieben: erledigt                        
Erstelle Journal (8192 Blöcke): erledigt
Schreibe Superblöcke und Dateisystem-Accountinginformationen: erledigt

merkaba:~> mount /dev/sdb1 /mnt/zeit                                                            
merkaba:~> df -hT /mnt/zeit         
Dateisystem    Typ  Größe Benutzt Verf. Verw% Eingehängt auf
/dev/sdb1      ext4  2,0G     35M  1,8G    2% /mnt/zeit
merkaba:~> dd if=/dev/zero of=/mnt/zeit/zeros bs=1M count=200 conv=fsync
200+0 Datensätze ein
200+0 Datensätze aus
209715200 Bytes (210 MB) kopiert, 17,8875 s, 11,7 MB/s
merkaba:~> echo 3 > /proc/sys/vm/drop_caches; dd if=/mnt/zeit/zeros of=/dev/null bs=1M count=200
200+0 Datensätze ein
200+0 Datensätze aus
209715200 Bytes (210 MB) kopiert, 8,76721 s, 23,9 MB/s

merkaba:~> umount /mnt/zeit


So writing appears to be faster with large block sizes. But this was just
one iteration, so that would need to be verified by several subsequent
runs.


merkaba:~> mkfs.f2fs /dev/sdb1              
Info: sector size = 512
Info: total sectors = 4093951 (in 512bytes)
Info: zone aligned segment0 blkaddr: 256
Info: This device doesn't support TRIM
Info: format successful
merkaba:~> mount -t f2fs /dev/sdb1 /mnt/zeit
merkaba:~> fio /tmp/usb-stick.job           
seq-read: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
rand-read: (g=1): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
seq-write: (g=2): rw=write, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
rand-write: (g=3): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
2.0.8
Starting 4 processes
seq-read: Laying out IO file(s) (1 file(s) / 512MB)
Jobs: 1 (f=1): [___w] [57.2% done] [0K/703K /s] [0 /175  iops] [eta 03m:00s]    
seq-read: (groupid=0, jobs=1): err= 0: pid=7819
  read : io=470600KB, bw=7843.8KB/s, iops=1960 , runt= 60002msec
    slat (usec): min=2 , max=176 , avg=16.70, stdev= 9.41
    clat (usec): min=632 , max=37073 , avg=2018.40, stdev=237.35
     lat (usec): min=678 , max=37106 , avg=2035.70, stdev=237.23
    clat percentiles (usec):
     |  1.00th=[ 1848],  5.00th=[ 1928], 10.00th=[ 1960], 20.00th=[ 1960],
     | 30.00th=[ 1976], 40.00th=[ 1976], 50.00th=[ 1992], 60.00th=[ 1992],
     | 70.00th=[ 2008], 80.00th=[ 2096], 90.00th=[ 2128], 95.00th=[ 2224],
     | 99.00th=[ 2384], 99.50th=[ 2480], 99.90th=[ 2768], 99.95th=[ 3088],
     | 99.99th=[ 6880]
    bw (KB/s)  : min= 7080, max= 7992, per=100.00%, avg=7849.21, stdev=89.82
    lat (usec) : 750=0.01%, 1000=0.01%
    lat (msec) : 2=64.51%, 4=35.48%, 10=0.01%, 50=0.01%
  cpu          : usr=1.65%, sys=5.03%, ctx=89829, majf=0, minf=26
  IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=117650/w=0/d=0, short=r=0/w=0/d=0
rand-read: (groupid=1, jobs=1): err= 0: pid=7828
  read : io=344332KB, bw=5738.6KB/s, iops=1434 , runt= 60003msec
    slat (usec): min=3 , max=298 , avg=18.09, stdev= 9.59
    clat (usec): min=887 , max=6981 , avg=2764.00, stdev=694.65
     lat (usec): min=995 , max=6996 , avg=2782.73, stdev=694.59
    clat percentiles (usec):
     |  1.00th=[ 1848],  5.00th=[ 1960], 10.00th=[ 1976], 20.00th=[ 2096],
     | 30.00th=[ 2128], 40.00th=[ 2608], 50.00th=[ 2736], 60.00th=[ 2832],
     | 70.00th=[ 2928], 80.00th=[ 3376], 90.00th=[ 3600], 95.00th=[ 4128],
     | 99.00th=[ 4832], 99.50th=[ 5024], 99.90th=[ 5728], 99.95th=[ 6112],
     | 99.99th=[ 6688]
    bw (KB/s)  : min= 5632, max= 5800, per=100.00%, avg=5742.82, stdev=27.33
    lat (usec) : 1000=0.01%
    lat (msec) : 2=13.36%, 4=80.18%, 10=6.46%
  cpu          : usr=1.42%, sys=4.42%, ctx=87501, majf=0, minf=25
  IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=86083/w=0/d=0, short=r=0/w=0/d=0
seq-write: (groupid=2, jobs=1): err= 0: pid=7832
  write: io=40480KB, bw=690824 B/s, iops=168 , runt= 60003msec
    slat (msec): min=1 , max=71 , avg= 5.91, stdev=11.88
    clat (usec): min=11 , max=77132 , avg=17788.60, stdev=18686.66
     lat (msec): min=2 , max=111 , avg=23.70, stdev=21.99
    clat percentiles (usec):
     |  1.00th=[ 6368],  5.00th=[ 6688], 10.00th=[ 6816], 20.00th=[ 6944],
     | 30.00th=[ 7008], 40.00th=[ 7072], 50.00th=[ 7136], 60.00th=[ 7200],
     | 70.00th=[ 7456], 80.00th=[39168], 90.00th=[39680], 95.00th=[39680],
     | 99.00th=[76288], 99.50th=[76288], 99.90th=[77312], 99.95th=[77312],
     | 99.99th=[77312]
    bw (KB/s)  : min=  597, max=  726, per=100.00%, avg=675.17, stdev=47.46
    lat (usec) : 20=0.01%
    lat (msec) : 4=0.01%, 10=71.88%, 50=23.42%, 100=4.68%
  cpu          : usr=0.49%, sys=2.05%, ctx=10731, majf=0, minf=22
  IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=10120/d=0, short=r=0/w=0/d=0
rand-write: (groupid=3, jobs=1): err= 0: pid=7875
  write: io=40212KB, bw=686021 B/s, iops=167 , runt= 60023msec
    slat (msec): min=2 , max=71 , avg= 5.95, stdev=11.94
    clat (usec): min=10 , max=77297 , avg=17916.27, stdev=18776.67
     lat (msec): min=8 , max=111 , avg=23.87, stdev=22.09
    clat percentiles (usec):
     |  1.00th=[ 6560],  5.00th=[ 6816], 10.00th=[ 6944], 20.00th=[ 7008],
     | 30.00th=[ 7072], 40.00th=[ 7136], 50.00th=[ 7200], 60.00th=[ 7264],
     | 70.00th=[ 7520], 80.00th=[39168], 90.00th=[39680], 95.00th=[39680],
     | 99.00th=[76288], 99.50th=[77312], 99.90th=[77312], 99.95th=[77312],
     | 99.99th=[77312]
    bw (KB/s)  : min=  582, max=  718, per=100.00%, avg=670.32, stdev=44.67
    lat (usec) : 20=0.01%
    lat (msec) : 10=71.85%, 50=23.46%, 100=4.69%
  cpu          : usr=0.46%, sys=2.14%, ctx=10674, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=10053/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=470600KB, aggrb=7843KB/s, minb=7843KB/s, maxb=7843KB/s, mint=60002msec, maxt=60002msec

Run status group 1 (all jobs):
   READ: io=344332KB, aggrb=5738KB/s, minb=5738KB/s, maxb=5738KB/s, mint=60003msec, maxt=60003msec

Run status group 2 (all jobs):
  WRITE: io=40480KB, aggrb=674KB/s, minb=674KB/s, maxb=674KB/s, mint=60003msec, maxt=60003msec

Run status group 3 (all jobs):
  WRITE: io=40212KB, aggrb=669KB/s, minb=669KB/s, maxb=669KB/s, mint=60023msec, maxt=60023msec

Disk stats (read/write):
  sdb: ios=174042/20172, merge=29691/0, ticks=412897/117376, in_queue=529790, util=98.65%
merkaba:~> umount /mnt/zeit



merkaba:~> mkfs.ext4 /dev/sdb1
mke2fs 1.42.5 (29-Jul-2012)
Dateisystem-Label=
OS-Typ: Linux
Blockgröße=4096 (log=2)
[…]
merkaba:~> mount /dev/sdb1 /mnt/zeit        
merkaba:~> fio /tmp/usb-stick.job   
seq-read: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
rand-read: (g=1): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
seq-write: (g=2): rw=write, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
rand-write: (g=3): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=4
2.0.8
Starting 4 processes
seq-read: Laying out IO file(s) (1 file(s) / 512MB)
Jobs: 1 (f=1): [___w] [57.2% done] [0K/131K /s] [0 /32  iops] [eta 03m:00s]      
seq-read: (groupid=0, jobs=1): err= 0: pid=8271
  read : io=467860KB, bw=7797.5KB/s, iops=1949 , runt= 60002msec
    slat (usec): min=2 , max=933 , avg=18.24, stdev=10.59
    clat (usec): min=728 , max=112945 , avg=2028.78, stdev=911.01
     lat (usec): min=775 , max=112959 , avg=2047.63, stdev=910.94
    clat percentiles (usec):
     |  1.00th=[ 1864],  5.00th=[ 1944], 10.00th=[ 1960], 20.00th=[ 1960],
     | 30.00th=[ 1976], 40.00th=[ 1976], 50.00th=[ 1976], 60.00th=[ 1992],
     | 70.00th=[ 2008], 80.00th=[ 2096], 90.00th=[ 2128], 95.00th=[ 2224],
     | 99.00th=[ 2384], 99.50th=[ 2480], 99.90th=[ 2864], 99.95th=[ 3184],
     | 99.99th=[55040]
    bw (KB/s)  : min= 5538, max= 7984, per=100.00%, avg=7805.33, stdev=262.86
    lat (usec) : 750=0.01%, 1000=0.01%
    lat (msec) : 2=64.92%, 4=35.05%, 10=0.01%, 50=0.01%, 100=0.01%
    lat (msec) : 250=0.01%
  cpu          : usr=1.58%, sys=5.43%, ctx=89023, majf=0, minf=26
  IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=116965/w=0/d=0, short=r=0/w=0/d=0
rand-read: (groupid=1, jobs=1): err= 0: pid=8282
  read : io=334860KB, bw=5580.8KB/s, iops=1395 , runt= 60003msec
    slat (usec): min=4 , max=346 , avg=23.79, stdev=11.60
    clat (usec): min=819 , max=7300 , avg=2835.92, stdev=710.54
     lat (usec): min=945 , max=7318 , avg=2861.00, stdev=710.61
    clat percentiles (usec):
     |  1.00th=[ 1912],  5.00th=[ 1976], 10.00th=[ 2064], 20.00th=[ 2096],
     | 30.00th=[ 2224], 40.00th=[ 2704], 50.00th=[ 2832], 60.00th=[ 2864],
     | 70.00th=[ 2992], 80.00th=[ 3472], 90.00th=[ 3696], 95.00th=[ 4192],
     | 99.00th=[ 4960], 99.50th=[ 5216], 99.90th=[ 5856], 99.95th=[ 6240],
     | 99.99th=[ 6816]
    bw (KB/s)  : min= 5504, max= 5640, per=100.00%, avg=5584.81, stdev=22.35
    lat (usec) : 1000=0.01%
    lat (msec) : 2=7.52%, 4=85.09%, 10=7.39%
  cpu          : usr=1.77%, sys=5.29%, ctx=86411, majf=0, minf=25
  IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=83715/w=0/d=0, short=r=0/w=0/d=0
seq-write: (groupid=2, jobs=1): err= 0: pid=8301
  write: io=53900KB, bw=919295 B/s, iops=224 , runt= 60039msec
    slat (usec): min=3 , max=87697 , avg=91.25, stdev=1634.30
    clat (msec): min=2 , max=126 , avg=17.72, stdev=20.48
     lat (msec): min=2 , max=135 , avg=17.81, stdev=20.61
    clat percentiles (msec):
     |  1.00th=[    7],  5.00th=[    7], 10.00th=[    7], 20.00th=[    7],
     | 30.00th=[    7], 40.00th=[    8], 50.00th=[    8], 60.00th=[    8],
     | 70.00th=[    8], 80.00th=[   39], 90.00th=[   40], 95.00th=[   80],
     | 99.00th=[   81], 99.50th=[   81], 99.90th=[   85], 99.95th=[   90],
     | 99.99th=[  125]
    bw (KB/s)  : min=  780, max=  958, per=100.00%, avg=897.22, stdev=22.03
    lat (msec) : 4=0.08%, 10=74.52%, 20=0.03%, 50=19.01%, 100=6.32%
    lat (msec) : 250=0.04%
  cpu          : usr=0.60%, sys=1.69%, ctx=10666, majf=0, minf=22
  IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=13475/d=0, short=r=0/w=0/d=0
rand-write: (groupid=3, jobs=1): err= 0: pid=8672
  write: io=7520.0KB, bw=128085 B/s, iops=31 , runt= 60120msec
    slat (usec): min=12 , max=132582 , avg=662.60, stdev=8065.44
    clat (msec): min=6 , max=314 , avg=127.16, stdev=41.47
     lat (msec): min=6 , max=314 , avg=127.82, stdev=41.47
    clat percentiles (msec):
     |  1.00th=[   38],  5.00th=[   64], 10.00th=[   77], 20.00th=[   94],
     | 30.00th=[   99], 40.00th=[  120], 50.00th=[  127], 60.00th=[  131],
     | 70.00th=[  149], 80.00th=[  159], 90.00th=[  182], 95.00th=[  202],
     | 99.00th=[  247], 99.50th=[  251], 99.90th=[  306], 99.95th=[  314],
     | 99.99th=[  314]
    bw (KB/s)  : min=   98, max=  143, per=99.86%, avg=124.83, stdev= 7.49
    lat (msec) : 10=0.05%, 20=0.05%, 50=2.61%, 100=29.41%, 250=67.13%
    lat (msec) : 500=0.74%
  cpu          : usr=0.16%, sys=0.34%, ctx=1904, majf=0, minf=20
  IO depths    : 1=0.1%, 2=0.1%, 4=99.8%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=1880/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=467860KB, aggrb=7797KB/s, minb=7797KB/s, maxb=7797KB/s, mint=60002msec, maxt=60002msec

Run status group 1 (all jobs):
   READ: io=334860KB, aggrb=5580KB/s, minb=5580KB/s, maxb=5580KB/s, mint=60003msec, maxt=60003msec

Run status group 2 (all jobs):
  WRITE: io=53900KB, aggrb=897KB/s, minb=897KB/s, maxb=897KB/s, mint=60039msec, maxt=60039msec

Run status group 3 (all jobs):
  WRITE: io=7520KB, aggrb=125KB/s, minb=125KB/s, maxb=125KB/s, mint=60120msec, maxt=60120msec

Disk stats (read/write):
  sdb: ios=171292/11991, merge=29388/3441, ticks=411887/417030, in_queue=828667, util=99.78%

merkaba:~> umount /mnt/zeit




On read F2FS and Ext4 have similar results.

Ext4 is a bit faster on sequential writes here, which contradicts dd
from above.

But F2FS is a lot, a huge lot faster on random writes!


I wonder how that is related to the iodepth I used. (Copied over from
ssd-test fio example file.). According to fio it did use iodepth 4. I wonder
about reasonable value for testing.


This has just been some initial testing. I wonder about good tests that mimic
typical use cases. What are the usecases?

- SD cards: photos, music files for portable players. smartphones, pads
with Android?

- USB-Sticks: random files users puts there, live distributions like GRML
and distro installers

Unless lots of small files stored or Linux being booted, its more larger
block size I/O it seems to me. Android likely deals with small files as
well. (I do not use a smartphone yet.)


While I use an USB stick to boot up Debian on my ASUS WL-500gP DSL router
that may not be a wide-spread usecase.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
