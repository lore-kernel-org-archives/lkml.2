Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab2HWJcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 05:32:25 -0400
Received: from nctlincom02.orcon.net.nz ([60.234.4.75]:49288 "EHLO
	nctlincom02.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab2HWJcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 05:32:22 -0400
Message-ID: <5035F8A2.1070702@orcon.net.nz>
Date: Thu, 23 Aug 2012 21:32:18 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "3.2.x.." <stable@kernel.org>
Subject: Re: [PATCH 01/10] alpha: Add missing RCU idle APIs on idle loop
References: <1345652628-15060-1-git-send-email-fweisbec@gmail.com> <1345652628-15060-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1345652628-15060-2-git-send-email-fweisbec@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx6.orcon.net.nz on Thu, 23 Aug 2012 21:32:19 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Aug 23 21:32:20 2012
X-DSPAM-Confidence: 0.5539
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.50] 
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=G2; city=Porirua; latitude=-41.1333; longitude=174.8500; http://maps.google.com/maps?q=-41.1333,174.8500&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 05HO9Gr6D - 19534831fb8f - 20120823
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/12 04:23, Frederic Weisbecker wrote:
> In the old times, the whole idle task was considered
> as an RCU quiescent state. But as RCU became more and
> more successful overtime, some RCU read side critical
> section have been added even in the code of some
> architectures idle tasks, for tracing for example.

Fantastic!  It fixes RCU CPU stalls that we were seeing on the SMP
kernel when built for generic Alpha.

A build of glibc and running its test suite reliably triggers RCU CPU
stalls when running a kernel built for generic Alpha.  I have just built
glibc and ran its test suite twice with no RCU CPU stalls with this
patch against a 3.5.2 kernel!  Nice.  Very nice.

I see the stable queue is CCed but I note the patch does not apply
cleanly to the 3.2.y kernel.  It would be nice to have a backport of the
patches for the 3.2 stable kernel.

So feel free to add:

Tested-by:  Michael Cree <mcree@orcon.net.nz>

Cheers
Michael.
