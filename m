Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0JKXfC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 19:35:02 -0400
Received: from fieldses.org ([174.143.236.118]:54962 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab0JKXfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 19:35:00 -0400
Date: Mon, 11 Oct 2010 19:34:43 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V21 00/12] Generic name to handle and open by handle
 syscalls
Message-ID: <20101011233443.GB16442@fieldses.org>
References: <1286274140-26533-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286274140-26533-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 03:52:08PM +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> The below set of patches implement open by handle support using exportfs
> operations. This allows user space application to map a file name to file
> handle and later open the file using handle. This should be usable
> for userspace NFS [1] and 9P server [2]. XFS already support this with the ioctls
> XFS_IOC_PATH_TO_HANDLE and XFS_IOC_OPEN_BY_HANDLE.
> 
> [1] http://nfs-ganesha.sourceforge.net/
> [2] http://thread.gmane.org/gmane.comp.emulators.qemu/68992
> 
> git repo for the patchset at:
> git://git.kernel.org/pub/scm/linux/kernel/git/kvaneesh/linux-open-handle.git open-by-handle
> 
> Test case can be found at
> http://git.kernel.org/?p=fs/ext2/kvaneesh/handle-test.git
> git://git.kernel.org/pub/scm/fs/ext2/kvaneesh/handle-test.git
> 
> Changes from V20:
> a) Use better variable names
> b) change handle_size type to __u32
> c) max handle size is now nfsv4 handle size. Considering file system would
>    want to support a handle that can fit into nfsv4 handle size limiting
>    max handle size to 128 rather than 4096 is the right thing.

Looks OK to me.

I haven't read the later patches carefully, but in general an interface
like this seems to me a useful thing to have.

--b.

> d) I didn't add Ceph changes in the series. I am expecting the changes
>    will go via Ceph tree.
> 
> -aneesh
> 
