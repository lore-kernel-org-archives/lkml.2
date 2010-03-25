Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0CYKt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:49:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54164 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0CYKt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:49:27 -0400
Date: Thu, 25 Mar 2010 10:49:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
Message-ID: <20100325104924.GV30031@ZenIV.linux.org.uk>
References: <4BAA48A3.1030801@panasas.com>
 <4BAA4CAC.6060104@panasas.com>
 <4BAA5035.1060906@panasas.com>
 <4BAA52A8.2080304@panasas.com>
 <20100324180622.GS30031@ZenIV.linux.org.uk>
 <4BAA5955.4000001@gmail.com>
 <20100324185604.GT30031@ZenIV.linux.org.uk>
 <4BAB2F5A.30409@panasas.com>
 <20100325101231.GU30031@ZenIV.linux.org.uk>
 <4BAB3967.6000702@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAB3967.6000702@panasas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 12:22:31PM +0200, Benny Halevy wrote:
> On Mar. 25, 2010, 12:12 +0200, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > On Thu, Mar 25, 2010 at 11:39:38AM +0200, Boaz Harrosh wrote:
> > 
> >> It makes no difference, fails just the same. Would an "strace" help?
> > 
> > It might, especially if you ran it for identical repositories on local
> > fs and on NFS; at least that way it would be possible to see where do
> > they diverge...
> > _______________________________________________
> > pNFS mailing list
> > pNFS@linux-nfs.org
> > http://linux-nfs.org/cgi-bin/mailman/listinfo/pnfs
> 
> ext3 fs exported on the server
> client mount -t nfs4 localhost:/ /mnt/localhost
> $ strace git status
> ...
> open(".git/objects/pack", O_RDONLY|O_NONBLOCK|O_DIRECTORY|0x80000) = -1 EISDIR (Is a directory)

Interesting.  It is a directory, indeed, but why the hell does that call
fail with -EISDIR?

Does that happen with nfsv3 or is that v4-only?  I'm going to set up v4
server and client and see what happens, but that information could be
useful...
