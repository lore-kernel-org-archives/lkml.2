Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab0KOSrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:47:24 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33034 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab0KOSrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:47:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=uzxx+sfwtNmSL0ioc6Y/ludhmXQChydPvilaq+V3qVa3iAcHJ+4SGgalIbi4QAD6Ut
         kIN/34Jy/c6U6NoSNH+wSaNh1b9qHfjRbDv9BhStY+vKRU1Xu+5aWio0VP+w31v/A17v
         6vHtRz2He7S1rqkcpTNaby9x+lXjYek0UWTmI=
Date: Mon, 15 Nov 2010 21:45:31 +0300
From: Dan Carpenter <error27@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: jffs2: fix error value sign
Message-ID: <20101115184531.GA24643@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vasiliy Kulikov <segoon@openwall.com>,
	kernel-janitors@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1289765320-6071-1-git-send-email-segoon@openwall.com>
 <20101114202905.GA21614@bicker>
 <20101115143735.GA4548@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101115143735.GA4548@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 05:37:37PM +0300, Vasiliy Kulikov wrote:
> 
> x86_64, linux-next:
> 
> make -C /home/vasya/linux fs/jffs2/xattr.o
> make: Вход в каталог `/home/vasya/dev/linux-next'
        ^^^^^^^^^^^^^^

This means "Entering directory" right?  So /home/vasya/linux is a
symlink to /home/vasya/dev/linux-next.  It still compiles for me
when I create a symlink and use the -C option...

>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CC      fs/jffs2/xattr.o
> fs/jffs2/xattr.c: In function ‘unload_xattr_datum’:
> fs/jffs2/xattr.c:87: error: ‘struct jffs2_sb_info’ has no member named ‘xdatum_mem_usage’
> fs/jffs2/xattr.c: In function ‘reclaim_xattr_datum’: fs/jffs2/xattr.c:105: error: ‘struct jffs2_sb_info’ has no member named
> ‘xdatum_mem_threshold’ fs/jffs2/xattr.c:105: error: ‘struct jffs2_sb_info’ has no member named
> ‘xdatum_mem_usage’ fs/jffs2/xattr.c:108: error: ‘struct jffs2_sb_info’ has no member named
> ‘xdatum_mem_usage’ fs/jffs2/xattr.c:109: error: ‘struct jffs2_sb_info’ has no member named
> ‘xdatum_mem_usage’ fs/jffs2/xattr.c:110: error: ‘XATTRINDEX_HASHSIZE’ undeclared (first use
> in this function) fs/jffs2/xattr.c:110: error: (Each undeclared identifier is reported
> only once
> fs/jffs2/xattr.c:110: error: for each function it appears in.)
> 

It's not pulling in the CONFIG_JFFS2_FS_XATTR=y for some reason.  Is
there an environment variable which it uses to pull in your config
file?  An allyesconfig or an allmodconfig should work.

regards,
dan carpenter
