Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab2GFX1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 19:27:07 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37480 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab2GFX1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 19:27:04 -0400
Date: Fri, 6 Jul 2012 19:26:59 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 05/12] usb: feed USB device information to the
 /dev/random driver
Message-ID: <20120706232659.GA28978@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
	jhalderm@umich.edu, Linus Torvalds <torvalds@linux-foundation.org>,
	stable@vger.kernel.org
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
 <1341614704-24965-6-git-send-email-tytso@mit.edu>
 <20120706230218.GD3728@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706230218.GD3728@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 06:02:18PM -0500, Jonathan Nieder wrote:
> 
> Why cc: stable@?  Does this fix a build error, oops, hang, data
> corruption, real security issue, or other critical "oh, that's not
> good" bug?

All of the /dev/random patches in this patch series that were marked
for the stable backports are to address a security issue.  See:
https://factorable.net/

The main hope is that we can get the embedded device manufacturers to
grab these patches sooner rather than later, so getting them into the
stable backport trees is just as important, if not more so, than
getting them into v3.5.

While these patches are designed to do as much as we can without
assuming any fixes in userspace, and the weak kea vulnerabilities are
much more obviously detectable in embedded devices with close to zero
available entropy, ideally there are improvements that can and should
be done in upstream userspace packages as well as in the packaging and
installation scripts for more general-purpose server and workstation
distributions.

For example, ssh key generation should happen as late as possible;
ideally, some time *after* the networking has been brought up.  If the
ssh keys get generated while the installer is running, before the
kernel has a chance to collect entropy --- especially if the user
chooses to do this with the machine off the network --- well, that's
unfortunate.  The same is true for the generation of remote
administration keys for ntpd and bind.

See the extended version of the research paper for more discussion on
remediation possibilities up and down the OS stack.

Regards,

						- Ted

P.S.  This vulnerability was blogged about a few months ago, and it's
about to be presented at the upcoming Usenix Security Symposium next
month.  Hence, nothing discussed here or in the patch set is a secret.
Please feel free to forward this to any distribution security teams
you think appropriate.
