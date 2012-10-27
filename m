Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2J0IYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 04:24:20 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57953 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab2J0IYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 04:24:16 -0400
Date: Sat, 27 Oct 2012 04:24:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: kconfig option CONFIG_LBDAF should be auto-selected if EXT4
 is chosen
Message-ID: <20121027082413.GB12045@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <508A967F.4080802@gmx.de>
 <508B94AE.9050505@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <508B94AE.9050505@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 10:00:46AM +0200, Toralf Förster wrote:
> 
> otherwise booting an EXT4 image won't work b/c the root fs can't be
> mounted read-write - and as a side effect no syslog messages might
> point the user to this issue (at least in my setup) ...

This is only a problem on 32-bit architectues. and it's actually
documented in the Kconfig help message, and it's enabled by default.
So someone would have had to have gone out of their way to turn off
CONFIG_LBDAF.  This is the first time I've heard of someone getting
surprised by this; do you know how CONFIG_LBDAF got disabled?  Did you
just disable it without reading the help message?

What we might be able to do instead is to allow the mount to succeed,
but to simply fail any attempts to open(2) or stat(2) files larger
than 2TB with an EFBIG error.

BTW, technically ext4 does not _require_ CONFIG_LBDAF.  It's just that
the default mke2fs.conf enables huge_file, so most ext4 file systems
enable it by default.  I could imagine systems (like 32-bit Android
handsets) where it's not intended to ever support storage devices
larger than 2TB, so they might very well wnat CONFIG_EXT4 &&
!CONFIG_LBDAF.  That's a valid choice, although I do admit some users
might get surprised by this.

Regards,

					- Ted




