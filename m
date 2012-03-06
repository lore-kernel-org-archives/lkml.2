Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab2CFRLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:11:07 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60833 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab2CFRLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:11:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of miklos@szeredi.hu designates 10.213.20.201 as permitted sender) smtp.mail=miklos@szeredi.hu; dkim=pass header.i=miklos@szeredi.hu
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Myklebust\, Trond" <Trond.Myklebust@netapp.com>
Cc: "viro\@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch\@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 9/9] nfs: don't open in ->d_revalidate
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
	<1331038601-20353-10-git-send-email-miklos@szeredi.hu>
	<1331043158.3260.3.camel@lade.trondhjem.org>
	<87boo9k861.fsf@tucsk.pomaz.szeredi.hu>
	<1331052079.3260.33.camel@lade.trondhjem.org>
Date: Tue, 06 Mar 2012 18:10:57 +0100
In-Reply-To: <1331052079.3260.33.camel@lade.trondhjem.org> (Trond Myklebust's
	message of "Tue, 6 Mar 2012 16:41:20 +0000")
Message-ID: <87y5rdirj2.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Myklebust, Trond" <Trond.Myklebust@netapp.com> writes:

> It makes a big difference to the cache miss case, since not only is the
> entire path looked up again, but the LOOKUP_REVAL flag gets set, which
> forces a full lookup of each component (as opposed to just
> revalidating).

This is not about a cache miss.  It's about a cache hit (positive cached
dentry) but changed inode on the server.

Is this a likely scenario?

Thanks,
Miklos
