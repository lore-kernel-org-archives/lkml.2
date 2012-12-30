Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2L3C3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 21:29:15 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:40911 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705Ab2L3C3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 21:29:13 -0500
Date: Sat, 29 Dec 2012 21:29:02 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Sergei Trofimovich <slyfox@gentoo.org>, xfs@oss.sgi.com,
        Alex Elder <elder@kernel.org>, Dave Chinner <dchinner@redhat.com>,
        linux-kernel@vger.kernel.org, Ben Myers <bpm@sgi.com>,
        Phil White <pwhite@sgi.com>
Subject: Re: [PATCH] xfs: return -EINVAL instead of -EUCLEAN when mounting
 non-xfs
Message-ID: <20121230022902.GG20918@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@sandeen.net>,
	Sergei Trofimovich <slyfox@gentoo.org>, xfs@oss.sgi.com,
	Alex Elder <elder@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-kernel@vger.kernel.org, Ben Myers <bpm@sgi.com>,
	Phil White <pwhite@sgi.com>
References: <20121230015615.6cc9e03c@sf>
 <1356823010-29768-1-git-send-email-slyfox@gentoo.org>
 <50DF7D7C.50104@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50DF7D7C.50104@sandeen.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2012 at 05:32:12PM -0600, Eric Sandeen wrote:
> yeah, that should work; great minds think alike ;)  Our patches
> crossed in the ether I guess.
> 
> XFS uses EWRONGFS as an alias for EINVAL internally in these cases,
> so maybe we should stick with that for consistency, *shrug*

I keep thinking we should try expanding the number of errno's so that
the file system can give more fs-specific error codes, such that
eventually, user programs could print out error messages that would
make a lot more sense to users.  What we'd have to do is to define the
new errno's, and then wait for the new error_message() strings to
propagate out to a new glibc release, and only then have the kernel
start using the new errno values.  It would be a pain in the tuckus to
do, but in the long run the end result would be a lot better for end
users and system administrators.

					- Ted
