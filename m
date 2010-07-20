Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab0GTKl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 06:41:56 -0400
Received: from norkia.v3.sk ([91.210.183.14]:34829 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab0GTKly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 06:41:54 -0400
Subject: Re: [PATCH 3/3] [fs/sysv] V7: Add support for non-PDP11 v7
 filesystems
From: Lubomir Rintel <lkundrak@v3.sk>
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100719145851.GD25279@lst.de>
References: <1279559802-19154-1-git-send-email-lkundrak@v3.sk>
	 <1279559802-19154-2-git-send-email-lkundrak@v3.sk>
	 <1279559802-19154-3-git-send-email-lkundrak@v3.sk>
	 <1279559802-19154-4-git-send-email-lkundrak@v3.sk>
	 <20100719145851.GD25279@lst.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 12:41:25 +0200
Message-ID: <1279622485.18203.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 16:58 +0200, Christoph Hellwig wrote:
> On Mon, Jul 19, 2010 at 07:16:42PM +0200, Lubomir Rintel wrote:
> > A mount-time option was added that makes it possible to override the
> > endianness and an attempt is made to autodetect it (which seems easy,
> > given the disk addresses are 3-byte.
> > 
> > No attempt is made to detect big-endian filesystems -- were there any?
> > Tested with PDP-11 v7 filesystems and PC-IX maintenance floppy.
> 
> Do you actually need the mount option?  We get away just fine with
> it for sysv filesystems.  And if not I'd be consistent and accept the
> options for both sysv and v7 filesystems.

Well, there's no reliable way to detect endiannes of a v7 filesystem
unless we do a deep check as fsck would do (there are cases where we can
be sure that a filesystem is not of a certain bytesex, which is what the
current sanity check does and what's abused for the lousy
autodetection).

In super.c it looks like xenix and sysv use a magic number which the
byte order can be determined from, thus the option would be useless
there.

Coherent seems to always use PDP-11 bytesex. I can not check at the
time, but I'm almost sure it never run on such machines (was PC and 68k
only?), so I suspect the coherent kernel might have always done the
translation to native byte order. I think I have some coherent (for PC)
floppies at home, so I can check tomorrow.

> > +	/* plausibility check on root inode: it is a directory,
> > +	   with a nonzero size that is a multiple of 16 */
> > +	if ((bh2 = sb_bread(sb, 2)) == NULL) {
> > +		return 0;
> > +	}
> 
> A little style nitpick, this should be:
> 
> 	bh2 = sb_bread(sb, 2);
> 	if (!bh)
> 		return 0;
> 

I actually did not write this myself, but merely moved from
v7_fill_super(). It would probably a good idea to keep it as it is (not
to obfuscate the changes) and fix it up in a separate commit if is
worth.

Take care,
Lubo

-- 
Flash is the Web2.0 version of blink and animated gifs.
                                     -- Stephen Smoogen

