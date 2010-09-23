Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab0IWDms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:42:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab0IWDmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:42:47 -0400
Date: Wed, 22 Sep 2010 20:43:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: mmotm 2010-09-22 - build error in drivers/staging/zram
Message-Id: <20100922204305.2fdc5b66.akpm@linux-foundation.org>
In-Reply-To: <56264.1285212366@localhost>
References: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org>
	<56264.1285212366@localhost>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 23:26:06 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 22 Sep 2010 16:12:09 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-09-22-16-11 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Looks like zram-free-percpu-data-on-module-exit.patch has issues:
> 
>   CC [M]  drivers/staging/zram/zram_drv.o
> drivers/staging/zram/zram_drv.c: In function 'zram_reset_device':
> drivers/staging/zram/zram_drv.c:500:2: error: incompatible type for argument 1 of 'free_percpu'
> include/linux/percpu.h:153:13: note: expected 'void *' but argument is of type 'struct zram_stats'
> make[3]: *** [drivers/staging/zram/zram_drv.o] Error 1
> 

bah.  `make allmodconfig' enables CONFIG_STAGING_EXCLUDE_BUILD, so
nothing under staging gets built.  Seems rather dumb.

zram-free-percpu-data-on-module-exit.patch seems to be unneeded in the
current zram driver - I'll drop the patch, thanks.

