Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1BDV33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:29:29 -0500
Received: from kroah.org ([198.145.64.141]:37691 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab1BDV31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:29:27 -0500
Date: Fri, 4 Feb 2011 13:28:43 -0800
From: Greg KH <greg@kroah.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: gregkh@suse.de, chris.mason@oracle.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, matthew@wil.cx,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        jeremy@goop.org, kurt.hackel@oracle.com, npiggin@kernel.dk,
        riel@redhat.com, konrad.wilk@oracle.com, mel@csn.ul.ie,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        sfr@canb.auug.org.au, wfg@mail.ustc.edu.cn, tytso@mit.edu,
        viro@ZenIV.linux.org.uk, hughd@google.com, hannes@cmpxchg.org
Subject: Re: [PATCH V1 3/3] drivers/staging: kztmem: misc build/config
Message-ID: <20110204212843.GA18924@kroah.com>
References: <20110118172151.GA20507@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110118172151.GA20507@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 09:21:51AM -0800, Dan Magenheimer wrote:
> [PATCH V1 3/3] drivers/staging: kztmem: misc build/config
> 
> Makefiles and Kconfigs to build kztmem in drivers/staging
> 
> There is a dependency on xvmalloc.* which in 2.6.37 resides
> in drivers/staging/zram.  Should this move or disappear,
> some Makefile/Kconfig changes will be required.

There is some other kind of dependancy as well, because I get the
following errors when building:

drivers/staging/kztmem/kztmem.c:34:2: error: #error "kztmem is useless without CONFIG_CLEANCACHE or CONFIG_FRONTSWAP"
drivers/staging/kztmem/kztmem.c:531:13: warning: ‘zbud_init’ defined but not used
drivers/staging/kztmem/kztmem.c:883:28: warning: ‘kztmem_hostops’ defined but not used
drivers/staging/kztmem/kztmem.c:988:27: warning: ‘kztmem_pamops’ defined but not used
drivers/staging/kztmem/kztmem.c:1063:30: warning: ‘kztmem_cpu_notifier_block’ defined but not used
drivers/staging/kztmem/kztmem.c:1201:24: warning: ‘kztmem_shrinker’ defined but not used
drivers/staging/kztmem/kztmem.c:1210:12: warning: ‘kztmem_put_page’ defined but not used
drivers/staging/kztmem/kztmem.c:1242:12: warning: ‘kztmem_get_page’ defined but not used
drivers/staging/kztmem/kztmem.c:1259:12: warning: ‘kztmem_flush_page’ defined but not used
drivers/staging/kztmem/kztmem.c:1278:12: warning: ‘kztmem_flush_object’ defined but not used
drivers/staging/kztmem/kztmem.c:1297:12: warning: ‘kztmem_destroy_pool’ defined but not used
drivers/staging/kztmem/kztmem.c:1320:12: warning: ‘kztmem_new_pool’ defined but not used
drivers/staging/kztmem/kztmem.c:1558:19: warning: ‘enable_kztmem’ defined but not used
drivers/staging/kztmem/kztmem.c:1569:19: warning: ‘no_cleancache’ defined but not used
drivers/staging/kztmem/kztmem.c:1579:19: warning: ‘no_frontswap’ defined but not used

If you require a kbuild dependancy, then put it in your Kconfig file
please, don't break the build.

I'll not apply these patches for now until that's fixed up.

thanks,

greg k-h
