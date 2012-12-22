Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab2LVT3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 14:29:15 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:39910 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2LVT3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 14:29:12 -0500
Date: Sat, 22 Dec 2012 14:29:05 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
Cc: Stephan Mueller <smueller@chronox.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Jeff Liu <jeff.liu@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] avoid entropy starvation due to stack protection
Message-ID: <20121222192905.GA12563@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>,
	Stephan Mueller <smueller@chronox.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>, Jeff Liu <jeff.liu@oracle.com>,
	Kees Cook <keescook@chromium.org>
References: <50C72800.20508@chronox.de>
 <20121212164321.a01c5641.akpm@linux-foundation.org>
 <50C98764.6050104@chronox.de>
 <50CB63A9.80409@chronox.de>
 <20121216003020.GC9016@thunk.org>
 <20121221200735.GB5867@domone>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121221200735.GB5867@domone>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 09:07:35PM +0100, Ondřej Bílka wrote:
> I was suggesting in another thread different approach.
> 
> Use AES-based cryptographic random number generator as replacement of 
> /dev/urandom. Reseeding would get done by changing both aes key and
> data.
> 
> This would with hardware support make /dev/urandom much faster than its now.

You can do this in userspace.  And in fact, if you need huge numbers
of random session keys, such as in a Kerberos KDC or an IPSEC IKE
daemon, that's what I would recommand (and what most of them do
already).

The original goal and intent for /dev/random was really for long-term
keys where we are trying to leverage randomness available from
hardware, which only the kernel would be able to collect.  It was not
intended as a high speed random number generator; the best use of it
is either for the generation of a long-term public key, or other
secret (such as a Kerberos master key), or to seed a cryptographic
random number generator which then operates in userspace.

If you need speed, then by all means, use a cryptographic random
number generator in userspace, or if it's for a monte carlo simulator,
use a good userspace PRNG.

						- Ted






