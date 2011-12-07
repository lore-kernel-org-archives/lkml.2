Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1LGJfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:35:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51955 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab1LGJfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:35:19 -0500
Date: Wed, 7 Dec 2011 10:35:14 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Cong Wang <amwang@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] highmem: fix missed kmap_atomic update in
 arch/arm/include/asm/highmem.h
Message-ID: <20111207093514.GI4585@pengutronix.de>
References: <1323249719.27710.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1323249719.27710.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 05:21:59PM +0800, Axel Lin wrote:
> commit 37bfbb "highmem: kill all __kmap_atomic()" missed the update to
> arch/arm/include/asm/highmem.h.
> 
> This patch fixes below build error:
>   CC      init/main.o
> In file included from include/linux/pagemap.h:10,
>                  from include/linux/mempolicy.h:70,
>                  from init/main.c:49:
> include/linux/highmem.h: In function 'kmap_atomic_deprecated':
> include/linux/highmem.h:127: error: implicit declaration of function 'kmap_atomic'
> include/linux/highmem.h:127: warning: return makes pointer from integer without a cast
> include/linux/highmem.h: In function 'clear_highpage':
> include/linux/highmem.h:218: warning: initialization makes pointer from integer without a cast
> include/linux/highmem.h: In function 'zero_user_segments':
> include/linux/highmem.h:227: warning: initialization makes pointer from integer without a cast
> include/linux/highmem.h: In function 'copy_highpage':
> include/linux/highmem.h:279: warning: assignment makes pointer from integer without a cast
> include/linux/highmem.h:280: warning: assignment makes pointer from integer without a cast
> make[1]: *** [init/main.o] Error 1
> make: *** [init] Error 2
Already reported and fixed, see

	http://thread.gmane.org/gmane.linux.kernel/1225278

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
