Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab0LQMNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:13:17 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17498 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab0LQMNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:13:16 -0500
Date: Fri, 17 Dec 2010 13:07:07 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Ian Kent <raven@themaw.net>
cc: autofs@linux.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [autofs] [PATCH][RFC] autofs4: Do not potentially dereference
 null pointer returned by fget() in autofs_dev_ioctl_setpipefd()
In-Reply-To: <1292382195.2979.17.camel@perseus>
Message-ID: <alpine.LNX.2.00.1012171306310.4638@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012122357570.9206@swampdragon.chaosbits.net> <1292382195.2979.17.camel@perseus>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Ian Kent wrote:

> On Mon, 2010-12-13 at 00:02 +0100, Jesper Juhl wrote:
> > Hi,
> > 
> > In fs/autofs4/dev-ioctl.c::autofs_dev_ioctl_setpipefd() we call fget(), 
> > which may return NULL, but we do not explicitly test for that NULL return 
> > so we may end up dereferencing a NULL pointer - bad.
> 
> Oops, thanks for this.
> 
> > 
> > A comment in fget() says "File object ref couldn't be taken" when that 
> > function returns NULL, so I guess EBUSY is the proper error to return from 
> > autofs_dev_ioctl_setpipefd() when this happens, but I'm far from sure 
> > about this, so I'd like some feedback before this patch is merged.
> 
> Not sure EBUSY is the one to use.
> 
> What is happening here is that user space has opened a file handle it
> thinks is against an autofs mount point (which may actually be covered
> by another mount, hence the need for an ioctl) and is asking the kernel
> to set it in the super block info struct so it can be used for control
> operations. By the look of fget() a NULL return would happen if the file
> table was full (ENFILE) or the file handle had already been closed
> (probably EBADF) so perhaps EBADF would be a better choice.
> 
Ok. That makes sense.
I'll re-spin the patch with that change and re-submit it soon.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

