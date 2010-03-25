Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab0CYLAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:00:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46014 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab0CYLAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:00:32 -0400
Date: Thu, 25 Mar 2010 11:00:31 +0000
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
Message-ID: <20100325110031.GX30031@ZenIV.linux.org.uk>
References: <4BAA5035.1060906@panasas.com>
 <4BAA52A8.2080304@panasas.com>
 <20100324180622.GS30031@ZenIV.linux.org.uk>
 <4BAA5955.4000001@gmail.com>
 <20100324185604.GT30031@ZenIV.linux.org.uk>
 <4BAB2F5A.30409@panasas.com>
 <20100325101231.GU30031@ZenIV.linux.org.uk>
 <4BAB3967.6000702@panasas.com>
 <20100325104924.GV30031@ZenIV.linux.org.uk>
 <4BAB4168.2090404@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAB4168.2090404@panasas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 12:56:40PM +0200, Benny Halevy wrote:
> -		if (*want_dir && !path->dentry->d_inode->i_op->lookup)
> +		if (*want_dir && !path->dentry->d_inode->i_op->lookup) {
> +			WARN_ON(1);
>  			goto exit_dput;
> +		}
>  		path_to_nameidata(path, nd);
>  		audit_inode(pathname, nd->path.dentry);
>  		goto ok;
> 
> but it is NOT tripping for this scenario.
> 
> (for some reason I saw it tripping when building the kernel over nfs
> but it's benign)

It's ENOTDIR, not EISDIR, anyway.  Happens if you ask to open foo/ or
foo with O_DIRECTORY when foo is not a directory.
