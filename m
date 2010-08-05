Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab0HEFah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:30:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52677 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758318Ab0HEFaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:30:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kZWyIrq7Zoy9r02cMBL5l7JSC8WvDMCVEuqMFXUaEMLklYTPipOBpQjQHQux2Nd7zN
         4+ku4+l+v9cJGRSUM0tNZOUQ0Wfjl59jH3kNPK10HA0Cua99PtS1s3KL22HDe/bQBK2l
         5ksJJV0ws7oCfgz1ImyI+CKBTAcwRdRcIeOzE=
Subject: Re: [PATCH] Change struct flchip_shared spinlock locking into mutex
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, Vasiliy Kulikov <segooon@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Jiri Slaby <jslaby@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1280984291.1175.15.camel@localhost.localdomain>
References: <1280778048-6208-1-git-send-email-stefani@seibold.net>
	 <1280984291.1175.15.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 08:30:21 +0300
Message-Id: <1280986221.1175.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 07:58 +0300, Artem Bityutskiy wrote:
> On Mon, 2010-08-02 at 21:40 +0200, stefani@seibold.net wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > This patch prevent to schedule while atomic by changing the
> > flchip_shared spinlock into a mutex. This should be save since no atomic
> > path will use this lock.
> > 
> > This patch is based on linux kernel 2.6.35. Please apply.
> > 
> > It was requested by Arnd Bergmann and Vasiliy Kulikov.
> 
> Taken to my l2-mtd-2.6.git / master

This patch causes the following compilation error:

drivers/mtd/lpddr/lpddr_cmds.c: In function ‘lpddr_cmdset’:
drivers/mtd/lpddr/lpddr_cmds.c:101: warning: passing argument 1 of ‘spinlock_check’ from incompatible pointer type
include/linux/spinlock.h:271: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct mutex *’
drivers/mtd/lpddr/lpddr_cmds.c:101: error: ‘struct mutex’ has no member named ‘rlock’
drivers/mtd/lpddr/lpddr_cmds.c: In function ‘get_chip’:
drivers/mtd/lpddr/lpddr_cmds.c:220: warning: passing argument 1 of ‘spin_lock’ from incompatible pointer type
include/linux/spinlock.h:282: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct mutex *’
drivers/mtd/lpddr/lpddr_cmds.c:233: warning: passing argument 1 of ‘spin_unlock’ from incompatible pointer type
include/linux/spinlock.h:322: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct mutex *’
drivers/mtd/lpddr/lpddr_cmds.c:248: warning: passing argument 1 of ‘spin_lock’ from incompatible pointer type
include/linux/spinlock.h:282: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct mutex *’
drivers/mtd/lpddr/lpddr_cmds.c:264: warning: passing argument 1 of ‘spin_unlock’ from incompatible pointer type
include/linux/spinlock.h:322: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct mutex *’
drivers/mtd/lpddr/lpddr_cmds.c:278: warning: passing argument 1 of ‘spin_unlock’ from incompatible pointer type
include/linux/spinlock.h:322: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct mutex *’
drivers/mtd/lpddr/lpddr_cmds.c: In function ‘put_chip’:
drivers/mtd/lpddr/lpddr_cmds.c:351: warning: passing argument 1 of ‘spin_lock’ from incompatible pointer type
include/linux/spinlock.h:282: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct mutex *’
drivers/mtd/lpddr/lpddr_cmds.c:359: warning: passing argument 1 of ‘spin_unlock’ from incompatible pointer type
include/linux/spinlock.h:322: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct mutex *’
drivers/mtd/lpddr/lpddr_cmds.c:377: warning: passing argument 1 of ‘spin_unlock’ from incompatible pointer type
include/linux/spinlock.h:322: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct mutex *’
drivers/mtd/lpddr/lpddr_cmds.c:381: warning: passing argument 1 of ‘spin_unlock’ from incompatible pointer type
include/linux/spinlock.h:322: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct mutex *’

Removed from my tree.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

