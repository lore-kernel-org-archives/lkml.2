Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab0CVXS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 19:18:26 -0400
Received: from rekin26.go2.pl ([193.17.41.76]:58596 "EHLO rekin26.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab0CVXSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 19:18:25 -0400
X-Greylist: delayed 82474 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2010 19:18:25 EDT
From: Zbigniew Luszpinski <zbiggy@go2.pl>
To: "Justin P. mattock" <justinmattock@gmail.com>
Subject: Re: 2.6.32 help needed with reverting APIC patches.
Date: Tue, 23 Mar 2010 00:18:15 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.32.10; KDE/4.4.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201003220123.37341.zbiggy@go2.pl> <4BA716E5.2060800@gmail.com>
In-Reply-To: <4BA716E5.2060800@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003230018.15750.zbiggy@go2.pl>
X-O2-Trust: 2, 68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> best would be todo a bisect. but if your for sure these
> are the commits, then you probably wont need too.
> 
> if your doing git revert xxxx
> and the commit reverts for you then your good,
> but if there's too much happening(big merge), then
> a git rebase probably is the best bet(but could be wrong).
> 
> hope this helps.
> 
> Justin P. Mattock
> 

Yeah I imagine reverting patches from kernel 2.6.32.10 up to 2.6.20 and seeing all these conflicts in git.
I have just done this in different way: downloaded official 2.6.32.10 and manually reinserted the removed code.
I resolved IRQ_DELAYED_DISABLE irq.h conflict by moving it to higher bitfield position.
The patched kernel booted OK but these reverts did not resolve the OHCI hangs in APIC mode.
The final verdict is: idea #1 was false.
Now I focus on #2 and #3 ideas.

Call for action:
1. If you have any idea why ohci hangs in APIC mode let me know.
2. If you have Nvidia MCP78S mainboard with AMD CPU please send me ACPI dump:
acpidump > dump.bin
bzip2 -9v dump.bin
This will be good APIC code comparison to check the #3 idea.
Do not mess the ML with attachments - send me the file(s) PM.

On my mainboard almost all onboard devices are sitting on INT A according to ACPI code.
Only USB 2.0 EHCI controller sits on INT B alone.

have a nice day,
Zbigniew Luszpinski
