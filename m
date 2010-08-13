Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345Ab0HMNtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:49:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43429 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934280Ab0HMNtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:49:21 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: viro@zeniv.linux.org.uk, miklos@szeredi.hu, jblunck@suse.de,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vaurora@redhat.com
In-reply-to: <1281282776-5447-20-git-send-email-vaurora@redhat.com> (message
	from Valerie Aurora on Sun, 8 Aug 2010 11:52:36 -0400)
Subject: Re: [PATCH 19/39] union-mount: Implement union lookup
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-20-git-send-email-vaurora@redhat.com>
Message-Id: <E1Ojud6-0004Br-D6@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 13 Aug 2010 15:49:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  8 Aug 2010, Valerie Aurora wrote:
> Implement unioned directories, whiteouts, and fallthrus in pathname
> lookup routines.  do_lookup() and lookup_hash() call lookup_union()
> after looking up the dentry from the top-level file system.
> lookup_union() is centered around __lookup_hash(), which does cached
> and/or real lookups and revalidates each dentry in the union stack.
> 
> XXX - implement negative union cache entries
> 
> XXX - handle different permissions on directories

If process doing the lookup doesn't have write permission on the top
level directory then the lookup will fail.  This is not intended, is
it?

Thanks,
Miklos
