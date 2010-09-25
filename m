Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab0IYXzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 19:55:20 -0400
Received: from thunk.org ([69.25.196.29]:36647 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab0IYXzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 19:55:18 -0400
Date: Sat, 25 Sep 2010 19:54:59 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Tracey Dent <tdent48227@gmail.com>
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
        sandeen@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Message-ID: <20100925235459.GA5299@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Tracey Dent <tdent48227@gmail.com>, adilger.kernel@dilger.ca,
	jack@suse.cz, dmonakhov@openvz.org, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 02:31:52PM -0400, Tracey Dent wrote:
> From: Tracey Dent <Tdent48227@gmail.com>
> 
> Found and corrected indent issue using checkpatch.pl
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>

Patches that fix whitespace issues aren't really worthwhile.  They
tend to cause extra work for the me as the maintainer, since it means
that patches that others send me end up failing due to whitespace
issues, which then have to be manually fixed up.

There are also changes you've made which actually make the alignment
*worse* not better, places where you changed:

	} else if

to
	}	else if

which is to my mind, totally broken, and certainly not required by
checkpatch.

So I'm going to NACK this whole patch series, sorry.

Patches should be checkpatch.pl clean, and so as we make changes,
we'll also gradually clean up the code.  Note though that I'm an emacs
user, and so I prefer code where parenthesis is properly lined up,
i.e.:

	while ((count < blks) && (count <= blocks_to_boundary) &&
	       (le32_to_cpu(*(branch[0].p + count)) == 0)) {

and not this:

	while ((count < blks) && (count <= blocks_to_boundary) &&
		(le32_to_cpu(*(branch[0].p + count)) == 0)) {

I won't insist on it, though.  However, I'll generally clean up such
alignment issues if I come across it.

;					- Ted
