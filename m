Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0FBIVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:21:04 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35266 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0FBIVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:21:01 -0400
Date: Wed, 2 Jun 2010 17:20:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Mike Frysinger <vapier@gentoo.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Subject: Re: [PATCH] binfmt_elf_fdpic: Fix clear_user() error handling
Message-ID: <20100602082038.GA19079@linux-sh.org>
References: <20100601131047.5456.34014.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601131047.5456.34014.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 02:10:47PM +0100, David Howells wrote:
> From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> 
> clear_user() returns the number of bytes that could not be copied rather than
> an error code.  So we should return -EFAULT rather than directly returning the
> results.
> 
> Without this patch, positive values may be returned to elf_fdpic_map_file()
> and the following error handlings do not function as expected.
> 
> 1.
> 	ret = elf_fdpic_map_file_constdisp_on_uclinux(params, file, mm);
> 	if (ret < 0)
> 		return ret;
> 2.
> 	ret = elf_fdpic_map_file_by_direct_mmap(params, file, mm);
> 	if (ret < 0)
> 		return ret;
> 
> Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> CC: Alexander Viro <viro@zeniv.linux.org.uk>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
> CC: Paul Mundt <lethal@linux-sh.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
