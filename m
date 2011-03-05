Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1CFANj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 19:13:39 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:42819 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332Ab1CFANe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 19:13:34 -0500
Date: Sat, 5 Mar 2011 11:48:37 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] tpm_tis on Lenovo T410 broken in 2.6.38-rc6
Message-ID: <20110305164837.GB11120@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
References: <E1PuKHL-0000lw-RM@tytso-glaptop>
 <4D6CFA80.3020505@linux.vnet.ibm.com>
 <AANLkTi=BtfXYV+1_JZh0SRZhJz=Ys3wCF-t5rBR2iz8O@mail.gmail.com>
 <4D6D61B1.7000302@linux.vnet.ibm.com>
 <20110301213756.GA2959@thunk.org>
 <4D70FAC2.5010109@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D70FAC2.5010109@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 11:44:18AM -0300, Rajiv Andrade wrote:
> The bug was that when running the kernel with IMA, at boot time, it
> issues 3 TPM commands IIRC, given the 2 min timeout,
> when the TPM didn't respond due to it not working with interrupts
> for example, the boot hang for 6 minutes.

At boot time, why don't you just poll?  Maybe I'm missing something.

Or you could just simply use a different default timeout during the
boot sequence, or simply tell your IMA users to disable it, since if
you are just hacking the TPM to do a fast fail, the IMA is going to be
broken anyway, right?

> Thanks, it is. HZ isn't enough time for this TPM/setup to have short
> timeout commands to succeed, including
> the tpm_get_timeouts(). I was skeptic at first that this would be
> the reason since I have the same machine,
> and was working for me, the reason I asked for these parameters
> setup attempts.

Yes, but you're probably doing different TPM operations than I am....
I'm not trying to do IMA, I'm trying to login to a WPA2 protected
network where the private key needed to authenticate to the enterprise
wireless network is locked in the TPM.

						- Ted
