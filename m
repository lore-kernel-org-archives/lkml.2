Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0EJFPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:15:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36375 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab0EJFPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:15:39 -0400
Date: Mon, 10 May 2010 15:15:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, John Church <j.church@ymail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: manual merge of the staging-next tree with the rr tree
Message-Id: <20100510151537.6e987af4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging-next tree got a conflict in
drivers/staging/rtl8187se/r8180_core.c between commit
db8b06bcf94dbd02fba2601bee81ac4d9a626095
("param:remove-useless-writable-charp") from the rr tree and commit
3992db8fcb2ead240f311fc3e212443c5e1c43b9 ("Staging: rtl8187se: fix coding
style issues in r8180_core.c") from the staging-next tree.

I fixed it up (see below) and can carry the fixes as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/rtl8187se/r8180_core.c
index b09ce4b,84a745b..0000000
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@@ -3612,10 -3614,10 +3614,10 @@@ static int __devinit rtl8180_pci_probe(
  	dev->watchdog_timeo = HZ*3;
  
  	if (dev_alloc_name(dev, ifname) < 0){
-                 DMESG("Oops: devname already taken! Trying wlan%%d...\n");
+ 		DMESG("Oops: devname already taken! Trying wlan%%d...\n");
 -		ifname = "wlan%d";
 +		strcpy(ifname, "wlan%d");
  		dev_alloc_name(dev, ifname);
-         }
+ 	}
  
  	if(rtl8180_init(dev)!=0){
  		DMESG("Initialization failed");
