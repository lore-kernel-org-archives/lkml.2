Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab1IGVTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:19:08 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:50060 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006Ab1IGVTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:19:06 -0400
Date: Wed, 7 Sep 2011 17:18:58 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Message-ID: <20110907211858.GE20571@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Steve Grubb <sgrubb@redhat.com>,
	Jarod Wilson <jarod@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>, Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <4E67B75B.8010500@redhat.com>
 <20110907192737.GD20571@thunk.org>
 <201109071602.24519.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109071602.24519.sgrubb@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 04:02:24PM -0400, Steve Grubb wrote:
> 
> When a system is underattack, do you really want to be using a PRNG
> for anything like seeding openssl?  Because a PRNG is what urandom
> degrades into when its attacked.

This is not technically true.  urandom degrades into a CRNG
(cryptographic random number generator).  In fact what most security
experts recommend is to take a small amount of security, and then use
that to seed a CRNG.

> If enough bytes are read that an
> attacker can guess the internal state of the RNG, do you really want
> it seeding a openssh session?

In a cryptographic random number generator, there is a either a
cryptographic hash or a encryption algorithm at the core.  So you
would need a huge amounts of bytes, and then you would have to carry
out an attack on the cryptographic core.

If this is the basis for the patch, then we should definitely NACK it.
It sounds like snake oil fear mongering.

					- Ted


