Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab0JWVmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 17:42:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41313 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0JWVmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 17:42:43 -0400
Date: Sat, 23 Oct 2010 22:42:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9 updated] vfs: protect remounting superblock read-only
Message-ID: <20101023214235.GT19804@ZenIV.linux.org.uk>
References: <20101005103108.288743609@szeredi.hu>
 <20101005103144.051231469@szeredi.hu>
 <20101022064627.GA21607@ZenIV.linux.org.uk>
 <E1P9Gh4-00054y-EA@pomaz-ex.szeredi.hu>
 <E1P9KCY-0005YO-4i@pomaz-ex.szeredi.hu>
 <E1P9KFl-0005ZK-0q@pomaz-ex.szeredi.hu>
 <20101023161948.GP19804@ZenIV.linux.org.uk>
 <E1P9js4-0007cE-9G@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1P9js4-0007cE-9G@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 09:35:16PM +0200, Miklos Szeredi wrote:

> > Another thing:
> > 	"If clone_mnt() happens while mnt_make_readonly() is running, the
> > 	cloned mount might have MNT_WRITE_HOLD flag set, which results in
> > 	mnt_want_write() spinning forever on this mount."
> > actually means
> > 	"neither clone_mnt() nor remounts should ever be done without
> > namespace_sem held exclusive; if that ever happens, we have a serious
> > bug that can lead to any number of bad things happening".
> > 
> > Do you actually see such places?  If so, that's what needs fixing.
> 
> do_remount() takes s_umount, but not namespace_sem.

Duh...  Right, ignore that part; we really don't want to do anything
blocking beyond simple allocations under namespace_sem (e.g. everything
that gets unmounted is collected to be dropped after namespace_sem
is released).

Applied.
