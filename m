Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2LUUMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 15:12:37 -0500
Received: from popelka.ms.mff.cuni.cz ([195.113.20.131]:40451 "EHLO
	popelka.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LUUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 15:12:35 -0500
Date: Fri, 21 Dec 2012 21:07:35 +0100
From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Jeff Liu <jeff.liu@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] avoid entropy starvation due to stack protection
Message-ID: <20121221200735.GB5867@domone>
References: <50C72800.20508@chronox.de>
 <20121212164321.a01c5641.akpm@linux-foundation.org>
 <50C98764.6050104@chronox.de>
 <50CB63A9.80409@chronox.de>
 <20121216003020.GC9016@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121216003020.GC9016@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 07:30:20PM -0500, Theodore Ts'o wrote:
> 
> What I would do instead is use an AES-based cryptographic random
> number generator.  That is, at boot time, grab enough randomness to
> for an AES key, and then use that key to create a cryptographic random
> number generator by encrypting a counter with said AES key.  This is a
> cryptographic primitive which has been very carefully studied, and for
> architectures where you have a hardware support for AES (including
> ARMv8, Power 7, Sparc T4, as well as x86 processors with the AES-NI
> instructions), this will be much faster and require much less memory
> and CPU resources than replicating the /dev/urandom infrastructure.
> 
I was suggesting in another thread different approach.

Use AES-based cryptographic random number generator as replacement of 
/dev/urandom. Reseeding would get done by changing both aes key and
data.

This would with hardware support make /dev/urandom much faster than its now.
