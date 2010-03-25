Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0CYKyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:54:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42132 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab0CYKyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:54:08 -0400
Date: Thu, 25 Mar 2010 10:54:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Doug Nazar <nazard.lkml@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
Message-ID: <20100325105406.GW30031@ZenIV.linux.org.uk>
References: <20100324163948.GR30031@ZenIV.linux.org.uk>
 <4BAA48A3.1030801@panasas.com>
 <4BAA4CAC.6060104@panasas.com>
 <4BAA5035.1060906@panasas.com>
 <4BAA52A8.2080304@panasas.com>
 <20100324180622.GS30031@ZenIV.linux.org.uk>
 <4BAA5955.4000001@gmail.com>
 <20100324185604.GT30031@ZenIV.linux.org.uk>
 <4BAB2F5A.30409@panasas.com>
 <20100325101231.GU30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325101231.GU30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 10:12:31AM +0000, Al Viro wrote:
> On Thu, Mar 25, 2010 at 11:39:38AM +0200, Boaz Harrosh wrote:
> 
> > It makes no difference, fails just the same. Would an "strace" help?
> 
> It might, especially if you ran it for identical repositories on local
> fs and on NFS; at least that way it would be possible to see where do
> they diverge...

I wonder...  What happens if you add
	if (error == -EISDIR)
		printk("blah: %s", pathname);
right after do_lookup() call in do_last()?  That would separate -EISDIR
coming from NFS from the same thing coming from fs/namei.c...
