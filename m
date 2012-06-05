Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2FEVIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 17:08:15 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47914 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab2FEVIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 17:08:13 -0400
Date: Tue, 5 Jun 2012 17:08:06 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741:
 group 1904, 32254 clusters in bitmap, 32258 in gd
Message-ID: <20120605210806.GB7182@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Sander Eikelenboom <linux@eikelenboom.it>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <471046920.20120604234941@eikelenboom.it>
 <20120605000356.GM29466@outflux.net>
 <1018371644.20120605224154@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1018371644.20120605224154@eikelenboom.it>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 10:41:54PM +0200, Sander Eikelenboom wrote:
> 
> > Today I've finally managed to bisect this to here:
> > [fd034a84e1ea5c8c8d159cd2089c32e792c269b0] ext4: split out ext4_free_blocks_after_init()
> 
> > If I revert all the "ext4:" patches in 3.2 up to and including that one,
> > I get normal behavior again.

This is excellent.  Thanks!  I'll take a deep look at that ocmmit to
see what might be going on.

> So somehow this only effects ext4 on DM (it's THE common factor in all reports) and fsck seems incapable of seeing the error (and thus repair it.)

What's probably happening is it's only the in-memory copy of the
bitmap which is getting corrupted, and because the file system is
getting remounted read-only, the corrupted bitmap is not getting
written back to disk.  (This is the whole point of remount-ro when fs
corruptions are detected.  :-)

Cheers,

						- Ted
