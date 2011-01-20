Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1ATLPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:15:48 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59960 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1ATLPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:15:47 -0500
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
CC: npiggin@gmail.com, npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-reply-to: <13379.1295514315@jrobl> (hooanon05@yahoo.co.jp)
Subject: Re: vfs-scale, general questions
References: <20110113120626.GB30351@opensource.wolfsonmicro.com> <8138.1294924927@jrobl> <676f5c24375e1cc2aa14fe6630ef1324@mail.gmail.com> <8482.1294926315@jrobl> <AANLkTim=VY7+fo6d_nUXVxs+iZ_f79qWu_eYMUjvhVJO@mail.gmail.com> <909.1295419383@jrobl> <AANLkTi=CqLm=33acFV42N8VbNK9=hwXV9iegKn-jjGJS@mail.gmail.com> <13379.1295514315@jrobl>
Message-Id: <E1PfsUI-0007gV-Gw@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 20 Jan 2011 12:15:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, J. R. Okajima wrote:
> You might think about the race around d_move, but what I meant is the
> race between d_unlinked and unhash/rehash.
> 
> - getcwd return -ENOENT when pwd is unhashed.
> - vfs_rename_dir()
>   + makes the existing target unhashed.

No it doesn't.  dentry_unhash() doesn't drop the dentry from the hash
unless it has no other references, cwd being one such ref.

Thanks,
Miklos
