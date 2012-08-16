Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab2HPOQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:16:00 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54420 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354Ab2HPOP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:15:57 -0400
Date: Thu, 16 Aug 2012 18:15:53 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: James Bottomley <jbottomley@parallels.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Pavel Emelianov <xemul@parallels.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120816141553.GF1209@moon>
References: <20120815204546.GC25062@fieldses.org>
 <20120815210237.GF25421@moon>
 <20120815220622.GA28054@fieldses.org>
 <20120816062448.GA32081@moon>
 <20120816123814.GD1209@moon>
 <20120816134339.GQ23464@ZenIV.linux.org.uk>
 <502CF9DA.8030701@parallels.com>
 <20120816135019.GS23464@ZenIV.linux.org.uk>
 <20120816135448.GP32081@moon>
 <1345125779.3259.50.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345125779.3259.50.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 02:03:00PM +0000, James Bottomley wrote:
> > > What's wrong with saying "we don't support idiotify"?
> > 
> > Al, we need some way to restore inotifies after checkpoint.
> > At the very early versions of these patches I simply added
> > dentry to the inotify mark thus once inotify created we always
> > have a dentry to refer on in encode_fh, but I'm not sure if
> > this will be good design.
> 
> Actually, I was about to suggest this.  This can be done internally
> within fs/notify without actually modifying the syscall interface, can't
> it, since they take a path which is used to obtain the inode?  It looks
> like the whole of the inotify interface could be internally recast to
> use dentries instead of inodes.  Unless I've missed something obvious?

Well, after looking into do_sys_name_to_handle->exportfs_encode_fh
sequence more precisely it seems it will be easier to extend
exportfs_encode_fh to support inodes directly instead of playing
with notify code (again, if i'm not missing something too).
i'm cooking a patch to show (once it's tested i'll send it out).
