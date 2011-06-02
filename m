Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab1FBDuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 23:50:46 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49625 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759062Ab1FBDup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 23:50:45 -0400
X-Nat-Received: from [202.181.97.72]:58736 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1306986609.25837
Message-Id: <201106020350.p523o95o094928@www262.sakura.ne.jp>
Subject: Preparation for Linux 3.0
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Jun 2011 12:50:09 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 02062011 #5456492, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that commit 55922c9d "Linux 3.0-rc1" caused
dhcp-client 2.0pl5-19.1sarge3 (in Debian Sarge) to report SIOCSIFNETMASK and
SIOCSIFBRDADDR errors (though, it seems to me that these errors are not
affecting the functionality).

  Setting up IP spoofing protection: rp_filter.
  Configuring network interfaces...Internet Software Consortium DHCP Client 2.0pl5
  Copyright 1995, 1996, 1997, 1998, 1999 The Internet Software Consortium.
  All rights reserved.
  
  Please contribute if you find this software useful.
  For info, please visit http://www.isc.org/dhcp-contrib.html
  
  [   21.081635] pcnet32 0000:02:00.0: eth0: link up
  SIOCSIFNETMASK: Cannot assign requested address
  SIOCSIFBRDADDR: Cannot assign requested address
  Listening on LPF/eth0/00:0c:29:9e:eb:32
  Sending on   LPF/eth0/00:0c:29:9e:eb:32
  Sending on   Socket/fallback/fallback-net
  DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 3
  DHCPOFFER from 192.168.1.254
  DHCPREQUEST on eth0 to 255.255.255.255 port 67
  DHCPACK from 192.168.1.254
  bound to 192.168.1.128 -- renewal in 43200 seconds.
  done.
  Starting portmap daemon: portmap.



I guess this program is doing something like below.

  if grep -q ^2.6 /proc/sys/kernel/osrelease
  then
    do ioctl for 2.6 kernels
  else
    do ioctl for 2.4 kernels
  fi

We need to widely announce that userland applications using branches based on
/proc/sys/kernel/osrelease need to be fixed.

Regards.
