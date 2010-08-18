Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab0HRA2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 20:28:39 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:64923 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab0HRA2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 20:28:33 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: Union mounts and file locks (was Re: [PATCH 14/39] union-mount: Union mounts documentation)
To: Valerie Aurora <vaurora@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20100817210610.GF5556@shell>
References: <20100817210610.GF5556@shell>
Date: Wed, 18 Aug 2010 09:27:36 +0900
Message-ID: <6194.1282091256@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Valerie Aurora:
> Union mounts behaves this way with locks for the same reason as
> fchmod(), etc. on O_RDONLY file descriptors fails.  In-kernel copyup
> only happens before a file descriptor is open.  Once it is open, it is
> very difficult to switch the open file with the newly copied up file
> ("very difficult" meaning "Al Viro refuses to even discuss it").

Laugh, laugh, laugh.
But this is one of the major difference between "union in VFS" and
"union as FS". By the union implemented as FS, the file object will be a
virtual one in a virtual FS, and you can switch two real files on the
layers in the virtual object.


> However, fcntl(F_SETLK) on a file opened read-write will behave
> exactly as expected.  The question is how many applications call
> fcntl(F_SETLK) on a read-only file descriptor as the first lock
> operation on a file?  Of those applications, how many could easily be
> rewritten to open that file descriptor with write permissions?

I don't know.
If users never use such AP or never meet the problem, then there will be
no actual problem.


J. R. Okajima
