Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab2HPNQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:16:40 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36932 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932235Ab2HPNQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:16:36 -0400
Date: Thu, 16 Aug 2012 17:16:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120816131632.GN32081@moon>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.591460800@openvz.org>
 <20120815204546.GC25062@fieldses.org>
 <20120815210237.GF25421@moon>
 <20120815220622.GA28054@fieldses.org>
 <20120816062448.GA32081@moon>
 <20120816123814.GD1209@moon>
 <20120816124703.GE28054@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816124703.GE28054@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 08:47:03AM -0400, J. Bruce Fields wrote:
> > Hi Bruce, thinking a bit more I guess using general encode_fh is not that
> > convenient since it operates with dentries while our fdinfo output deals
> > with inodes. Thus I should either provide some new encode_fh variant
> > which would deal with inodes directly without "parents".
> 
> I can't see why that wouldn't work.
> 
> > Which doesn't
> > look for me anyhow better than the new export_encode_inode_fh helper.
> 
> That isn't going to work for filesystems that define their own
> encode_fh:
> 
> 	$ git grep '\.encode_fh'
> 	fs/btrfs/export.c:      .encode_fh      = btrfs_encode_fh,
> 	fs/ceph/export.c:       .encode_fh = ceph_encode_fh,
	...

Agreed. I'll try to cook something.
