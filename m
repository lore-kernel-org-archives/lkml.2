Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1G0GgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:36:03 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:44158 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1G0GgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:36:01 -0400
Date: Wed, 27 Jul 2011 08:35:59 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Francesco Allertsen <fallertsen@gmail.com>
Cc: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: xfs compile error with the latest -git
Message-ID: <20110727063559.GB1641@x4.trippels.de>
References: <20110726233246.GA8168@fujiko>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726233246.GA8168@fujiko>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.07.27 at 01:32 +0200, Francesco Allertsen wrote:
> Hi all,
>  I have tried to compile the latest -git today and I got the following
> error while compiling the xfs filesystem.
> 
>   CC      fs/xfs/linux-2.6/xfs_iops.o
>   fs/xfs/linux-2.6/xfs_iops.c:1025:14: error: 'xfs_get_acl' undeclared here (not in a function)
> 
> I have bisected the problem and the first bad commit is this one
> 
>   commit 4e34e719e457f2e031297175410fc0bd4016a085
>   Author: Christoph Hellwig <hch@lst.de>
>   Date:   Sat Jul 23 17:37:31 2011 +0200
> 
>   fs: take the ACL checks to common code
> 
>   Replace the ->check_acl method with a ->get_acl method that simply reads an
>   ACL from disk after having a cache miss.  This means we can replace the ACL
>   checking boilerplate code with a single implementation in namei.c.
> 
>   Signed-off-by: Christoph Hellwig <hch@lst.de>
>   Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Could you please solve this problem?  I have attached also the .config
> file if you need it.

It's already solved:  http://lkml.org/lkml/2011/7/26/94
But somehow Linus didn't notice this patch yet.

-- 
Markus
