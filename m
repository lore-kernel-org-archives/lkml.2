Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030235Ab2HWIGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:06:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39667 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677Ab2HWIGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:06:33 -0400
Date: Thu, 23 Aug 2012 12:06:27 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120823080627.GA1992@moon>
References: <20120815092409.591460800@openvz.org>
 <87fw7habo4.fsf@skywalker.in.ibm.com>
 <20120820163338.GN23596@moon>
 <20120820183225.GB4911@fieldses.org>
 <20120820190606.GE27443@moon>
 <20120820193204.GD5779@fieldses.org>
 <50335261.5090504@parallels.com>
 <87wr0sle4v.fsf@skywalker.in.ibm.com>
 <503367CB.9080609@parallels.com>
 <87zk5nsch8.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zk5nsch8.fsf@skywalker.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 11:19:07AM +0530, Aneesh Kumar K.V wrote:
> Pavel Emelyanov <xemul@parallels.com> writes:
> 
> > Why? For e.g. ext4 you can construct a handle in userspace and open by
> > it.
> 
> open_by_handle use exportfs_decode_fh which use file system specific
> fh_to_dentry
> 
> foe ext4 we require a generation number
> 
> 		inode = get_inode(sb, fid->i32.ino, fid->i32.gen);
> 

Hi Aneesh, yes we need i_generation but for ext3/4 it could be
fetched with ioctl as far as i see.

> For brtfs
> 
> 	objectid = fid->objectid;
> 	root_objectid = fid->root_objectid;
> 	generation = fid->gen;
> 
> 	return btrfs_get_dentry(sb, objectid, root_objectid, generation, 1);

For btrfs it become more complex. But still the last version I'm about
to send for review today (once everything get tested) will provide
fhandle carried with inotify mark _and_ inode number and device. This
information should be enough for us. After all having inode and device
should allow us to figure out the fs used on inotify target.

	Cyrill
