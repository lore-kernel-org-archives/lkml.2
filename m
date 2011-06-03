Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1FCFKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:10:23 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:44053 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1FCFKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:10:20 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jun 2011 01:10:20 EDT
Message-ID: <4DE86B3D.1080806@reinelt.co.at>
Date: Fri, 03 Jun 2011 07:03:57 +0200
From: Michael Reinelt <michael@reinelt.co.at>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.0.7) Gecko/20061013 Thunderbird/1.5.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: mtrr_cleanup: can not find optimal value
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I'm suffering bad graphic performance on my notebook, and when sorting things out, I found the following in dmesg:

mtrr_cleanup: can not find optimal value
please specify mtrr_gran_size/mtrr_chunk_size

and later:

mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[drm] MTRR allocation failed.  Graphics performance may suffer.

which is probably due to the fact that MTRR's can't be cleaned (at least I suspect so)

The notebook is a Fujitsu Liefbook E8410, Intel Core2 Duo CPU T7700 @ 2.40GHz, and 8 GB RAM, graphics is Intel Mobile 
GM965/GL960, kernel is a vanilla 2.6.39 X86_64

When I remove 1 RAM module (using 4GB only) the messages above disappear. Unfortunately, graphic performance is still 
bad, but that's another story. I want to fix the MTRR issue anyway.

I think the MTRR cleaner is unable to find a really optimal combination, and wants me to specify one of the sub-optimal 
configs. But I have no idea how to do that, and found nothing in the net. I found some references to a "mtrr-uncover" 
program, but I cannot compile it (probably because its too old). So I'm asking for some advice how to manually tune the 
MTRR's.

When running with 4G, the relevant parts of dmesg are:

MTRR default type: uncachable
MTRR fixed ranges enabled:
   00000-9FFFF write-back
   A0000-BFFFF uncachable
   C0000-CFFFF write-protect
   D0000-DFFFF uncachable
   E0000-FFFFF write-protect
MTRR variable ranges enabled:
   0 base 0D0000000 mask FF0000000 uncachable
   1 base 0E0000000 mask FE0000000 uncachable
   2 base 000000000 mask F00000000 write-back
   3 base 100000000 mask FE0000000 write-back
   4 base 120000000 mask FF0000000 write-back
   5 base 0CF700000 mask FFFF00000 uncachable
   6 base 0CF800000 mask FFF800000 uncachable
   7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 3328MB, range: 256MB, type UC
reg 1, base: 3584MB, range: 512MB, type UC
reg 2, base: 0GB, range: 4GB, type WB
reg 3, base: 4GB, range: 512MB, type WB
reg 4, base: 4608MB, range: 256MB, type WB
reg 5, base: 3319MB, range: 1MB, type UC
reg 6, base: 3320MB, range: 8MB, type UC
total RAM covered: 4087M
Found optimal setting for mtrr clean up
  gran_size: 64K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3GB, range: 256MB, type WB
reg 3, base: 3319MB, range: 1MB, type UC
reg 4, base: 3320MB, range: 8MB, type UC
reg 5, base: 4GB, range: 512MB, type WB
reg 6, base: 4608MB, range: 256MB, type WB
e820 update range: 00000000cf700000 - 0000000100000000 (usable) ==> (reserved)



and with 8GB:

MTRR default type: uncachable
MTRR fixed ranges enabled:
   00000-9FFFF write-back
   A0000-BFFFF uncachable
   C0000-CFFFF write-protect
   D0000-DFFFF uncachable
   E0000-FFFFF write-protect
MTRR variable ranges enabled:
   0 base 0D0000000 mask FF0000000 uncachable
   1 base 0E0000000 mask FE0000000 uncachable
   2 base 000000000 mask E00000000 write-back
   3 base 200000000 mask FE0000000 write-back
   4 base 220000000 mask FF0000000 write-back
   5 base 0CF700000 mask FFFF00000 uncachable
   6 base 0CF800000 mask FFF800000 uncachable
   7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 3328MB, range: 256MB, type UC
reg 1, base: 3584MB, range: 512MB, type UC
reg 2, base: 0GB, range: 8GB, type WB
reg 3, base: 8GB, range: 512MB, type WB
reg 4, base: 8704MB, range: 256MB, type WB
reg 5, base: 3319MB, range: 1MB, type UC
reg 6, base: 3320MB, range: 8MB, type UC
total RAM covered: 8183M
  gran_size: 64K 	chunk_size: 64K 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 64K 	chunk_size: 128K 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 64K 	chunk_size: 256K 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 64K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 64K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 64K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 64K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 64K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 64K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 64K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 64K 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 64K 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 64K 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 0G
*BAD*gran_size: 64K 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: -256M
  gran_size: 64K 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 0G
*BAD*gran_size: 64K 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: -1G
  gran_size: 128K 	chunk_size: 128K 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 128K 	chunk_size: 256K 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 128K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 128K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 128K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 128K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 128K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 128K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 128K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 128K 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 128K 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 128K 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 0G
*BAD*gran_size: 128K 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: -256M
  gran_size: 128K 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 0G
*BAD*gran_size: 128K 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: -1G
  gran_size: 256K 	chunk_size: 256K 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 256K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 256K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 256K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 256K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 256K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 256K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 256K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 256K 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 256K 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 256K 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 0G
*BAD*gran_size: 256K 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: -256M
  gran_size: 256K 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 0G
*BAD*gran_size: 256K 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: -1G
  gran_size: 512K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 512K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 512K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 512K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 512K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 512K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 512K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 512K 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 512K 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 512K 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 0G
*BAD*gran_size: 512K 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: -256M
  gran_size: 512K 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 0G
*BAD*gran_size: 512K 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: -1G
  gran_size: 1M 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 1M 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 1M 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 1M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 4864M
  gran_size: 1M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 1M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 1M 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 1M 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 0G
  gran_size: 1M 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 0G
*BAD*gran_size: 1M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: -256M
  gran_size: 1M 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 0G
*BAD*gran_size: 1M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: -1G
  gran_size: 2M 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 2M 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 2M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 4865M
  gran_size: 2M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 1M
  gran_size: 2M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 1M
  gran_size: 2M 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 1M
  gran_size: 2M 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 1M
  gran_size: 2M 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 1M
*BAD*gran_size: 2M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: -255M
  gran_size: 2M 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 1M
*BAD*gran_size: 2M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: -1023M
  gran_size: 4M 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 771M
  gran_size: 4M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 4867M
  gran_size: 4M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 3M
  gran_size: 4M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 3M
  gran_size: 4M 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 3M
  gran_size: 4M 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 3M
  gran_size: 4M 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 3M
*BAD*gran_size: 4M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: -253M
  gran_size: 4M 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 3M
*BAD*gran_size: 4M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: -1021M
  gran_size: 8M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 263M
  gran_size: 8M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 263M
  gran_size: 8M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 7M
  gran_size: 8M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 7M
  gran_size: 8M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 7M
  gran_size: 8M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 7M
  gran_size: 8M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 7M
  gran_size: 8M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 7M
  gran_size: 8M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 7M
  gran_size: 16M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 263M
  gran_size: 16M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 7M
  gran_size: 16M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 7M
  gran_size: 16M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 7M
  gran_size: 16M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 7M
  gran_size: 16M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 7M
  gran_size: 16M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 7M
  gran_size: 16M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 7M
  gran_size: 32M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 23M
  gran_size: 32M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 23M
  gran_size: 32M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 23M
  gran_size: 32M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 23M
  gran_size: 32M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 23M
  gran_size: 32M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 23M
  gran_size: 32M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 23M
  gran_size: 64M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 55M
  gran_size: 64M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 55M
  gran_size: 64M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 55M
  gran_size: 64M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 55M
  gran_size: 64M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 55M
  gran_size: 64M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 55M
  gran_size: 128M 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 119M
  gran_size: 128M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 119M
  gran_size: 128M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 119M
  gran_size: 128M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 119M
  gran_size: 128M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 119M
  gran_size: 256M 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 247M
  gran_size: 256M 	chunk_size: 512M 	num_reg: 5  	lose cover RAM: 247M
  gran_size: 256M 	chunk_size: 1G 	num_reg: 5  	lose cover RAM: 247M
  gran_size: 256M 	chunk_size: 2G 	num_reg: 6  	lose cover RAM: 247M
  gran_size: 512M 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 503M
  gran_size: 512M 	chunk_size: 1G 	num_reg: 5  	lose cover RAM: 503M
  gran_size: 512M 	chunk_size: 2G 	num_reg: 6  	lose cover RAM: 503M
  gran_size: 1G 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 1015M
  gran_size: 1G 	chunk_size: 2G 	num_reg: 3  	lose cover RAM: 1015M
  gran_size: 2G 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 2039M
mtrr_cleanup: can not find optimal value
please specify mtrr_gran_size/mtrr_chunk_size
e820 update range: 00000000cf700000 - 0000000100000000 (usable) ==> (reserved)

Am I right that a optimal config would be one that
- is not marked as *BAD*
- has no "lose cover RAM"
- uses as few registers as possible?
- leaves at least one spare reg for DRM?


Thanks a bunch for your help!


regards, Michael

PS please CC me directly because I'm not subscribed!


-- 
Michael Reinelt <michael@reinelt.co.at>
http://home.pages.at/reinelt
GPG-Key 0xDF13BA50
ICQ #288386781
