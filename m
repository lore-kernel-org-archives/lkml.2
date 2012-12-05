Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2LEQdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:33:13 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:36957 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab2LEQdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:33:11 -0500
Date: Wed, 5 Dec 2012 11:33:03 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121205163303.GG18885@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <201212051718.44017.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212051718.44017.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 05:18:43PM +0100, Martin Steigerwald wrote:
> Dave provided technical reasons.
> 
> First in the patch description and then in:
> 
> https://lkml.org/lkml/2012/11/26/700

There were no technical reasons.  We are only reserving a bit.  And
different file systems don't support all of the various different
fallocate flags already --- for example, not all file systems support
the punch system call.

Yes, I could create an entrely new ioctl() that looks just like
fallocate, but supports the extra bit, just so that Dave and others
don't have to be offended about the existence of that extra bit ---
but Linus (and others) have considered ioctl()'s evil, since there is
no type checking, and it's just silly to create a separate interface
just because somebody doesn't think some other file system shouldn't
implement a particular feature --- especially since it's not like
we're have any kind of shortage of bits in the fallocate field.

Heck, I probably have more to complain about with the inode flags
field, which were originally created specifically for ext2/3/4, and
which has since been grabbed for use by other file systems, including
btrfs.  You haven't heard me kvetching because btrfs has grabbed
btrfs-specific inode flags for nocow and notail... no one even bother
to try to get it past the fs-devel shed painting crew before *those*
bits were allocated --- and I am absolutely fine with that.

     	  	    	      	 	    - Ted
