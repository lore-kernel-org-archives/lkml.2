Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab0GGVgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:36:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452Ab0GGVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:36:09 -0400
Date: Wed, 7 Jul 2010 14:36:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-07-01-12-19 uploaded (mmc)
Message-Id: <20100707143601.b6cf13f4.akpm@linux-foundation.org>
In-Reply-To: <20100701162842.2ecafbbb.randy.dunlap@oracle.com>
References: <201007011948.o61JmnT2022795@imap1.linux-foundation.org>
	<20100701162842.2ecafbbb.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010 16:28:42 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 01 Jul 2010 12:19:51 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2010-07-01-12-19 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.35-rc3:
> 
> 
> mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch:
> 
> if CONFIG_PM is not enabled:
> 
> (.text+0xc380c4): undefined reference to `mmc_pm_notify'
> 

Thanks.  This, I guess:

--- a/include/linux/mmc/host.h~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix
+++ a/include/linux/mmc/host.h
@@ -258,8 +258,12 @@ int mmc_card_can_sleep(struct mmc_host *
 int mmc_host_enable(struct mmc_host *host);
 int mmc_host_disable(struct mmc_host *host);
 int mmc_host_lazy_disable(struct mmc_host *host);
+#ifdef CONFIG_PM
 int mmc_pm_notify(struct notifier_block *notify_block, unsigned long mode,
 		  void *unused);
+#else
+#define mmc_pm_notify NULL
+#endif
 
 static inline void mmc_set_disable_delay(struct mmc_host *host,
 					 unsigned int disable_delay)
_

