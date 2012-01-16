Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2APEGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 23:06:36 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:60634 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab2APEGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 23:06:03 -0500
From: Maxim Uvarov <maxim.uvarov@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, wim@iguana.be, torvalds@linux-foundation.org,
        stable@vger.kernel.org, Thomas.Mingarelli@hp.com
Subject: hpwdt: clean up set_memory_x call for 32 bit
Date: Sun, 15 Jan 2012 20:02:49 -0800
Message-Id: <1326686570-19303-1-git-send-email-maxim.uvarov@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A02020A.4F13A219.004A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Please find clean up patch for hpwdt.

	There were 2 patches for the issue. Both do the same
but in different ways:

commit 0305d4e376508720be61a6500ded9b9390c9a136
Author: Maxim Uvarov <maxim.uvarov@oracle.com>
Date:   Thu Dec 22 16:03:34 2011 +1100

    drivers/watchdog/hpwdt.c: mark page executable

commit e67d668e147c3b4fec638c9e0ace04319f5ceccd
Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
Date:   Mon Nov 7 10:59:00 2011 +0100

    watchdog: hpwdt: Changes to handle NX secure bit in 32bit path

We decided to drop my patch(0305d4e37) and add author's (e67d668e1).
Both patches do the same things. But we missed that e67d668e1 calls
set_memory_x with wrong parameters. Right parameters are address aligned to
page and number of pages. Not address and size. First parameter with be auto-aligned
and set_memory_x() print  WARN, but second parameter is serious error.

We need to think how to avoid changing NX for not our pages in future and add additional
warning or call panic() in set_memory_x(). Maybe try to read the latest byte or all bytes
for that memory.

Best regards,
Maxim Uvarov.
