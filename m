Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2IDDPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 23:15:49 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48691 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab2IDDPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 23:15:48 -0400
Date: Mon, 3 Sep 2012 23:15:44 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Azat Khuzhin <dohardgopro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: western digital caviar black. EXT4-fs error
Message-ID: <20120904031544.GI5066@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Azat Khuzhin <dohardgopro@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAAW1UO-q5uUe4zG5BnB0z9dyKCqRRWH4sriyu7Fj6XinE7GKzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAW1UO-q5uUe4zG5BnB0z9dyKCqRRWH4sriyu7Fj6XinE7GKzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 11:48:17PM +0400, Azat Khuzhin wrote:
> Recently I update my HDD on desktop machine, and bought WD Caviar Black.
> But after I format & copy information to it (using dd), and fix
> partitions size: I have next errors in kern.log:
> 
> Aug 28 01:49:03 home-spb kernel: [183245.030897] EXT4-fs error (device
> sdc2): ext4_mb_generate_buddy:739: group 3675, 32254 clusters in
> bitmap, 32258 in gd

Sorry for the delay; you sent this to linux-kernel (and not the
linux-ext4 list).  It also took me a while to dig up the relevant fix
from my archives; normally, once a bug has been fixed (as this one
was, on June 7, 2012) I don't worry about it any more.

The upstream fix is commit b0dd6b70f0fda17ae9762fbb72d98e40a4f66556.

Note that you are using the 3.3.0 kernel.  This is a not long-term
supported kernel, so fixes from upstream are no longer being
backported to it.  The official Debian kernel (which tracks the 3.2.x
stable kernel series) has the backported bug fix.  So does the 3.4
long-term stable kernel series, as does the 3.5 kernel or any later
kernel.

If you don't know how to backport a kernel patch, or even if you do, I
would strongly suggest that you either go back to the Debian standard
kernel for Wheezy, or track the 3.2.x or 3.4.x long-term stable
kernel.  (The fix is in v3.2.20 or later, and v3.4.3 or later ---
where those trees are up to v3.2.28, and v3.4.10, respectively.)
Otherwise, you may very well run into some other kernel bug which has
already been fixed upstream, and you'll just waste your time as well
as various other kernel developers.

Regards,

						- Ted
