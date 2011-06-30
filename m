Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1F3Kol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 06:44:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54560 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1F3Koe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 06:44:34 -0400
X-SecurityPolicyCheck-FJ: OK by FUJITSU ADVANCED ENGINEERING MailBarrier
Date: Thu, 30 Jun 2011 19:44:21 +0900
From: Daisuke Ogino <ogino.daisuke@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] procfs: returns ENOENT on opening the being-removed proc entry
Cc: linux-pci@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jbarnes@virtuousgeek.org, hch@infradead.org, akpm@linux-foundation.org,
        adobriyan@gmail.com
In-Reply-To: <20110627101944.b53cb3f0.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110624104509.6195.371AB99A@jp.fujitsu.com> <20110627101944.b53cb3f0.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20110630193941.8569.371AB99A@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Though I posted the following patch a week ago, 
there is no objection, and Kame-san reviewed it.

I hope merge it by someone if possible.
(I don't find maintainer's name for procfs.)

---
I changed the return value to ENOENT.
This return value is then returned when opening the proc entry 
that have been removed.
For example, open("/proc/bus/pci/XX/YY") during the corresponding 
device is being hot-removed.

Signed-off-by: Daisuke Ogino <ogino.daisuke@jp.fujitsu.com>
---
 fs/proc/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 74b48cf..7ed72d6 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -319,7 +319,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	if (!pde->proc_fops) {
 		spin_unlock(&pde->pde_unload_lock);
 		kfree(pdeo);
-		return -EINVAL;
+		return -ENOENT;
 	}
 	pde->pde_users++;
 	open = pde->proc_fops->open;
--

Thanks.
-- 
Daisuke Ogino


