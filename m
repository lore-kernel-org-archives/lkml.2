Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0JGVr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:47:58 -0400
Received: from asmtpout026.mac.com ([17.148.16.101]:56266 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0JGVr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:47:56 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
From: Elvis Dowson <elvis.dowson@mac.com>
Subject: kgdb errors with serial console
Date: Fri, 08 Oct 2010 01:47:09 +0400
Message-id: <BDD07355-7199-4A2E-8426-F6D43EA5D313@mac.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
        I'm getting the following errors when attempting to use kgdb with the serial console. Any idea how I can resolve this issue? 

The correct serial parameters when I use kermit with the target board is 

set flow-control off
set carrier-watch none
set speed 115200

and it connects correctly.

I'm not sure if the gdb configuration commands for the serial port are sufficient, and if there is a parameter that I am missing here. The host is connected to the target using an FTDI USB to serial converter, so it appears as /dev/ttyUSB0 on the host and as ttyS2 on the target.

# su
# cd /tool/patches/android-rowboat-froyo-2.2-patchwork/kernel
# arm-angstrom-linux-gnueabi-gdb
(gdb) file vmlinux
Reading symbols from /tool/patches/android-rowboat-froyo-2.2-patchwork/kernel/vmlinux...done.

(gdb) set remotebaud 115200
(gdb) set remoteflow 0
(gdb) set debug remote 1
(gdb) set debug serial 1
(gdb) target remote /dev/ttyUSB0

Remote debugging using /dev/ttyUSB0
Sending packet: $qSupported#37...[
r +]Ack
[$][q][S][u][p][p][o][r][t][e][d][#][3][7]Packet received: qSupported
Packet qSupported (supported-packets) is supported
warning: unrecognized item "qSupported" in "qSupported" response
Sending packet: $Hg0#df...[+]Ack
[$][H][g][0][#][d][f]Packet received: Hg0
Sending packet: $?#3f...[+]Ack
[$][?][#][3][f]Packet received: ?
Sending packet: $Hc-1#09...[+]Ack
[$][H][c][-][1][#][0][9]Packet received: Hc-1
Sending packet: $qC#b4...[+]Ack
[$][q][C][#][b][4]Packet received: qC
Sending packet: $qAttached#8f...[+]Ack
[$][q][A][t][t][a][c][h][e][d][#][8][f]Packet received: qAttached
Packet qAttached (query-attached) is supported
Sending packet: $qOffsets#4b...[+]Ack
[$][q][O][f][f][s][\r][\r][\n][e][t][s][#][4][b]Bad checksum, sentsum=0x4b, csum=0x6f, buf=qOffs\r\r\nets
[-][<Timeout: 2 seconds>]Timed out.
[-][<Timeout: 2 seconds>]Timed out.
Ignoring packet error, continuing...
Malformed response to offset query, qOffs
ets
(gdb) 


Best regards,

Elvis Dowson


