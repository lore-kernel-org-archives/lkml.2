Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab2J2Ceg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 22:34:36 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58200 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548Ab2J2Cee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 22:34:34 -0400
Date: Sun, 28 Oct 2012 22:34:30 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Nix <nix@esperi.org.uk>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Message-ID: <20121029023430.GB9365@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Nix <nix@esperi.org.uk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
References: <20121026211542.GE8614@thunk.org>
 <87haphx76u.fsf@spindle.srvr.nix>
 <20121027002258.GB31030@thunk.org>
 <873910xevu.fsf@spindle.srvr.nix>
 <20121027175534.GA7783@thunk.org>
 <87fw4zzra3.fsf@spindle.srvr.nix>
 <508C4FE5.1030102@redhat.com>
 <508C633F.4070100@redhat.com>
 <20121029010012.GE9161@thunk.org>
 <508DE8D3.1050101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508DE8D3.1050101@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 09:24:19PM -0500, Eric Sandeen wrote:
> Yeah, I knew it wasn't ;)  I did resend 
> [PATCH] ext4: fix unjournaled inode bitmap modification
> which is a bit more involved.

Yeah, sorry, I didn't see your updated patch at first, since this mail
thread is one complicated tangle.  :-(

> That'll get_write_access on the same buffer over and over, I suppose
> it's ok, but the patch I sent tries to minimize that, and call
> ext4_handle_release_buffer if we're not going to use it (which is
> a no-op today anyway and not normally used I guess...)

Well, it's really rare that we will go through that loop more than
once; it only happens if we have multiple processes race against each
other trying to grab the same inode.

> If ext4_handle_release_buffer() is dead code now, and repeated calls
> via repeat_in_this_group: are no big deal, then your version looks fine.

Yeah, I think it's pretty much dead code.  At least, I can't think of
a good reason why we would want to actually try to handle
ext4_handle_release_buffer() to claw back the transaciton credit.  And
if we do, we'll have to do a sweep through the entire ext4 codebase
anyway.

						- Ted
