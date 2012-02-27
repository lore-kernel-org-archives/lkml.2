Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab2B0TJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:09:24 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:43460 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab2B0TJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:09:22 -0500
Date: Mon, 27 Feb 2012 14:09:16 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Cc: David Howells <dhowells@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "valerie.aurora@gmail.com" <valerie.aurora@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>,
        "linux-ext4@kernel.org" <linux-ext4@kernel.org>
Subject: Re: [PATCH 66/73] ext2: Split ext2_add_entry() from
 ext2_add_link() [ver #2]
Message-ID: <20120227190916.GH1651@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	David Howells <dhowells@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"valerie.aurora@gmail.com" <valerie.aurora@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	"linux-ext4@kernel.org" <linux-ext4@kernel.org>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
 <20120221180546.25235.50961.stgit@warthog.procyon.org.uk>
 <20120227000428.GA8044@thunk.org>
 <B5DCCBD9-F032-44E1-8368-146137487B83@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5DCCBD9-F032-44E1-8368-146137487B83@dilger.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 08:30:34PM -0700, Andreas Dilger wrote:
> > I'd suggest folding this in with the following patch (67/73).  It's
> > not clear from this patch why renaming ext2_add_link to
> > ext2_add_entry() makes sense and then adding a new ext2_add_link()
> > which calls ext_add_entry().   It doesn't seem to clarify much....
> 
> Also, why is this being done in ext2, when it should only be done in ext4?

I believe Val used ext2 as a proof-of-concept, because the codebase
was stable (and Union Mounts has been in the oven a loooong time, so
that was probably a good choice).  I agree that if union mounts is
finally going to make it upstream, this would be a good time to
support implemented for ext4, and to get the support into e2fsprogs.

BTW, one thing that I think would be a good thing to do while we're
making this change is to mask off the low 4 bits when looking at the
filetype field so eventually we can use the high 4 bits for some
future extension.

						- Ted
