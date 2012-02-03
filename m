Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2BCRI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:08:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35193 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991Ab2BCRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:08:28 -0500
Date: Fri, 3 Feb 2012 17:08:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
Message-ID: <20120203170825.GX23916@ZenIV.linux.org.uk>
References: <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <20120202012258.GQ23916@ZenIV.linux.org.uk>
 <20120202212400.GR23916@ZenIV.linux.org.uk>
 <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
 <20120203011612.GS23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203011612.GS23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 01:16:12AM +0000, Al Viro wrote:

> 	* ubifs, hfsplus, jffs2 - definitely broken if you create enough
> links.  i_nlink wraparound to zero, confused inode eviction logics.

BTW, ubifs plays funny games with i_nlink - decrements it early in
unlink/rmdir/rename and then increments it back on failure.  *If*
we really want it that way, we need to use set_nlink() there.  Frankly,
I'd rather deal with drop_nlink() after the last possible failure
exit...  Unless there are serious reasons why that wouldn't work, that is.
Artem?
