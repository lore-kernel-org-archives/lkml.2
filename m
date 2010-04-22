Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0DVCE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 22:04:59 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:55114 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164Ab0DVCE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 22:04:58 -0400
X-Greylist: delayed 1595 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2010 22:04:58 EDT
Message-ID: <4BCFA855.8070407@lougher.demon.co.uk>
Date: Thu, 22 Apr 2010 02:37:25 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: squashfs-devel@lists.sourceforge.net,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: Status of SquashFS LZMA support in mainline
References: <4BCF9863.2000903@am.sony.com>
In-Reply-To: <4BCF9863.2000903@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> Does anyone (Phillip?) know the status of SquashFS support
> for LZMA compression in mainline?  I seem to recall that
> Phillip got the patches for this into linux-next sometime
> in January, but I'm not sure if the latest kernel
> (2.6.34-rcxx) includes this or not.
> 

Short answer, no it doesn't include this, Linus rejected my
changes to the LZMA code that made it available for
use by non init code (the LZMA code is currently only used by
initramfs/initrd and the kernel decompression code).

See the thread with the response from Linus here
http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-03/msg01462.html

So even though AFAIK there was no issues with the Squashfs LZMA
wrapper, I had to drop it because it's useless without my changes
to the LZMA code.

I salvaged as much as possible, and submitted a second pull request
with only the new Squashfs decompression framework (so it can use different
decompressors cleanly).  This was accepted.


> I also see in Linus' git tree the following commits in
> March:
> 
> 2010-03-05	Linus Torvalds	Merge git://git.kernel.org/pub/scm/linux/kernel/git...
> ...git://git./linux/kernel/git/pkl/squashfs-linus
> ...org/pub/scm/linux/kernel/git/pkl/squashfs-linus:
> Squashfs: get rid of obsolete definition...
> Squashfs: get rid of obsolete variable...
> Squashfs: add decompressor entries for...
> Squashfs: add a decompressor framework
> Squashfs: factor out remaining zlib dependencies...
> Squashfs: move zlib decompression wrapper...

The partial pull is why the commit history is slightly confusing, part of the
work is there, but all LZMA work is mysteriously missing.

What now?  It's clear the Squashfs LZMA work isn't going to be accepted until
I clean up the STATIC and __init mess that Linus objected to.  This is one
of my next tasks when I get enough free time to work through the issues.  It
may be quite a lot of work because to fix this requires touching quite a
few different architecture files.  It's not something that's going to be fixed
in a couple of evenings :-(

Phillip
