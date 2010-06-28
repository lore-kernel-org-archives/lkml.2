Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab0F1TJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:09:17 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:9483 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0F1TJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:09:15 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=UTh_cE7tJ6MA:10 a=ygRHs6EKU7oA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=-w3bSOpVOMd_PnQQ2a0A:9
 a=1kZLmCMcVT4s8M79eRTYM7o_MHQA:4 a=CjuIK1q_8ugA:10 a=ZJTebO7n-j-VBLLR:21
 a=LYZgFc8kyShGHNrE:21
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation available by xattrs
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
Date: Mon, 28 Jun 2010 13:08:41 -0600
Cc: viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <19AAF9AA-2445-4C73-808B-4AD9C5C7E769@dilger.ca>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-28, at 10:26, David Howells wrote:
> Make the file creation time, inode data version number and inode generation
> number available on Ext4 by as xattrs named:
> 
> 	file.crtime
> 	file.i_generation
> 	file.i_version (directories only for ext4)

Some minor nits:
- I'd prefer calling these "file.generation" and "file.version".
  I don't think there is value in the "i_" prefix adds anything,
  and it seems more like an internal detail to me
- why not expose the ".version" field for regular files?  It seems
  that all of them are applicable for all file types.
- it would be good to not introduce a new xattr namespace, since
  tools like tar (even the RHEL-patched one) will not backup and
  restore these namespaces.  Using "trusted." would allow them to
  be backed up and restored using existing xattr-patched GNU tar
  by root, but wouldn't allow them to be modified by regular users.
  I think this is important for proper backup/restore of a filesystem,
  but can have correctness implications and shouldn't be accessible
  to regular users.

> file.crtime=0x53ba244c000000000000000000000000

Is this a binary (host-endian) struct timespec?

> file.i_generation=0x0000000000000000

This seems odd, i_generation should never be zero, AFAIK.

Cheers, Andreas





