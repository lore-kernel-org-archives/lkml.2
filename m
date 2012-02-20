Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab2BTIUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 03:20:43 -0500
Received: from nctlincom01.orcon.net.nz ([60.234.4.74]:58368 "EHLO
	nctlincom01.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2BTIUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 03:20:41 -0500
Message-ID: <4F420256.2090600@orcon.net.nz>
Date: Mon, 20 Feb 2012 21:20:38 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>
Subject: alpha: futex regression bisected
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Mon, 20 Feb 2012 21:20:39 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Feb 20 21:20:39 2012
X-DSPAM-Confidence: 0.5675
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.00] 
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=E7; city=Auckland; latitude=-36.8667; longitude=174.7667; http://maps.google.com/maps?q=-36.8667,174.7667&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 06GA8kh9T - 5bd69d4b7d0d - 20120220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed some user space problems (pulseaudio crashes in pthread
code, glibc/nptl test suite failures, java compiler freezes on SMP alpha
systems) that arise when using a 2.6.39 or later kernel on Alpha.
Bisecting between 2.6.38 and 2.6.39 (using glibc/nptl test suite as
criterion for good/bad kernel) eventually leads to:

8d7718aa082aaf30a0b4989e1f04858952f941bc is the first bad commit
commit 8d7718aa082aaf30a0b4989e1f04858952f941bc
Author: Michel Lespinasse <walken@google.com>
Date:   Thu Mar 10 18:50:58 2011 -0800

    futex: Sanitize futex ops argument types

    Change futex_atomic_op_inuser and futex_atomic_cmpxchg_inatomic
    prototypes to use u32 types for the futex as this is the data type the
    futex core code uses all over the place.

Looking at the commit I see there is a change of the uaddr argument in
the Alpha architecture specific code for futexes from int to u32, but I
don't see why this should cause a problem.

I am hoping someone better than I at Alpha assembly (Richard?, Ivan?)
might be able to look at the commit and propose a fix!

Cheers
Michael.
