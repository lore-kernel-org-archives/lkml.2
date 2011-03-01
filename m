Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab1CAPZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:25:42 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:39559 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab1CAPZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:25:41 -0500
Date: Tue, 01 Mar 2011 10:25:28 -0500
Message-Id: <E1PuRS4-0001rO-DS@tytso-glaptop>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org
Subject: [REGRESSION] tpm_tis on Lenovo T410 broken in 2.6.38-rc6
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TPM is working for me so I can log into employer's network in 2.6.37.
It broke when I tried 2.6.38-rc6, with the following relevant lines from
my dmesg:

[   11.081627] tpm_tis 00:0b: 1.2 TPM (device-id 0x0, rev-id 78)
[   25.734114] tpm_tis 00:0b: Operation Timed out
[   78.040949] tpm_tis 00:0b: Operation Timed out

This caused me to get suspicious, especially since the _other_ TPM
commit in 2.6.38 had already been reverted, so I tried reverting commit
c4ff4b829e: "TPM: Long default timeout fix".   With this commit
reverted, my TPM on my Lenovo T410 is once again working.

Given how late we are in the 2.6.38-rc cycle, maybe we should revert
this commit in Linus's tree?

                                                - Ted
