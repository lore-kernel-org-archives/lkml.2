Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab1CAPoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:44:07 -0500
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:57811 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756728Ab1CAPoE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:44:04 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 10:44:03 EST
X-AuditID: 12074423-b7bd0ae000000a00-1a-4d6d1315f93b
Subject: Re: [REGRESSION] tpm_tis on Lenovo T410 broken in 2.6.38-rc6
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <4D6CFA80.3020505@linux.vnet.ibm.com>
Date: Tue, 1 Mar 2011 10:38:49 -0500
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <BD305A55-A581-4779-B5EA-084B186C903D@mit.edu>
References: <E1PuKHL-0000lw-RM@tytso-glaptop> <4D6CFA80.3020505@linux.vnet.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 1, 2011, at 8:54 AM, Rajiv Andrade wrote:

> 
> The previously reverted commit makes the TPM device driver get the returned timeouts correctly. However, some TPMs return such values in msecs instead of usecs, causing some commands to timeout (e.g the TPM_SaveState, sent at suspend). There's a reworked version of the tpm_tis: Use timeouts returned from TPM patch that adjusts these short timeouts automatically, can you check if it works for you?
> 
>        git://tpmdd.git.sourceforge.net/gitroot/tpmdd/tpmdd/ for-james
> 
> 

Just to clarify, I'm using a version of Linus's upstream that already had the first commit ("Use timeouts returned fromTPM") disabled.   However, when things broke, I saw that reverting the "Long default timeouts  fix" caused me to no longer get "timeout" errors, and my TPM software started working again, so I could connect to the intranet.

> I don't know however why the second commit you reverted still caused the timeouts, I have the same machine here. Did you test both patches with TPM interrupts disabled? (with tpm_tis interrupts option set to 0)

I tested with no options;  until you mentioned it, I didn't even know that this module parameter existed, and it was something I should try toggling.  I was just a normal schlub who tried pulling the latest Linus tree, tried using it, and got a broken TPM.

So tell me what to test, and exactly how to test it, and I'm happy to run experiments for you.   Do you want me to take Linus's latest upstream (which has one TPM patch reverted), apply your for-james patch, and then try with and without tpm_tis's interrupts option set to zero?   I assume that means adding modprobe options parameter interrupts=0?

-- Ted


