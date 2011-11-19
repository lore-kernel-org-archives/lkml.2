Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1KSNWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 08:22:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38432 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1KSNWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 08:22:23 -0500
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: Corey Minyard <minyard@acm.org>
Subject: ipmi_watchdog: IPMI Watchdog: response: Error 80 on cmd 22
Date: Sat, 19 Nov 2011 14:22:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-rc2-00132-gc5e0c78; KDE/4.7.3; x86_64; ; )
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111191422.17555.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I have few machines where ipmi_watchdog (from 3.0.9 kernel currently)
reports after some time:

IPMI Watchdog: response: Error 80 on cmd 22

In less than a week
# grep "Error 80 on cmd 22" /var/log/kernel |wc -l
378681

#define IPMI_WDOG_RESET_TIMER           0x22
but no idea what error 80 is.

It happens on systems like Supermicro H8DMU or Supermicro X8SIL
(few other supermicro servers don't show this problem)

Options used on all these systems are:
options ipmi_watchdog timeout=120 action=reset nowayout=1

Any ideas?

Nov 18 22:49:36 server1 kernel: [   27.229458] ipmi message handler version 39.2
Nov 18 22:49:36 server1 kernel: [   27.231966] IPMI System Interface driver.
Nov 18 22:49:36 server1 kernel: [   27.234635] ipmi_si: probing via SMBIOS
Nov 18 22:49:36 server1 kernel: [   27.234640] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
Nov 18 22:49:36 server1 kernel: [   27.234643] ipmi_si: Adding SMBIOS-specified kcs state machine
Nov 18 22:49:36 server1 kernel: [   27.234648] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
Nov 18 22:49:36 server1 kernel: [   27.377128] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x0028c5, prod_id: 0x0004, dev_id: 0x22)
Nov 18 22:49:36 server1 kernel: [   27.377139] ipmi_si ipmi_si.0: IPMI kcs interface initialized
Nov 18 22:49:36 server1 kernel: [   27.379406] ipmi device interface
Nov 18 22:50:09 server1 kernel: [   70.153536] IPMI Watchdog: driver initialized
Nov 19 00:28:39 server1 kernel: [ 9571.486912] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:44 server1 kernel: [ 9576.488498] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:44 server1 kernel: [ 9576.489910] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:44 server1 kernel: [ 9576.491111] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:44 server1 kernel: [ 9576.492273] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:44 server1 kernel: [ 9576.493445] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:44 server1 kernel: [ 9576.494604] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:49 server1 kernel: [ 9581.496078] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:54 server1 kernel: [ 9586.497404] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:54 server1 kernel: [ 9586.498773] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:54 server1 kernel: [ 9586.500072] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:54 server1 kernel: [ 9586.501268] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:54 server1 kernel: [ 9586.502472] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:54 server1 kernel: [ 9586.503669] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:28:59 server1 kernel: [ 9591.505118] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:29:04 server1 kernel: [ 9596.506447] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:29:04 server1 kernel: [ 9596.507853] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:29:04 server1 kernel: [ 9596.509093] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:29:04 server1 kernel: [ 9596.510372] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:29:04 server1 kernel: [ 9596.511607] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:29:04 server1 kernel: [ 9596.512819] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:29:09 server1 kernel: [ 9601.514268] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:29:14 server1 kernel: [ 9606.515579] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:29:14 server1 kernel: [ 9606.516990] IPMI Watchdog: response: Error 80 on cmd 22
Nov 19 00:29:14 server1 kernel: [ 9606.518223] IPMI Watchdog: response: Error 80 on cmd 22
[...]

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
