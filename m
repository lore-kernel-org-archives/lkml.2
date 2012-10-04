Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab2JDWtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:49:50 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53846 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab2JDWtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 18:49:49 -0400
Date: Thu, 4 Oct 2012 18:49:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RNG: is it possible to spoil /dev/random by seeding it from
 (evil) TRNGs
Message-ID: <20121004224942.GA23970@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Christoph Anton Mitterer <calestyo@scientia.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1349357555.3396.15.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1349357555.3396.15.camel@fermat.scientia.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 03:32:35PM +0200, Christoph Anton Mitterer wrote:
> 
> When seeding the kernels entropy cache (which is then ultimately used
> for /dev/random), e.g. by (semi-)TRNGs like haveged[0],
> audio-entropyd[1], Simtec’s Entropy Key[2] or friends... can one spoil
> the randomness by that or is this impossible by design?

It is impossible by design.  Or specifically, /dev/random was designed
so that it can be world-writeable, and an attacker can feed in any
kind of input he or she wants, and it will not allow the attacker to
know anything more about the state of the entropy pool than he or she
knew before they started mixing inputs in.

There are comments that go into more detail about the design in
drivers/char/random.c.  Credit for the design goes to Colin Plumb, who
designed RNG in the original PGP 2.x implementation, BTW.

	     	    	     	 	  - Ted
