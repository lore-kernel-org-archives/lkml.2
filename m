Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2GOUXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 16:23:13 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:41510 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab2GOUXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 16:23:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Schwab <schwab@linux-m68k.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 6/6] hrtimer: Update hrtimer base offsets each hrtimer_interrupt
Date: Sun, 15 Jul 2012 22:28:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com> <1341960205-56738-8-git-send-email-johnstul@us.ibm.com> <m2y5mlnj5z.fsf@igel.home>
In-Reply-To: <m2y5mlnj5z.fsf@igel.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207152228.36740.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 15, 2012, Andreas Schwab wrote:
> This breaks resume on the iBook G4 (PowerBook6,7).  Apparently during or
> before noirq resume the system is hanging by the same amount of time as
> the system was sleeping.

I'm able to reproduce this problem on Toshiba Portege R500 with similar
symptoms, although that box sometimes hangs hard during resume from system
suspend with the "caps lock" LED blinking.

Reverting the patch fixes the problem 100% of the time.

Thanks,
Rafael
