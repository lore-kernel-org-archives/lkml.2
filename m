Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200Ab2CMJvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:51:08 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48814
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964990Ab2CMJvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:51:06 -0400
Date: Tue, 13 Mar 2012 05:51:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, sage@newdream.net,
        ericvh@gmail.com, mszeredi@suse.cz
Subject: Re: [PATCH 00/25] vfs: atomic open RFC
Message-ID: <20120313095102.GA27480@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do we really need the opendata structure?

It seems like we could just pass a struct path instead of the dentry
passed directly and the vfsmount in it.  There should be no need to
preallocate the file before calling into ->atomic_open, as it's only
used to pass around f_flags - but we already pass that one to
->atomic_open directly and might as well pass it on to finish_open and
allocate the file there.
