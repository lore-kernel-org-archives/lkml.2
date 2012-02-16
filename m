Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2BPFei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:34:38 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55163 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552Ab2BPFeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:34:31 -0500
X-Sasl-enc: DgIa6PRKVo/+sPjTUwjHKi4LKBKXpob12JsyhhJPHZMY 1329370469
Date: Wed, 15 Feb 2012 21:15:52 -0800
From: Greg KH <greg@kroah.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20120216051552.GA5676@kroah.com>
References: <20120216152316.821ac82e04a5ee30327b81c3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216152316.821ac82e04a5ee30327b81c3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 03:23:16PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/staging/ramster/zcache-main.c:2969:2: error: unknown field 'invalidate_page' specified in initializer
> drivers/staging/ramster/zcache-main.c:2969:2: warning: initialization from incompatible pointer type [enabled by default]
> drivers/staging/ramster/zcache-main.c:2969:2: warning: (near initialization for 'zcache_cleancache_ops.put_page') [enabled by default]
> drivers/staging/ramster/zcache-main.c:2970:2: error: unknown field 'invalidate_inode' specified in initializer
> drivers/staging/ramster/zcache-main.c:2970:2: warning: initialization from incompatible pointer type [enabled by default]
> drivers/staging/ramster/zcache-main.c:2970:2: warning: (near initialization for 'zcache_cleancache_ops.flush_page') [enabled by default]
> drivers/staging/ramster/zcache-main.c:2971:2: error: unknown field 'invalidate_fs' specified in initializer
> drivers/staging/ramster/zcache-main.c:2971:2: warning: initialization from incompatible pointer type [enabled by default]
> drivers/staging/ramster/zcache-main.c:2971:2: warning: (near initialization for 'zcache_cleancache_ops.flush_inode') [enabled by default]
> drivers/staging/ramster/zcache-main.c:913:13: warning: 'zcache_do_remotify_ops' defined but not used [-Wunused-function]
> drivers/staging/ramster/zcache-main.c:1002:13: warning: 'ramster_remotify_init' defined but not used [-Wunused-function]
> 
> I do wonder if any of this was build tested with CONFIG_CLEANCACHE enabled ...
> 
> Caused by commit 19ee3ef5f4bb ("staging: ramster: local compression + tmem").
> 
> I have used the staging tree from next-20120215 for today.

Dan, can you please fix this?

greg k-h
