Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab2HWJ35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 05:29:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39847 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab2HWJ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 05:29:52 -0400
Date: Thu, 23 Aug 2012 13:29:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120823092947.GC1992@moon>
References: <20120820163338.GN23596@moon>
 <20120820183225.GB4911@fieldses.org>
 <20120820190606.GE27443@moon>
 <20120820193204.GD5779@fieldses.org>
 <50335261.5090504@parallels.com>
 <87wr0sle4v.fsf@skywalker.in.ibm.com>
 <503367CB.9080609@parallels.com>
 <87zk5nsch8.fsf@skywalker.in.ibm.com>
 <20120823080627.GA1992@moon>
 <5035EFD4.7090404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5035EFD4.7090404@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 10:54:44AM +0200, Marco Stornelli wrote:
> >>For brtfs
> >>
> >>	objectid = fid->objectid;
> >>	root_objectid = fid->root_objectid;
> >>	generation = fid->gen;
> >>
> >>	return btrfs_get_dentry(sb, objectid, root_objectid, generation, 1);
> >
> >For btrfs it become more complex. But still the last version I'm about
> >to send for review today (once everything get tested) will provide
> >fhandle carried with inotify mark _and_ inode number and device. This
> >information should be enough for us. After all having inode and device
> >should allow us to figure out the fs used on inotify target.
> 
> Sorry if it's a really stupid question but I didn't follow deeply
> the thread. How can you provide a device if the fs is mounted on
> "none" (ex tmpfs)? In this case you can't associate device <=> fs,
> because you haven't got a /dev/something.

That's ::s_dev from superblock, together with parsing /proc/$pid/mountinfo
and /proc/mounts you can figure out anything you need.

	Cyrill
