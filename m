Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab1IGViy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:38:54 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:50791 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757136Ab1IGViv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:38:51 -0400
Date: Wed, 7 Sep 2011 17:38:42 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Stephan Mueller <stephan.mueller@atsec.com>
Cc: Steve Grubb <sgrubb@redhat.com>, Jarod Wilson <jarod@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Neil Horman <nhorman@redhat.com>,
        Herbert Xu <herbert.xu@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Message-ID: <20110907213842.GF20571@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	Steve Grubb <sgrubb@redhat.com>, Jarod Wilson <jarod@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>, Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <4E67B75B.8010500@redhat.com>
 <20110907192737.GD20571@thunk.org>
 <201109071602.24519.sgrubb@redhat.com>
 <20110907211858.GE20571@thunk.org>
 <4E67E1B0.2040309@atsec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E67E1B0.2040309@atsec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 11:27:12PM +0200, Stephan Mueller wrote:
> 
> And exactly that is the concern from organizations like BSI. Their
> cryptographer's concern is that due to the volume of data that you can
> extract from /dev/urandom, you may find cycles or patterns that increase
> the probability to guess the next random value compared to brute force
> attack. Note, it is all about probabilities.

The internal state of urandom is huge, and it does automatically
reseed.  If you can find cycles that are significantly smaller than
what would be expected by the size of the internal state, (or any kind
of pattern at all) then there would be significant flaws in the crypto
algorithm used.

If the BSI folks think otherwise, then they're peddling snake oil FUD
(which is not unusual for security companies).

						- Ted
