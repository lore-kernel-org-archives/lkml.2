Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2K3Bdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:33:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:54459 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab2K3Bdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:33:32 -0500
Date: Thu, 29 Nov 2012 17:33:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Tao Ma <boyu.mt@taobao.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH 028/270] ext4: remove erroneous
 ext4_superblock_csum_set() in update_backups()
Message-ID: <20121130013325.GA13478@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-29-git-send-email-herton.krzesinski@canonical.com>
 <1353982939.4266.38.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353982939.4266.38.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 02:22:19AM +0000, Ben Hutchings wrote:
> On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Tao Ma <boyu.mt@taobao.com>
> > 
> > commit bef53b01faeb791e27605cba1a71ba21364cb23e upstream.
> > 
> > The update_backups() function is used to backup all the metadata
> > blocks, so we should not take it for granted that 'data' is pointed to
> > a super block and use ext4_superblock_csum_set to calculate the
> > checksum there.  In case where the data is a group descriptor block,
> > it will corrupt the last group descriptor, and then e2fsck will
> > complain about it it.
> > 
> > As all the metadata checksums should already be OK when we do the
> > backup, remove the wrong ext4_superblock_csum_set and it should be
> > just fine.
> > 
> > Reported-by: "Theodore Ts'o" <tytso@mit.edu>
> > Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > [ herton: adjust context ]
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> 
> This should also be applicable to 3.6.

Thanks, it didn't apply there, so I didn't take it, defering to the ext4
developers, who seem to be a bit busy :)

greg k-h
