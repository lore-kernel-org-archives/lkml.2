Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2GUQei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 12:34:38 -0400
Received: from outbound04.telus.net ([199.185.220.223]:35848 "EHLO
	defout.telus.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751185Ab2GUQeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 12:34:37 -0400
X-Greylist: delayed 4586 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Jul 2012 12:34:36 EDT
X-Authority-Analysis: v=1.1 cv=hBb7OEh+R1D281K47mvLcGVRc+o7ruFinpkEL/5JQxM=
 c=1 sm=2 a=8iEie87WbnsA:10 a=N1hybo_V4eQA:10 a=8nJEP1OIZ-IA:10
 a=7JNzur8xsMFsb52eJ3sA:9 a=wPNLvfGTeEIA:10
X-Telus-Outbound-IP: 209.89.19.198
Message-ID: <500AC825.9070905@zonnet.nl>
Date: Sat, 21 Jul 2012 09:17:57 -0600
From: Jeroen van Bemmel <jbemmel@zonnet.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Extend procfs status for bonded links to show "backup" and "inactive"
 flags
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

bond_info_show_slave in /drivers/net/bonding/bond_procfs.c currently 
does not show all the information that is relevant to determine whether 
a given slave is used for network traffic or not. In certain 
active-backup setups, this means one can not easily tell what's happening.

An example patch to fix this:

diff --git a/drivers/net/bonding/bond_procfs.c 
b/drivers/net/bonding/bond_procfs.c
index 3cea38d..48ac2a4 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -169,6 +169,8 @@ static void bond_info_show_slave(struct seq_file *seq,

         seq_printf(seq, "\nSlave Interface: %s\n", slave->dev->name);
         seq_printf(seq, "MII Status: %s\n", 
bond_slave_link_status(slave->link));
+       seq_printf(seq, "Bond Status: backup=%d inactive=%d\n",
+               slave->backup, slave->inactive );
         if (slave->speed == SPEED_UNKNOWN)
                 seq_printf(seq, "Speed: %s\n", "Unknown");
         else

Thanks,
Jeroen van Bemmel
