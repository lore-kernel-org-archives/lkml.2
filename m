Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab2FEJQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:16:46 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:59236 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752494Ab2FEJQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:16:45 -0400
From: Ondrej Zary <linux@rainbow-software.org>
Subject: [bisected] NFS corruption with 3.4
Date: Tue, 5 Jun 2012 11:16:17 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1266
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201206051116.17711.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I use NFS for deploying HDD images on new machines. My machine has 2nd network 
card just for this, running DHCPD, TFTPD and kernel NFS server. The target 
machine is set to boot from LAN and boots SystemRescueCD from my machine with 
an autorun script that launches Partimage and deploys the HDD image (400 to 
900 MB compressed).

It worked fine for years, until now. With kernel 3.4, everyting 
works only for the first time after boot (and not always). Next time (next 
machine), partimage aborts almost immediately as it's probably unable to 
decompress the image file. md5sum is different on my machine vs. on the 
target (through NFS). Also SystemRescueCD boot aborts with md5 error 
sometimes. Everything works fine after rebooting back to 3.3.

Bisection found this:

0fc9d1040313047edf6a39fd4d7c7defdca97c62 is the first bad commit
commit 0fc9d1040313047edf6a39fd4d7c7defdca97c62
Author: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date:   Wed Mar 28 14:42:54 2012 -0700

    radix-tree: use iterators in find_get_pages* functions

Reverting this commit in 3.4 fixes the problem.


-- 
Ondrej Zary
