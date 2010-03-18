Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab0CRAy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 20:54:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab0CRAyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 20:54:25 -0400
Date: Wed, 17 Mar 2010 20:53:58 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Show data flow for file copyup in unions
Message-ID: <20100318005358.GA24348@shell>
References: <20100316181711.GB24819@shell> <20335.1268779891@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20335.1268779891@jrobl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 07:51:31AM +0900, J. R. Okajima wrote:
> 
> Valerie Aurora:
> > 1. Don't copyup if the operation would fail (e.g., open(O_WRONLY) on a
> > file with mode 444).  It's inefficient and a possible security hole to
> > copy up a file if no write (or maybe even read) can occur anyway.
> 
> Just a question.
> How about this case?
> When the file is writable (0644 or something) but its parent directory
> is readonly (0555), do you think the file should be copied-up?

This problem comes up with readdir() too, since we copy up all the
directory entries from the lower layer on what is ostensibly a
read-only access.

I think what people will expect is that we copy up in that case.  I
can think of ways this can go wrong, but perhaps that should be an
explicit requirement on the top-layer file system, that it can handle
create/unlink() in a directory without write permission.

-VAL
