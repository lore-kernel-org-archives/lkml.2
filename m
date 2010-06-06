Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0FFQXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 12:23:55 -0400
Received: from karen.lavabit.com ([72.249.41.33]:58457 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab0FFQXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 12:23:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=lavabit; d=lavabit.com;
  b=uGm55MOOSE0dz/WUlyrkrnvhSkGJ4Z5DorQXWqJZmL9tjyS/Fg+vgK9ev6LNjuJZKTaer8JX3ZQdh5xjoJAN/J2DhY5pv/KM9U8SxkHhzbmlJu4ZDj0qv7RBWe0akla2MA3yXzCGMl12tp9S4Yq/8IRYAHzw9LFSDHqtMnKyDtw=;
  h=Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
Message-ID: <4C0BE7AE.3000300@lavabit.com>
Date: Sun, 06 Jun 2010 20:23:42 +0200
From: Stuckey <stuckey@lavabit.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Can't read DVDs/CDs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Since upgrading to 2.6.32 I've been having issues reading DVDs/CDs. I've 
filled a bug report against the kernel in Debian (1) for this issue, 
which at least one other person seems to be able to confirm. I am 
assuming the device/discs in question are not at fault since they work 
with windows and mac.

Essentially, mounting a disc with "mount /dev/sr0/" yields varying error 
messages that usually say say there is no media on the disc or that the 
file system is bad. This isn't always the case though. For example here 
is what I've gotten just now while trying to mount a DVD+R:

stuckey@debian:~$ mount /dev/sr0
mount: only root can mount /dev/sr0 on /media/cdrom0
stuckey@debian:~$ su
Password:
root@debian:/home/stuckey# mount /dev/sr0
mount: /dev/sr0: unknown device
root@debian:/home/stuckey# mount /dev/sr0
mount: block device /dev/sr0 is write-protected, mounting read-only
mount: you must specify the filesystem type
root@debian:/home/stuckey# ls /media/cdrom0/
root@debian:/home/stuckey# mount /dev/sr0
mount: block device /dev/sr0 is write-protected, mounting read-only
mount: you must specify the filesystem type

In *DMESG* there is always the same output to be read:

[ 1921.647075] sr 4:0:0:0: [sr0] Unhandled sense code
[ 1921.647077] sr 4:0:0:0: [sr0] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 1921.647081] sr 4:0:0:0: [sr0] Sense Key : Hardware Error [current]
[ 1921.647084] sr 4:0:0:0: [sr0] Add. Sense: Timeout on logical unit
[ 1921.647088] sr 4:0:0:0: [sr0] CDB: Read(10): 28 00 00 05 08 7c 00 00 
02 00
[ 1921.647096] end_request: I/O error, dev sr0, sector 1319408
[ 1921.647099] Buffer I/O error on device sr0, logical block 164926
[ 1928.042773] sr 4:0:0:0: [sr0] Unhandled sense code
[ 1928.042775] sr 4:0:0:0: [sr0] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 1928.042778] sr 4:0:0:0: [sr0] Sense Key : Hardware Error [current]
[ 1928.042782] sr 4:0:0:0: [sr0] Add. Sense: Timeout on logical unit
[ 1928.042786] sr 4:0:0:0: [sr0] CDB: Read(10): 28 00 00 05 08 8a 00 00 
02 00
[ 1928.042794] end_request: I/O error, dev sr0, sector 1319464
[ 1928.042797] Buffer I/O error on device sr0, logical block 164933
[ 1934.437534] sr 4:0:0:0: [sr0] Unhandled sense code
[ 1934.437536] sr 4:0:0:0: [sr0] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 1934.437540] sr 4:0:0:0: [sr0] Sense Key : Hardware Error [current]
[ 1934.437543] sr 4:0:0:0: [sr0] Add. Sense: Timeout on logical unit
[ 1934.437547] sr 4:0:0:0: [sr0] CDB: Read(10): 28 00 00 05 08 8a 00 00 
02 00
[ 1934.437555] end_request: I/O error, dev sr0, sector 1319464
[ 1934.437558] Buffer I/O error on device sr0, logical block 164933
[ 1935.491758] ISO 9660 Extensions: RRIP_1991A
[ 1972.031786] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Down
[ 2144.660652] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<1000 Mbps 
Full Duplex>
[ 3207.908544] sr 4:0:0:0: [sr0] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3207.908548] sr 4:0:0:0: [sr0] Sense Key : Illegal Request [current]
[ 3207.908552] sr 4:0:0:0: [sr0] Add. Sense: Logical block address out 
of range
[ 3207.908557] sr 4:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 
01 00
[ 3207.908564] end_request: I/O error, dev sr0, sector 0
[ 3207.908567] Buffer I/O error on device sr0, logical block 0
[ 3207.909449] sr 4:0:0:0: [sr0] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3207.909452] sr 4:0:0:0: [sr0] Sense Key : Illegal Request [current]
[ 3207.909456] sr 4:0:0:0: [sr0] Add. Sense: Logical block address out 
of range
[ 3207.909459] sr 4:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 
01 00
[ 3207.909466] end_request: I/O error, dev sr0, sector 0
[ 3207.909468] Buffer I/O error on device sr0, logical block 0
[ 3208.892944] cdrom: This disc doesn't have any tracks I recognize!


[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=583949

