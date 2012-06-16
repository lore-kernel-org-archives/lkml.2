Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2FQDVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 23:21:04 -0400
Received: from smtp.nexicom.net ([216.168.96.13]:57975 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315Ab2FQDVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 23:21:02 -0400
X-Greylist: delayed 833 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jun 2012 23:21:02 EDT
Message-ID: <4FDD118D.7060703@lockie.ca>
Date: Sat, 16 Jun 2012 19:06:53 -0400
From: James <bjlockie@lockie.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120606 Thunderbird/13.0
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: boot change to /dev/sdc1 but still think it's /dev/sda2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm having a problem where I installed an SSD (/dev/sdc1) and even though I have grub set to
root (hd0,0)
kernel /boot/bzImage root=/dev/sdc1 rootfstype=ext4 raid=noautodetect
it thinks my root is /dev/sda2 (my old boot). It is my ssd though (size, contents).

I read that I can try using the uuid:
kernel /boot/bzImage root=/dev/disk/by-uuid/e2647271-08fb-4af5-9a6f-11283a521bbd rootfstype=ext4 raid=noautodetect
My system won't boots bot won't load the kernel that way.

I took a pic of the oops, it's fuzzy but I think it is readable.
http://lockie.ca/test/small_DSCN0077.JPG

My /etc/fstab
UUID="a82c245a-5323-4eda-a094-fa2de81721a5"     /boot           ext2    noauto,noatime  0 0
UUID="e2647271-08fb-4af5-9a6f-11283a521bbd"     /               ext4    defaults,auto,noatime,discard   0 0
UUID="743d709c-766c-477a-a892-65808cae645d"     /other          ext4    defaults,auto,noatime   0 0
UUID="b7c60eb6-5501-4f1e-9c05-a416770cc32f"     /storage        ext4    defaults,auto,noatime   0 0
tmpfs                   /tmp            tmpfs   size=4G,mode=1777   0 0

rjl@cheetah ~ $ df
df: '/media/storage': No such file or directory
Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/sda2       87773488   9259380  74118248  12% /

kernel-3.5.0-rc2+
