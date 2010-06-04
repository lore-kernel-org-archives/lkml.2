Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0FDTfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 15:35:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35448 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0FDTfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 15:35:41 -0400
Date: Fri, 4 Jun 2010 20:35:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH, RFC] tty: stop abusing file->f_u.fu_list
Message-ID: <20100604193539.GH31073@ZenIV.linux.org.uk>
References: <20100604064307.737085373@suse.de>
 <20100604072618.227745945@suse.de>
 <20100604183934.GA2309@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604183934.GA2309@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 02:39:34PM -0400, Christoph Hellwig wrote:
> The ttry code currently abuses the file anchor for the per-sb file list
> to track instances of a given tty.  But there's no good reason for
> that, we can just install a proxy object in file->private that gets
> added to the list and points to the tty and keep the list away from
> VFS internals.
> 
> Note that I've just if 0'd the selinux mess poking into it.  While we
> could trivially port it to the new code by making the tty_private
> structure public this code is just too revolting to be kept around.
> It would never have been there anyway if a person with some amount of
> clue had ever reviewed the selinux code.  And no, it's not just the
> tty portion, the rest of that function is just as bad.

This is disgusting, as much as selinux code you've mentioned ;-/

FWIW, selinux problem here is interesting - essentially, it violates its
own rules since the real object here is not an inode.  It's tty.  And
inode pretty much serves as a name - potentially one of many.  So the
policy should've been associated with tty instead...
