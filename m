Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1AMO6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:58:52 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55691 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab1AMO6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:58:50 -0500
To: Nick Piggin <npiggin@gmail.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
	(message from Nick Piggin on Sat, 8 Jan 2011 13:54:47 +1100)
Subject: Re: Important for fs devs: rcu-walk merged upstream
References: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
Message-Id: <E1PdOdT-00042k-RM@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Jan 2011 15:58:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Jan 2011, Nick Piggin wrote:
> The vfs-scale branch is now upstream. If you haven't
> looked yet, your filesystem is likely to have been
> touched, so check it out.
> 
> Also look at Documentation/filesystems/porting and
> path-lookup.txt.
> 
> The dcache_lock stuff should have been all done for you
> (for in-tree filesystems, I can help out of tree fses with
> conversions there if you ping me offline).
> 
> The rcu-walk stuff can be more tricky for your filesystem
> to take advantage of.
> 
> If you supply a .d_revalidate, .permission, or .check_acl,
> then path walking is going to be slow and unscalable for
> you.
> 
> Out of tree filesystems: you _have_ to at least add a line
> of code to the above functions in order to specify that
> you don't want to participate in rcu-walk.
> 
> Otherwise, you don't have to care about rcu-walk if you
> have a legacy or special filesystem like configfs then I'd
> advise against anything fancy. But if you have a
> userbase and you expect them to actually do any path
> lookups into your filesystem, please take a look.

One other thing: I know ECHILD is safe since no sane filesystem will
return it in its permission or revalidate callbacks, and even if it
does that's just a loss of optimization.

But it would be better from a readability and grepability standpoint
if it was a kernel internal errno (ERESTARTNORCU or whatever)
similarly to ERESTARTSYS and the like.

Thanks,
Miklos
