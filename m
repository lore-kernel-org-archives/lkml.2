Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab0L0Ae7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 19:34:59 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:25783 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752634Ab0L0Ae5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 19:34:57 -0500
Date: Mon, 27 Dec 2010 01:34:56 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Mark Knecht <markknecht@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Rogier Wolff <R.E.Wolff@BitWizard.nl>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
Message-ID: <20101227003456.GG18227@bitwizard.nl>
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home> <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com> <20101222104306.GB30941@bitwizard.nl> <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com> <AANLkTi=qAGCFU0u8joKVR4o4QQaRZt1XWfOPSt8eiD3r@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=qAGCFU0u8joKVR4o4QQaRZt1XWfOPSt8eiD3r@mail.gmail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 03:38:51PM -0800, Mark Knecht wrote:
> First, the drives are 4K sector so it's really important to get them
> on the right partition boundary. Installing Gentoo requires that we
> un-tar some large-ish files. IIRC on a 512 byte boundary these drives
> took 20-30 minutes to do this. On a 4K boundary they took about 1
> minute. I know that doesn't make sense but those were my numbers, and
> it's a very high end Intel i7-980x MB so there wasn't any other
> problem I could find.

Mark, 

Thanks for your contribution. You're seeing a 20-30 fold performance
issue, where only about 2x would be expected. So to test this theory
I'll see if we can evacuate a partition, untar a large-ish file as a
benchmark, and then see if we can improve that by changing the
alignment of the partition. (hmm. Maybe we should do things the other
way around. First find a tar-workload that takes about 1 minute on a
properly working drive, and then we can wait up to 30 minutes for it
to finish on the improper setup.).

Being able to reproduce a problem at will is a great progress to being
able to solve it!

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
