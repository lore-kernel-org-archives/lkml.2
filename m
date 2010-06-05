Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0FELjq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 07:39:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:57324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab0FELjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 07:39:45 -0400
Date: Sat, 5 Jun 2010 21:39:30 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH, RFC] tty: stop abusing file->f_u.fu_list
Message-ID: <20100605113930.GH26335@laptop>
References: <20100604064307.737085373@suse.de>
 <20100604072618.227745945@suse.de>
 <20100604183934.GA2309@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604183934.GA2309@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 02:39:34PM -0400, Christoph Hellwig wrote:
> The ttry code currently abuses the file anchor for the per-sb file list
> to track instances of a given tty.  But there's no good reason for
> that, we can just install a proxy object in file->private that gets
> added to the list and points to the tty and keep the list away from
> VFS internals.

Well thanks for this. Yes it is an obviously nicer way to do it, so
tty doesn't have to know what vfs uses files list for.

 
> Note that I've just if 0'd the selinux mess poking into it.  While we
> could trivially port it to the new code by making the tty_private
> structure public this code is just too revolting to be kept around.
> It would never have been there anyway if a person with some amount of
> clue had ever reviewed the selinux code.  And no, it's not just the
> tty portion, the rest of that function is just as bad.

Why is it a mess? Just because of the conceptual nastiness of checking
a tty object via a random one of its inodes? How would be a better way
to do this?

I think for a first pass, a simple conversion for all code would be good
for me because then it stops blocking the scaling patch. (and it's
more bisectable).

