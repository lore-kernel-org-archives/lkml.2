Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0CRR4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab0CRR4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:56:11 -0400
Date: Thu, 18 Mar 2010 13:55:43 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Show data flow for file copyup in unions
Message-ID: <20100318175543.GA30924@shell>
References: <20100316181711.GB24819@shell> <20335.1268779891@jrobl> <20100318005358.GA24348@shell> <2640.1268899857@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2640.1268899857@jrobl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 05:10:57PM +0900, J. R. Okajima wrote:
> 
> Valerie Aurora:
> > I think what people will expect is that we copy up in that case.  I
> > can think of ways this can go wrong, but perhaps that should be an
> > explicit requirement on the top-layer file system, that it can handle
> > create/unlink() in a directory without write permission.
> 
> I am not sure such requirement is the right way.
> How about delegating open() to keventd or some other workqueue which
> will succeed to create files under a directory without write permission?
> Of course, we should handle some error cases after creating a file.

Hm, I don't understand how handing it off to another thread would
help.  The thing I am worried about is some internal assumption in the
file system that a directory without write permission can't be
changed.  Totally manufactured example:

somefs_create()
{
	BUG_ON(IS_RDONLY(dir->d_inode);
[...]
}

-VAL
