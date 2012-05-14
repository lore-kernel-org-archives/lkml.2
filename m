Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2ENUHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:07:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64882 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab2ENUHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:07:04 -0400
Date: Mon, 14 May 2012 13:06:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com
Subject: Re: [PATCH] ramster: switch over to zsmalloc and crypto interface
Message-ID: <20120514200659.GA15604@kroah.com>
References: <1336676781-8571-1-git-send-email-dan.magenheimer@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336676781-8571-1-git-send-email-dan.magenheimer@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 12:06:21PM -0700, Dan Magenheimer wrote:
> RAMster does many zcache-like things.  In order to avoid major
> merge conflicts at 3.4, ramster used lzo1x directly for compression
> and retained a local copy of xvmalloc, while zcache moved to the
> new zsmalloc allocator and the crypto API.
> 
> This patch moves ramster forward to use zsmalloc and crypto.
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

I finally enabled building this one (didn't realize it required ZCACHE
to be disabled, I can only build one or the other), and I noticed after
this patch the following warnings in my build:

drivers/staging/ramster/zcache-main.c:950:13: warning: ‘zcache_do_remotify_ops’ defined but not used [-Wunused-function]
drivers/staging/ramster/zcache-main.c:1039:13: warning: ‘ramster_remotify_init’ defined but not used [-Wunused-function]
drivers/staging/ramster/zcache-main.c: In function ‘zcache_put’:
drivers/staging/ramster/zcache-main.c:1594:4: warning: ‘page’ may be used uninitialized in this function [-Wuninitialized]
drivers/staging/ramster/zcache-main.c:1536:8: note: ‘page’ was declared here

Care to please fix them up?

thanks,

greg k-h
