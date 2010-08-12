Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab0HLHkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:40:09 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56568 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0HLHkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:40:05 -0400
Message-ID: <4C63A551.3040701@in.ibm.com>
Date: Thu, 12 Aug 2010 13:10:01 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-s390@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Latest git build failure on s390 - dma_get_cache_alignment()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest 2.6.35 git (2.6.35-git11 : 5af568cbd...) fails to build
on s390 with following errors :

arch/s390/mm/fault.c:396: warning: frame size of 'do_protection_exception' is 264 bytes
In file included from include/linux/dmaengine.h:26,
            from include/linux/skbuff.h:30,
            from include/linux/icmpv6.h:82,
            from include/linux/ipv6.h:220,
            from include/net/ipv6.h:16,
            from include/linux/sunrpc/clnt.h:25,
            from include/linux/nfs_fs.h:48,
            from init/do_mounts.c:20:
include/linux/dma-mapping.h:145: error: static declaration of 'dma_get_cache_alignment' follows non-static declaration
include/asm-generic/dma-mapping-broken.h:73: error: previous declaration of 'dma_get_cache_alignment' was here
make[1]: *** [init/do_mounts.o] Error 1
make[1]: *** Waiting for unfinished jobs....
init/do_mounts_md.c: In function 'md_setup_drive':
init/do_mounts_md.c:241: warning: frame size of 'md_setup_drive' is 496 bytes
make: *** [init] Error 2
make: *** Waiting for unfinished jobs....

The code in question was last changed via following commit

commit 4565f0170dfc849b3629c27d769db800467baa62
dma-mapping: unify dma_get_cache_alignment implementations

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

