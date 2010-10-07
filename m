Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0JGXt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:49:28 -0400
Received: from smtp12.ono.com ([62.42.230.20]:34991 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752969Ab0JGXtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:49:09 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 19:49:09 EDT
Date: Fri, 8 Oct 2010 01:43:18 +0200
From: "J.A. =?ISO-8859-1?B?TWFnYWxs824=?=" <jamagallon@ono.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Strange raid device numbering
Message-ID: <20101008014318.04d7ded1@werewolf.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

I'm running kernel 2.6.36-rc6.
I have just built a simple raid0 array with two disks, and I followed what I
had always done:

raid=/dev/md0
ndisk=2
disks="/dev/sda1 /dev/sdb1"
block=4
chunk=256

stride=$((chunk/block))
stripe=$((stride*ndisk))

for i in $disks
do
    mdadm --zero-superblock --force $i
done
mdadm -C -f -v $raid --level=0 --chunk=$chunk -n $ndisk $disks
sleep 5
mdadm -S $raid
mdadm --assemble $raid $disks
mkfs.ext4 -b $((block*1024)) -E stride=$stride,stripe-width=$stripe $raid

Strangely, after I reboot, the system insists in numbering it as
md127, instead of md0.

Why ?
How can I force it to be md0 ? (its half aesthetics, half curiosity...)

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
