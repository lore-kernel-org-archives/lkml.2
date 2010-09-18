Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0IRET2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 00:19:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37247
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909Ab0IRET1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 00:19:27 -0400
Date: Fri, 17 Sep 2010 21:19:46 -0700 (PDT)
Message-Id: <20100917.211946.38301858.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks to the excellent detective work and patch written by
Wolfram Sang, we have a fix for along standing issue in IDE.

The procfs directory for devices underneath an IDE controller
instance is not created before we try to makes nodes in that
directory.

The problem doesn't happen if, for example, you build everything
IDE statically into your kernel.  This is because the individual
host controller drivers initialize first and probe the IDE
controllers.  But the CDROM, disk, et al. driver's haven't
setup yet.  They do so later, and at that point is when the
nodes in the procfs directory get created.  And this works in
this case because the procfs directory is setup by the time
those device type drivers initialize.

But if we register an IDE controller device after the CDROM,
disk, et al. IDE modules have setup, we hit the problem.

Please pull, thanks a lot!

The following changes since commit 03a7ab083e4d619136d6f07ce70fa9de0bc436fc:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2010-09-16 12:59:11 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Wolfram Sang (1):
      ide: Fix ordering of procfs registry.

 drivers/ide/ide-probe.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)
