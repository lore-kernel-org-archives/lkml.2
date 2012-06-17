Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab2FQRpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 13:45:13 -0400
Received: from smtp.nexicom.net ([216.168.96.13]:49841 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757647Ab2FQRpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 13:45:12 -0400
Message-ID: <4FDE17A4.70605@lockie.ca>
Date: Sun, 17 Jun 2012 13:45:08 -0400
From: James <bjlockie@lockie.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120606 Thunderbird/13.0
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: boot change to /dev/sdc1 but still think it's /dev/sda2
References: <4FDD118D.7060703@lockie.ca>
In-Reply-To: <4FDD118D.7060703@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/12 19:06, James wrote:
> 
> I'm having a problem where I installed an SSD (/dev/sdc1) and even though I have grub set to
> root (hd0,0)
> kernel /boot/bzImage root=/dev/sdc1 rootfstype=ext4 raid=noautodetect
> it thinks my root is /dev/sda2 (my old boot). It is my ssd though (size, contents).
> 
> I read that I can try using the uuid:
> kernel /boot/bzImage root=/dev/disk/by-uuid/e2647271-08fb-4af5-9a6f-11283a521bbd rootfstype=ext4 raid=noautodetect
> My system won't boots bot won't load the kernel that way.
> 
> I took a pic of the oops, it's fuzzy but I think it is readable.
> http://lockie.ca/test/small_DSCN0077.JPG
> 
> My /etc/fstab
> UUID="a82c245a-5323-4eda-a094-fa2de81721a5"     /boot           ext2    noauto,noatime  0 0
> UUID="e2647271-08fb-4af5-9a6f-11283a521bbd"     /               ext4    defaults,auto,noatime,discard   0 0
> UUID="743d709c-766c-477a-a892-65808cae645d"     /other          ext4    defaults,auto,noatime   0 0
> UUID="b7c60eb6-5501-4f1e-9c05-a416770cc32f"     /storage        ext4    defaults,auto,noatime   0 0
> tmpfs                   /tmp            tmpfs   size=4G,mode=1777   0 0
> 

$ df
df: '/media/storage': No such file or directory
Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/sda2       87773488   9382636  73994992  12% /
/dev/sdb1      480647488 236183452 220044836  52% /storage
/dev/sda2      487820492 115553208 347848484  25% /home
/dev/sda2      487820492 115553208 347848484  25% /var
/dev/sdb1      480647488 236183452 220044836  52% /storage
/dev/sda2      487820492 115553208 347848484  25% /other
tmpfs            4194304   1446860   2747444  35% /tmp
shm              8165176         0   8165176   0% /dev/shm
/dev/sdb1      480647488 236183452 220044836  52% /storage

$ cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / ext4 rw,noatime,discard,data=ordered 0 0
devtmpfs /dev devtmpfs rw,relatime,size=8164956k,nr_inodes=2041239,mode=755 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /run tmpfs rw,nosuid,nodev,relatime,mode=755 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
configfs /sys/kernel/config configfs rw,nosuid,nodev,noexec,relatime 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620 0 0
shm /dev/shm tmpfs rw,nosuid,nodev,noexec,relatime 0 0
/dev/sda2 /other ext4 rw,noatime,data=ordered 0 0
tmpfs /tmp tmpfs rw,relatime,size=4194304k 0 0
shm /dev/shm tmpfs rw,nosuid,nodev,noexec,relatime 0 0
/dev/sdb1 /storage ext4 rw,noatime,data=ordered 0 0

$ mount
/dev/sda2 on / type ext4 (rw,noatime,discard,commit=0)
/dev/sdb1 on /storage type ext4 (rw,noatime)
/dev/sdb1 on /media/storage type ext4 (rw,noatime,commit=0)
/dev/sda2 on /home type ext4 (rw,noatime,commit=0)
/dev/sda2 on /var type ext4 (rw,noatime,commit=0)
/dev/sdb1 on /storage type ext4 (rw,noatime)
/dev/sda2 on /other type ext4 (rw,noatime,commit=0)
tmpfs on /tmp type tmpfs (rw,size=4G,mode=1777)
shm on /dev/shm type tmpfs (rw,noexec,nosuid,nodev)
/dev/sdb1 on /storage type ext4 (rw,noatime)

