Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab1EZNfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:35:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:56738 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab1EZNfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:35:37 -0400
Date: Thu, 26 May 2011 09:35:18 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Valdis.Kletnieks@vt.edu, Michael Witten <mfwitten@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Richard Yao <ryao@ic.sunysb.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: UNIX Compatibility
Message-ID: <20110526133518.GI9520@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
	Valdis.Kletnieks@vt.edu, Michael Witten <mfwitten@gmail.com>,
	Mike Galbraith <efault@gmx.de>, Richard Yao <ryao@ic.sunysb.edu>,
	linux-kernel@vger.kernel.org
References: <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com>
 <20110524181619.GC26055@thunk.org>
 <BANLkTi=QUS5WfAMWTw7vuEwuBOVHsww3mA@mail.gmail.com>
 <1306297108.4819.28.camel@marge.simson.net>
 <64e4614dda6f4558a68a314d7b5979b5-mfwitten@gmail.com>
 <20110525143602.GE8476@thunk.org>
 <c943132c8c364f95a91e3cf81cb0f2bd-mfwitten@gmail.com>
 <1306409439.28597.81.camel@thorin>
 <38084.1306411679@localhost>
 <1306412699.28597.90.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306412699.28597.90.camel@thorin>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 02:24:59PM +0200, Bernd Petrovitsch wrote:
> > RATIONALE
> > 
> > Unlinking a directory is restricted to the superuser in many historical
> > implementations for reasons given in link() (see also rename()).
> > 
> > http://pubs.opengroup.org/onlinepubs/009695399/functions/unlink.html
> 
> So someone changes the semantics of the unlink() sys-call (obviously in
> some compatible, standards-compliant way) as it no longer unlinks
> directories but it is not possible to define the returned errno for
> the new error case to something sane?

Yes, it was those horrible hackers at BSD that implemented mkdir() and
rmdir() as atomic operations that could be executed by any process,
instead of only allowing root to create subdirectories.

It was the righteous AT&T marketing managers that created the first
standard, the AT&T SVID, which enshrined the Unix V7 error return, and
forbade it from ever being changed lest you "not be compatible with
Unix".  And thus was a design decision made over 40 years became cast
in concrete, never to change, until the Linux hackers said, "to hell
with the standard".

						- Ted
