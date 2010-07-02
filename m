Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab0GBRqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:46:16 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:49067 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab0GBRqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:46:14 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=355tMteATKMA:10 a=ygRHs6EKU7oA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=PTJhpT2F7kuk000POfEA:9
 a=FAU9GvuURE9XI99NA_kA:7 a=04Pq_9k9KKBkVrHWPlZSPtlVmUcA:4 a=CjuIK1q_8ugA:10
Subject: Re: [PATCH 3/3] xstat: Implement a requestable extra result to procure some inode flags [ver #4]
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20100701235738.19035.21536.stgit@warthog.procyon.org.uk>
Date: Fri, 2 Jul 2010 11:45:41 -0600
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C80B6032-0FB2-4D63-B940-3FE86B52992B@dilger.ca>
References: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk> <20100701235738.19035.21536.stgit@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-01, at 17:57, David Howells wrote:
> [This is, for the moment, to be considered an example.  Do we actually want to
> export these flags?  Should they be a full member of struct xstat?]

I would say this should be a full-fledged member of struct xstat.  I think they are fairly standard (available on many filesystems today), and requiring an ioctl to access them is unpleasant.

> (1) User settable flags (to be consistent with the BSD st_flags field):
> 
> 	UF_NODUMP	Do not dump this file.
> 	UF_IMMUTABLE	This file is immutable.
> 	UF_APPEND	This file is append-only.
> 	UF_OPAQUE	This directory is opaque (unionfs).
> 	UF_NOUNLINK	This file can't be removed or renamed.
> 	UF_COMPRESSED	This file is compressed.
> 	UF_HIDDEN	This file shouldn't be displayed in a GUI.
> 
>    The UF_SETTABLE constant is the union of the above flags.
> 
> (2) Superuser settable flags (to be consistent with the BSD st_flags field):
> 
> 	SF_ARCHIVED	This file has been archived.
> 	SF_IMMUTABLE	This file is immutable.
> 	SF_APPEND	This file is append-only.
> 	SF_NOUNLINK	This file can't be removed or renamed.
> 	SF_HIDDEN	This file is a snapshot inode.
> 
>    The SF_SETTABLE constant is the union of the above flags.
> 
> (3) Linux-specific flags:
> 
> 	XSTAT_LF_MAGIC_FILE	Magic file, such as found in procfs and sysfs.
> 	XSTAT_LF_SYNC		File is written synchronously.
> 	XSTAT_LF_NOATIME	Atime is not updated on this file.
> 	XSTAT_LF_JOURNALLED_DATA Data modifications to this file are journalled.
> 	XSTAT_LF_ENCRYPTED	This file is encrypted.
> 	XSTAT_LF_SYSTEM		This file is a system file (FAT/NTFS/CIFS).
> 	XSTAT_LF_TEMPORARY	This file is a temporary file (NTFS/CIFS).
> 	XSTAT_LF_OFFLINE	file is currently unavailable (CIFS).

Yuck on the names.  Why not stick with the "UF_" and "SF_" prefixes?  Since we don't need to keep _binary_ compatibility with these flag values (only name portability) we can use the same flag values as the FS_*_FL definitions in fs.h.  That is what all of the existing filesystems already use (ext2/3/4, ocfs, btrfs, reiserfs, xfs, jfs).

Cheers, Andreas





