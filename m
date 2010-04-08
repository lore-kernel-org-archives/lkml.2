Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738Ab0DHWkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 18:40:42 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:42045 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717Ab0DHWkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 18:40:40 -0400
Subject: Re: [PATCH #3] reiserfs: Fix permissions on .reiserfs_priv
From: Matt McCutchen <matt@mattmccutchen.net>
To: ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Mahoney <jeffm@suse.com>
In-Reply-To: <4BBE4CE2.8030805@gmail.com>
References: <4BBE42A9.2010506@suse.com>  <4BBE4CE2.8030805@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 18:39:27 -0400
Message-ID: <1270766367.3441.4.camel@mattlaptop2.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 23:38 +0200, Edward Shishkin wrote:
> Jeff Mahoney wrote:
> >  [...] This patch resolves the issue by properly hiding .reiserfs_priv. This
> >  was the intent of the xattr poisoning code, but it appears to have
> >  never worked as expected. This is fixed by using d_revalidate instead
> >  of d_compare. [...]

The patch seems to rely on the fact that the priv_root dentry is stuck
in the dcache for as long as the filesystem is mounted, so that attempts
to follow ".reiserfs_priv" are guaranteed to match that dentry in the
cache and be refused by xattr_hide_revalidate.  Is my understanding
correct?

-- 
Matt

