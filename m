Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab2GHBlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 21:41:35 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37694 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab2GHBld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 21:41:33 -0400
Date: Sat, 7 Jul 2012 21:41:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, stable@vger.kernel.org
Subject: Re: [PATCH 07/12] random: use the arch-specific rng in
 xfer_secondary_pool
Message-ID: <20120708014124.GA3809@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ben Hutchings <ben@decadent.org.uk>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
	jhalderm@umich.edu, stable@vger.kernel.org
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
 <1341614704-24965-8-git-send-email-tytso@mit.edu>
 <1341709606.25597.182.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341709606.25597.182.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2012 at 02:06:46AM +0100, Ben Hutchings wrote:
> 
> Surely the number of random bytes being added is i * sizeof(long), not
> sizeof(u.hwrand)?
> 

Meh; Kees Cook has made the same observation.  Basically, in the
unlikely case where RDRAND fails, we'll end up mixing in stack
garbage.  It's not a security vulnerability, since the contents of the
entropy pool never gets exposed.  In fact, one could argue that mixing
in some unknown garbage from the kernel stack might actually help a
little; but it can't hurt.

					- Ted
