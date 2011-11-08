Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1KHDrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:47:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43411 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1KHDrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:47:35 -0500
X-Greylist: delayed 2089 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 22:47:35 EST
Date: Tue, 8 Nov 2011 03:12:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc1
Message-ID: <20111108031242.GU2203@ZenIV.linux.org.uk>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 06:10:02PM -0800, Linus Torvalds wrote:

> Which brings me to a question I already asked on G+ - do people really
> need the old-fashioned patches? The -rc1 patch is about 22MB gzip-9'd,
> and part of the reason is that all those renames cause big
> delete/create diffs. We *could* use git rename patches, but then you'd
> have to apply them with "git apply" rather than the legacy "patch"
> executables. But as it is, the patch is almost a third of the size of
> the tar-ball, which makes me wonder if there's even any point to such
> a big patch?

FWIW, agruen seems to be doing patch(1) development these days; the last
snapshot has this in NEWS:

* Support for most features of the "diff --git" format: renames and copies,
  permission changes, symlink diffs.  Caveats:
  + Binary diffs are not supported yet; patch will complain and skip them.
  + In the "diff --git" format, all the patches are relative to the original
    state of the files to patch, allowing things like criss-cross renames.
    GNU patch will currently fail for such patches.
* Support for double-quoted filenames in the "diff --git" format: when a
  filename in a context diff starts with a double quote, it is interpreted
  as a C string literal.  The escape sequences \\, \", \a, \b, \f, \n, \r,
  \t, \v, and \ooo (a three-digit octal number between 0 and 255) are
  recognized.

Hell knows how long until they release it and distros pick the result, of
course.  Their git tree on git://git.savannah.gnu.org/patch.git is fairly
quiet; there had been a bunch of local fixes since the last snapshot (this
April) but not much else...
