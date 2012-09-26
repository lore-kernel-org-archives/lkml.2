Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2IZJoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:44:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59341 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab2IZJoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:44:03 -0400
X-IronPort-AV: E=Sophos;i="4.80,489,1344182400"; 
   d="scan'208";a="5920678"
Message-ID: <5062CE1E.3010203@cn.fujitsu.com>
Date: Wed, 26 Sep 2012 17:42:54 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] zsmalloc: promote to lib/
References: <1348649419-16494-1-git-send-email-minchan@kernel.org> <1348649419-16494-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1348649419-16494-2-git-send-email-minchan@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/26 17:44:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/26 17:44:15,
	Serialize complete at 2012/09/26 17:44:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 04:50 PM, Minchan Kim wrote:
> This patch promotes the slab-based zsmalloc memory allocator
> from the staging tree to lib/
> 
> zcache/zram depends on this allocator for storing compressed RAM pages
> in an efficient way under system wide memory pressure where
> high-order (greater than 0) page allocation are very likely to
> fail.
> 
> For more information on zsmalloc and its internals, read the
> documentation at the top of the zsmalloc.c file.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/Kconfig                  |    2 -
>  drivers/staging/Makefile                 |    1 -
>  drivers/staging/zcache/zcache-main.c     |    4 +-
>  drivers/staging/zram/zram_drv.h          |    3 +-
>  drivers/staging/zsmalloc/Kconfig         |   10 -
>  drivers/staging/zsmalloc/Makefile        |    3 -
>  drivers/staging/zsmalloc/zsmalloc-main.c | 1064 ------------------------------
>  drivers/staging/zsmalloc/zsmalloc.h      |   43 --
>  include/linux/zsmalloc.h                 |   43 ++
>  lib/Kconfig                              |    2 +
>  lib/Makefile                             |    1 +
>  lib/zsmalloc/Kconfig                     |   18 +
>  lib/zsmalloc/Makefile                    |    1 +
>  lib/zsmalloc/zsmalloc.c                  | 1064 ++++++++++++++++++++++++++++++
>  14 files changed, 1132 insertions(+), 1127 deletions(-)
>  delete mode 100644 drivers/staging/zsmalloc/Kconfig
>  delete mode 100644 drivers/staging/zsmalloc/Makefile
>  delete mode 100644 drivers/staging/zsmalloc/zsmalloc-main.c
>  delete mode 100644 drivers/staging/zsmalloc/zsmalloc.h
>  create mode 100644 include/linux/zsmalloc.h
>  create mode 100644 lib/zsmalloc/Kconfig
>  create mode 100644 lib/zsmalloc/Makefile
>  create mode 100644 lib/zsmalloc/zsmalloc.c

Since there's just one file here, why not just move to lib flatly without creating a new directory?

Thanks,
Wanlong Gao

