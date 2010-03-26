Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab0CZEzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 00:55:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51742 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab0CZEzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 00:55:31 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near overflowing v2
References: <20100324190150.GA18803@basil.fritz.box>
	<alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>
	<alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
	<20100325003652.GG20695@one.firstfloor.org>
	<alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
	<20100325093744.GH20695@one.firstfloor.org>
	<alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
	<alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
	<20100325162737.GA5276@elte.hu>
	<20100325182702.GR20695@one.firstfloor.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 25 Mar 2010 21:55:19 -0700
In-Reply-To: <20100325182702.GR20695@one.firstfloor.org> (Andi Kleen's message of "Thu\, 25 Mar 2010 19\:27\:02 +0100")
Message-ID: <m1pr2rk7go.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: andi@firstfloor.org, jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> I think the patch as posted solves a real problem, but also perpetuates a bad 
>> situation.
>> 
>> At minimum we should print a (one-time) warning that some badness occured. 
>> That would push us either in the direction of improving drivers, or towards 
>> improving the generic code.
>
> What should a driver do to prevent that? I don't see what it could do
> short of castrating itself (like refusing to use multiple ports)
> As Linus says the driver doesn't know if setting IRQF_DISABLED is safe.

As an aside this is happening on MSI irqs.  They can never be shared.
So in fact the driver can know it is safe.

Should we perhaps make all MSI irqs automatically set IRQF_DISABLED?

Eric
