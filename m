Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab0EPHYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 03:24:49 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33625 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab0EPHYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 03:24:48 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Steve French <smfrench@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V7 4/9] vfs: Add open by file handle support
In-Reply-To: <AANLkTim6lwu7Vt72PYSQ7r2swXkEIIYXYeo9z22PKJcz@mail.gmail.com>
References: <AANLkTim6lwu7Vt72PYSQ7r2swXkEIIYXYeo9z22PKJcz@mail.gmail.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Sun, 16 May 2010 12:54:43 +0530
Message-ID: <87eihccnr8.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 14:56:08 -0500, Steve French <smfrench@gmail.com> wrote:
> I think open by handle will turn out to be useful, but in discussing
> various "duplicate inode number" checks that we are having to add to
> cifs, it reminded me that we probably need a "generation number" or
> some equivalent (birth time is probably good enough as well) to be
> able to tell the case where a file is deleted and new file is created
> reusing the same inode number (eventually Samba needs to return this
> to posix clients if inode numbers are to be useful - and I don't know
> how to tell Samba how to get birth time or generation numbers out of
> stat in userspace)
>

The file handle already have generation number encoded. The patches
describe file handle as 

struct file_handle {
	int handle_size;
	int handle_type;
	/* File system identifier */
	struct uuid fsid;
	/* file identifier */
	unsigned char f_handle[0];
};

The file identifier which is stored in f_handle and of size handle_size
is obtained via exportfs_encode_fh (default to export_encode_fh). File 
system can hook a super_block->export_operations there. The default one
export_encode_fh actually use inode number and generation number as a
part of handle. So we shoud be having different file identifier on the
client side for these files which happened to have duplicate inode
number due to inode number reuse. But being able to determine generation
number in the userspace would be nice.


-aneesh

