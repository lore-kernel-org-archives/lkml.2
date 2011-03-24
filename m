Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab1CXGqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 02:46:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932157Ab1CXGqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 02:46:07 -0400
Date: Wed, 23 Mar 2011 23:42:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the cleancache tree with Linus'
 tree
Message-Id: <20110323234224.f4ceebd4.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimQQHHN6pS17R_mGmF+oG33D3Apb6E_pNvsLHwv@mail.gmail.com>
References: <20110324135524.261bb5a9.sfr@canb.auug.org.au>
	<20110323205615.6984f974.akpm@linux-foundation.org>
	<AANLkTikagME334Y6PH4P_Nybf_h=fov5CiNBAY7KxYyN@mail.gmail.com>
	<AANLkTimQQHHN6pS17R_mGmF+oG33D3Apb6E_pNvsLHwv@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 14:58:06 +0900 Minchan Kim <minchan.kim@gmail.com> wrote:

> Dan, one more thing.
> 
> #define cleancache_fs_enabled_mapping(_mapping) \
>         (mapping->host->i_sb->cleancache_poolid >= 0)
> 
> One is "_mapping", another is  "mapping"

It should be implemented in C too.  This is the case for almost all
"functions" which are implemented as macros and it's rather a mystery
why we keep on typing #define!

It is not only for cleanliness and for typechecking, but also because
constructs such as

	{
		struct address_space *foo = ...;
		if (cleancache_fs_enabled_mapping(foo))
			...;
	}

will generate an unused-var warning against `foo' if CONFIG_CLEANCACHE=n. 
Implementing the function in C fixes that.  With current gcc, anyway.		
