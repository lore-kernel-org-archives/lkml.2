Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab0G3SEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:04:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33813 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab0G3SEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 14:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NfKBSktwdCRJoA3S+II4+5O2GWpyRI2KI9FdP9ejzjx3dqj9D53PTd3ZM1v3SU2YYj
         pL0M4EmMLvHyrvfZj5+V3DBhoA3bz7vsrKGc9t587y25nEow+KCi6VxBhCsK+36Y6yIC
         Iuig+CGvjVk1WqGzt5EYucabCeZOrZmU3NyCI=
Date: Fri, 30 Jul 2010 22:03:30 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: kernel-janitors@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] fs: nfs: misused copy_to_user() return value
Message-ID: <20100730180330.GA14678@albatros>
References: <1280488190-20979-1-git-send-email-segooon@gmail.com>
 <1280512047.12852.8.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280512047.12852.8.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 13:47 -0400, Trond Myklebust wrote:
> On Fri, 2010-07-30 at 15:09 +0400, Kulikov Vasiliy wrote:
> > copy_to_user() returns nonzero value on error, this value may be any
> > value between 0 and requested count, not only requested count.
> > 
> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> > ---
> >  fs/nfs/idmap.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
> > index 21a84d4..a9f2cd5 100644
> > --- a/fs/nfs/idmap.c
> > +++ b/fs/nfs/idmap.c
> > @@ -362,7 +362,7 @@ idmap_pipe_upcall(struct file *filp, struct rpc_pipe_msg *msg,
> >  	unsigned long left;
> >  
> >  	left = copy_to_user(dst, data, mlen);
> > -	if (left == mlen) {
> > +	if (left)
> >  		msg->errno = -EFAULT;
> >  		return -EFAULT;
> >  	}
> 
> ...and we do handle the case where copy_to_user returns less than the
> requested number of bytes: it is called a 'short read' and is quite
> allowed in POSIX. The userland application can just call sys_read()
> again...

Right, please ignore these 2 patches.

> 
> Trond
