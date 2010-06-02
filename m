Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab0FBEpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 00:45:21 -0400
Received: from ozlabs.org ([203.10.76.45]:56018 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab0FBEpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 00:45:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the rr tree
Date: Wed, 2 Jun 2010 14:15:16 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>, Martin Hicks <mort@sgi.com>
References: <20100602120345.e530c53b.sfr@canb.auug.org.au>
In-Reply-To: <20100602120345.e530c53b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021415.17205.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 11:33:45 am Stephen Rothwell wrote:
> Hi Rusty,
> 
> After merging the rr tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> kernel/debug/kdb/kdb_main.c: In function 'kdb_lsmod':
> kernel/debug/kdb/kdb_main.c:1897: error: 'struct module' has no member named 'modules_which_use_me'
> kernel/debug/kdb/kdb_main.c:1897: error: 'struct module' has no member named 'modules_which_use_me'

Thanks Stephen! I'm not surprised Linus (and I) missed this.

Jason/Martin, please don't do this again.  If you need a structure definition
from a file, pull it out into the header don't cut and paste it like
kernel/debug/kdb/kdb_main.c line 1859:

	#if defined(CONFIG_MODULES)
	/* modules using other modules */
	struct module_use {
		struct list_head list;
		struct module *module_which_uses;
	};

I've fixed this as part of the Linus-inspired module locking cleanup which
should hit linux-next tomorrow and -rc2 sometime.

Thanks,
Rusty.
