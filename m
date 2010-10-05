Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0JEWpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:45:54 -0400
Received: from tundra.namei.org ([65.99.196.166]:34334 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab0JEWpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:45:53 -0400
Date: Wed, 6 Oct 2010 09:42:39 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Roberto Sassu <roberto.sassu@polito.it>
cc: tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/1] ecryptfs: call vfs_setxattr() in
 ecryptfs_setxattr()
In-Reply-To: <201010051853.52231.roberto.sassu@polito.it>
Message-ID: <alpine.LRH.2.00.1010060942180.6423@tundra.namei.org>
References: <201010051853.52231.roberto.sassu@polito.it>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010, Roberto Sassu wrote:

> Ecryptfs is a stackable filesystem which relies on lower filesystems the
> ability of setting/getting extended attributes.
> 
> If there is a security module enabled on the system it updates the
> 'security' field of inodes according to the owned extended attribute set
> with the function vfs_setxattr().  When this function is performed on a
> ecryptfs filesystem the 'security' field is not updated for the lower
> filesystem since the call security_inode_post_setxattr() is missing for
> the lower inode.
> Further, the call security_inode_setxattr() is missing for the lower inode,
> leading to policy violations in the security module because specific
> checks for this hook are not performed (i. e. filesystem 
> 'associate' permission on SELinux is not checked for the lower filesystem).
> 
> This patch replaces the call of the setxattr() method of the lower inode
> in the function ecryptfs_setxattr() with vfs_setxattr().
> 
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> Reviewed-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

Acked-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
