Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab2CSEJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 00:09:52 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47643 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2CSEJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 00:09:50 -0400
Date: Mon, 19 Mar 2012 00:09:50 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Message-ID: <20120319040950.GG31682@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1331856299.git.joe@perches.com>
 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 05:07:30PM -0700, Joe Perches wrote:
> Use a more current logging style.
> 
> Add pr_fmt to consistently prefix with "EXT4-fs: "
> Convert printks with KERN_<LEVEL> to pr_<level>.
> Convert bare printks to pr_info and pr_cont where appropriate.
> Remove embedded function names from formats, use "%s: ", __func__.
> Coalesce formats.
> Neaten macros that contain printks/pr_<level>.
> Use ##__VA_ARGS__ in those macros.

Still too much in a single patch.

Changing printk's to pr_info and pr_cont is patch noise as far as I'm
concerned.  Adds no value, and just breaks other patches.  Ditto using
__func__ and and coalesing formats (much of which was broekn up back
when checkpatch flamed developers about 80 column lines, and I patch
noises from trivial patch monkeys offering to fix it, sigh).

And I really don't care about adding EXT4-fs to debugging messages,
especially messages which can't be enabled except when developers have
to explicitly add #define's...

One evidence that this patch is noise is that it doesn't apply cleanly
just on top of my current patch set that I plan to send to Linus.  And
I consider it a waste of time to sort through and figure out what if
any of this 1200 line patch is really worthwhile.  (A quick scan
didn't find anything, although if there are some places where I'm
missing a pr_cont / KERN_CONT in a commonly used --- non debug ---
codepath I'd be willing to fix it.)

						- Ted

