Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2AOXSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 18:18:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35054 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab2AOXSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 18:18:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [Regression] Commit "tpm: Introduce function to poll for result of self test" breaks suspend
Date: Mon, 16 Jan 2012 00:22:07 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201160022.07176.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

Unfortunately, the following commit from you:

commit 68d6e6713fcb2ea6278661aaaf5f1c9c821b3751
Author: Stefan Berger <stefanb@linux.vnet.ibm.com>
Date:   Fri Nov 11 12:57:04 2011 -0500

    tpm: Introduce function to poll for result of self test
    
    This patch introduces a function that runs the TPM_ContinueSelfTest()
    function and then polls the TPM to check whether it finished the selftest
    and can receive new commands.
    
    Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

broke suspend on my Toshiba Portege R500.  It causes the tpm driver to
return an error code from .suspend() on every attempt to suspend the system.

Revertig this commit on top of the current Linus' tree fixes the problem for me.

If necessary, I'll collect more information about this problem tomorrow.

Thanks,
Rafael
