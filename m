Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1FFDjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:39:54 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:56706 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab1FFDjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:39:53 -0400
Date: Sun, 5 Jun 2011 23:39:49 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: unlink(nonexistent): EROFS or ENOENT?
Message-ID: <20110606033949.GE7180@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <4DE26F97.9050607@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE26F97.9050607@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 08:08:55PM +0400, Michael Tokarev wrote:
> Hello.
> 
> Just noticed that at least on ext4, unlinking a
> non-existing file from a read-only filesystem
> results in EROFS instead of ENOENT.  I'd expect
> it return ENOENT - it is more logical, at least
> in my opinion.
> 
> For one, (readonly) NFS mount returns ENOENT in
> this case.

Um, it doesn't for me.   Testing on v3.0-rc1:

# ls /test/foo; rm /test/foo
ls: cannot access /test/foo: No such file or directory
rm: cannot remove `/test/foo': No such file or directory
# ls /test/null; rm /test/null
/test/null
rm: cannot remove `/test/null': Read-only file system
# grep test /proc/mounts
/dev/vdb /test ext4 ro,relatime,user_xattr,barrier=1,data=ordered 0 0

				- Ted
