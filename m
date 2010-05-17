Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0EQFo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:44:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51500 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab0EQFoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:44:54 -0400
Date: Mon, 17 May 2010 15:44:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the staging-next tree with the rr tree
Message-Id: <20100517154452.93fbac66.sfr@canb.auug.org.au>
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
9080984577cb3e04226d94c8f733534b60541f01
("param:remove-useless-writable-charp") from the rr tree and commit
bbfb56520c8da666383c08220985495ff918d4ad ("") from the staging-next tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/rtl8187se/r8180_core.c
index b09ce4b,dacefea..0000000
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@@ -74,15 -74,15 +74,15 @@@ MODULE_AUTHOR("Andrea Merello <andreamr
  MODULE_DESCRIPTION("Linux driver for Realtek RTL8180 / RTL8185 WiFi cards");
  
  
 -module_param(ifname, charp, S_IRUGO|S_IWUSR);
 +module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
- module_param(hwseqnum,int, S_IRUGO|S_IWUSR);
- module_param(hwwep,int, S_IRUGO|S_IWUSR);
- module_param(channels,int, S_IRUGO|S_IWUSR);
+ module_param(hwseqnum, int, S_IRUGO|S_IWUSR);
+ module_param(hwwep, int, S_IRUGO|S_IWUSR);
+ module_param(channels, int, S_IRUGO|S_IWUSR);
  
- MODULE_PARM_DESC(devname," Net interface name, wlan%d=default");
- MODULE_PARM_DESC(hwseqnum," Try to use hardware 802.11 header sequence numbers. Zero=default");
- MODULE_PARM_DESC(hwwep," Try to use hardware WEP support. Still broken and not available on all cards");
- MODULE_PARM_DESC(channels," Channel bitmask for specific locales. NYI");
+ MODULE_PARM_DESC(devname, " Net interface name, wlan%d=default");
+ MODULE_PARM_DESC(hwseqnum, " Try to use hardware 802.11 header sequence numbers. Zero=default");
+ MODULE_PARM_DESC(hwwep, " Try to use hardware WEP support. Still broken and not available on all cards");
+ MODULE_PARM_DESC(channels, " Channel bitmask for specific locales. NYI");
  
  
  static int __devinit rtl8180_pci_probe(struct pci_dev *pdev,
@@@ -3608,16 -3606,16 +3606,16 @@@ static int __devinit rtl8180_pci_probe(
  	dev->netdev_ops = &rtl8180_netdev_ops;
  	dev->wireless_handlers = &r8180_wx_handlers_def;
  
- 	dev->type=ARPHRD_ETHER;
+ 	dev->type = ARPHRD_ETHER;
  	dev->watchdog_timeo = HZ*3;
  
- 	if (dev_alloc_name(dev, ifname) < 0){
-                 DMESG("Oops: devname already taken! Trying wlan%%d...\n");
+ 	if (dev_alloc_name(dev, ifname) < 0) {
+ 		DMESG("Oops: devname already taken! Trying wlan%%d...\n");
 -		ifname = "wlan%d";
 +		strcpy(ifname, "wlan%d");
  		dev_alloc_name(dev, ifname);
-         }
+ 	}
  
- 	if(rtl8180_init(dev)!=0){
+ 	if (rtl8180_init(dev) != 0) {
  		DMESG("Initialization failed");
  		goto fail1;
  	}
