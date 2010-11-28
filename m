Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0K1JUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 04:20:54 -0500
Received: from mail.perches.com ([173.55.12.10]:1902 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab0K1JUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 04:20:50 -0500
Subject: Re: [PATCH 4/4] zd1211rw: remove unnecessary [kv][mcz]alloc casts
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <1290935566.3467.0.camel@jlt3.sipsolutions.net>
References: <cover.1290934782.git.joe@perches.com>
	 <704bdd89d630b364043ac7a9ec0a110d311a17a2.1290934782.git.joe@perches.com>
	 <1290935566.3467.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Nov 2010 01:20:47 -0800
Message-ID: <1290936047.16349.13.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-28 at 10:12 +0100, Johannes Berg wrote:
> On Sun, 2010-11-28 at 01:05 -0800, Joe Perches wrote:
> > diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
> > @@ -117,8 +117,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
> >  
> >  	/* Allocate a single memory block for values and addresses. */
> >  	count16 = 2*count;
> > -	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
> > -		                   GFP_KERNEL);
> > +	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)), GFP_KERNEL);
> I believe this is on purpose for sparse.

Perhaps in a previous version, but not now.

$ make C=1 drivers/net/wireless/zd1211rw/zd_chip.o
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHECK   drivers/net/wireless/zd1211rw/zd_chip.c
include/trace/events/kmem.h:45:1: error: Expected ( after asm
include/trace/events/kmem.h:45:1: error: got goto
include/trace/events/kmem.h:53:1: error: Expected ( after asm
include/trace/events/kmem.h:53:1: error: got goto
include/trace/events/kmem.h:99:1: error: Expected ( after asm
include/trace/events/kmem.h:99:1: error: got goto
include/trace/events/kmem.h:108:1: error: Expected ( after asm
include/trace/events/kmem.h:108:1: error: got goto
include/trace/events/kmem.h:136:1: error: Expected ( after asm
include/trace/events/kmem.h:136:1: error: got goto
include/trace/events/kmem.h:143:1: error: Expected ( after asm
include/trace/events/kmem.h:143:1: error: got goto
include/trace/events/kmem.h:150:1: error: Expected ( after asm
include/trace/events/kmem.h:150:1: error: got goto
include/trace/events/kmem.h:172:1: error: Expected ( after asm
include/trace/events/kmem.h:172:1: error: got goto
include/trace/events/kmem.h:194:1: error: Expected ( after asm
include/trace/events/kmem.h:194:1: error: got goto
include/trace/events/kmem.h:249:1: error: Expected ( after asm
include/trace/events/kmem.h:249:1: error: got goto
include/trace/events/kmem.h:256:1: error: Expected ( after asm
include/trace/events/kmem.h:256:1: error: got goto
include/trace/events/kmem.h:267:1: error: Expected ( after asm
include/trace/events/kmem.h:267:1: error: got goto
include/trace/events/module.h:18:1: error: Expected ( after asm
include/trace/events/module.h:18:1: error: got goto
include/trace/events/module.h:37:1: error: Expected ( after asm
include/trace/events/module.h:37:1: error: got goto
include/trace/events/module.h:79:1: error: Expected ( after asm
include/trace/events/module.h:79:1: error: got goto
include/trace/events/module.h:86:1: error: Expected ( after asm
include/trace/events/module.h:86:1: error: got goto
include/trace/events/module.h:94:1: error: Expected ( after asm
include/trace/events/module.h:94:1: error: got goto
/home/joe/linux/net-next-2.6-2/arch/x86/include/asm/uaccess_32.h:197:9: error: attribute 'error': unknown attribute
include/trace/events/irq.h:37:1: error: Expected ( after asm
include/trace/events/irq.h:37:1: error: got goto
include/trace/events/irq.h:67:1: error: Expected ( after asm
include/trace/events/irq.h:67:1: error: got goto
include/trace/events/irq.h:112:1: error: Expected ( after asm
include/trace/events/irq.h:112:1: error: got goto
include/trace/events/irq.h:126:1: error: Expected ( after asm
include/trace/events/irq.h:126:1: error: got goto
include/trace/events/irq.h:140:1: error: Expected ( after asm
include/trace/events/irq.h:140:1: error: got goto
include/trace/events/kmem.h:45:1: error: need constant string for inline asm
include/trace/events/kmem.h:45:1: error: incompatible types in comparison expression (different address spaces)
include/trace/events/kmem.h:45:1: error: need constant string for inline asm
include/trace/events/kmem.h:45:1: error: incompatible types in comparison expression (different address spaces)
include/trace/events/kmem.h:45:1: error: need constant string for inline asm
include/trace/events/kmem.h:45:1: error: incompatible types in comparison expression (different address spaces)
include/trace/events/kmem.h:45:1: error: need constant string for inline asm
include/trace/events/kmem.h:45:1: error: incompatible types in comparison expression (different address spaces)
  CC      drivers/net/wireless/zd1211rw/zd_chip.o
$ 


