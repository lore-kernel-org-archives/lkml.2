Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0FNRYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:24:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:34241 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab0FNRYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=m/QihKSoblUkzrLzo5qG/Mj1b0Gk9DeCMA10Mz2CSQ0kp2eOy35TsFd46od94AvhcV
         LhofcK3w22svwLeayfT8U8DqR7vAxolerYj6WCVhQ3aDIvV1s9cD/7YGRUhB7Z9gsfdV
         ktXIOvnTFly5SBTqiulTQeuQiJurXUBip8K0k=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: LKML <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
       wey-yi.w.guy@intel.com, ilw@linux.intel.com,
       linux-wireless@vger.kernel.org
Subject: [REGRESSION] [IWL3945] Broadcast is broken?
Date: Mon, 14 Jun 2010 19:24:23 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3; KDE/4.4.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006141924.24061.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware:
08:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] 
Network Connection (rev 02)

Last known good kernel: 2.6.34

Failing kernels: since 2.6.35-rc1 to 2.6.35-rc3

Symptoms:
During connect do wireless network authentication seems be OK, but I cannot 
get IP from dhcp serwer. I do:
echo 0x43fff > /sys/class/net/wlan0/device/debug_level

Syslog is here:
http://unixy.pl/maciek/download/kernel/2.6.35-rc3/gumis/syslog-before.txt

>From syslog I guess the problem is that it doesn't receive broadcast frames 
(but I'm not sure), so I try:
sudo ifconfig wlan0 promisc

Syslog:
http://unixy.pl/maciek/download/kernel/2.6.35-rc3/gumis/syslog-after.txt

And then I can get IP address.

Any advice?

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
