Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0EVP2B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 11:28:01 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:50562 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab0EVP17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 11:27:59 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V11 1/9] exportfs: Return the minimum required handle size
In-Reply-To: <20100521221516.GD13227@fieldses.org>
References: <1274340938-29628-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274340938-29628-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100521221516.GD13227@fieldses.org>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Sat, 22 May 2010 20:57:50 +0530
Message-ID: <87y6fc2byh.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 18:15:16 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> On Thu, May 20, 2010 at 01:05:30PM +0530, Aneesh Kumar K.V wrote:
> > The exportfs encode handle function should return the minimum required
> > handle size. This helps user to find out the handle size by passing 0
> > handle size in the first step and then redoing to the call again with
> > the returned handle size value.
> 
> The encode_fh() interface is a little confusing.  (Not your fault,
> really, mainly it's the return value (and the special use of 255) that I
> always find odd.)
> 
> But maybe it would help to have a little more documention in the
> export_encode_fh() kerneldoc comment and/or in
> Documentation/filesystems/nfs/Exporting?
> 

Kernel documentation says 

 * encode_fh:
 *    @encode_fh should store in the file handle fragment @fh (using at most
 *    @max_len bytes) information that can be used by @decode_fh to recover the
 *    file refered to by the &struct dentry @de.  If the @connectable flag is
 *    set, the encode_fh() should store sufficient information so that a good
 *    attempt can be made to find not only the file but also it's place in the
 *    filesystem.   This typically means storing a reference to de->d_parent in
 *    the filehandle fragment.  encode_fh() should return the number of bytes
 *    stored or a negative error code such as %-ENOSPC
 *

Clearly the file system encode_fh is not returning the correct return
values. Should i fix the kernel to follow the documentation or should
the kernel documentation should be fixed. I would prefer code, because
the documentation look more easy/clear to follow that returning value 255.

-aneesh
