Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602Ab2CUVhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:37:11 -0400
Received: from broadrack.ru ([195.178.208.66]:49307 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757704Ab2CUVhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:37:08 -0400
Date: Thu, 22 Mar 2012 01:37:04 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [take 3] pohmelfs: call for inclusion
Message-ID: <20120321213704.GB16713@ioremap.net>
References: <20120316121829.GA12685@ioremap.net>
 <1331904553.5406.34.camel@joe2Laptop>
 <20120316134314.GA19342@ioremap.net>
 <1331907127.5406.48.camel@joe2Laptop>
 <20120321202702.GA16713@ioremap.net>
 <CA+55aFwm+wfMDFwpcngKwrQEeh53JpsDXr9CPU6Xf0mfGvJHKg@mail.gmail.com>
 <20120321211835.GQ6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321211835.GQ6589@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 09:18:35PM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> I think I've asked that question at least 3 times.  Never got anything
> resembling an answer...  Is that misspelled dentry_path()?  Or is something
> subtle going on and we really want different strings generated for
> chrooted processes here?

This is a special case which does bad things intentionally.
http-compatibility was added in _this_ POHMELFS on demand from people
who do want to access files by handle created from whole path. Not name
or inode number, but whole path, since that's only what is available in
http (or more generally via rest api)

It is limited, wrong and error-prone. It does not even support rename
and hardlinks. But that's what people want.
When I bind-remount part of the tree, things 'dissapear' from the tree.
Yes, this is really an uglymoron, but it was created for _some_ limited
case which rougly work in sandboxed environment only.

The whole rest of the POHMELFS was completely rewritten with very
different model, namely we do _not_ depend on pathes in general case.
There are fair inodes which are indexed by 2^512 numbers, they are
referenced from direntries and so forth.

So, again, treat http-compat mount option (which turns this
path-based-lookups) as a ugly handler for those who /skipped by
censorship in editor/ know what they are doing.

-- 
	Evgeniy Polyakov
