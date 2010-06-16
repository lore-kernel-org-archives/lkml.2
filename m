Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab0FPT6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:58:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab0FPT6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:58:23 -0400
Date: Wed, 16 Jun 2010 15:58:01 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] d_ino considered harmful
Message-ID: <20100616195801.GC24382@shell>
References: <20100616185913.GA15566@shell> <201006162110.43322.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006162110.43322.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 09:10:42PM +0200, Arnd Bergmann wrote:
> On Wednesday 16 June 2010 20:59:13 Valerie Aurora wrote:
> > @@ -91,7 +91,9 @@ static int fillonedir(void * __buf, const char * name, int namlen, loff_t offset
> >  
> >         if (buf->result)
> >                 return -EINVAL;
> > -       d_ino = ino;
> > +       /* Use of d_ino without st_dev is always buggy. */
> > +       d_ino = 0;
> > +
> >         if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
> >                 buf->result = -EOVERFLOW;
> >                 return -EOVERFLOW;
> 
> Isn't this just the path taken by sys_oldreaddir?
> 
> Glibc (at least on my box) translates all user calls to readdir into
> sys_getdents or sys_getdents64, so I think you'd also need to change
> filldir() and filldir64() for your testing.

You're right.  I changed both code paths in the new version, and
actually tested this time.

Thanks,

-VAL
