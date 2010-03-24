Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0CXQH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:07:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57156 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab0CXQHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:07:54 -0400
Date: Wed, 24 Mar 2010 16:07:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Benny Halevy <bhalevy@panasas.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT case to
 use of do_last()
Message-ID: <20100324160754.GQ30031@ZenIV.linux.org.uk>
References: <4BAA3493.1030802@panasas.com>
 <20100324160037.GP30031@ZenIV.linux.org.uk>
 <4BAA3828.2070506@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA3828.2070506@panasas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 06:04:56PM +0200, Boaz Harrosh wrote:
> > Bloody impressive...  Does that happen to underlying fs or to what you
> > are seeing via NFS?
> 
> Only via NFS. All local access is fine.
> 
> After the corruption above I can cd to the local mount cp a fresh copy
> of .git/index file and play around just fine.
> Once I return to the NFS mounted directory, a git status will do it.
> It does not matter if caches are cold (Takes a long time) or hot it happens
> every time.
> 
> Weird I know, I'm playing some more with it as we speak

What happens if you export to box running older kernel *or* from box
running older kernel?  IOW, is that nfsd or nfs client getting unhappy?
I'd suspect the latter, but...
