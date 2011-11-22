Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1KVVGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:06:19 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53984 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab1KVVGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:06:18 -0500
Date: Tue, 22 Nov 2011 16:05:11 -0500 (EST)
Message-Id: <20111122.160511.2302883259439708995.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-11-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111122205655.GE8452@tuxdriver.com>
References: <20111122193505.GC8452@tuxdriver.com>
	<20111122.151429.253381379981773726.davem@davemloft.net>
	<20111122205655.GE8452@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 Nov 2011 13:05:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 22 Nov 2011 15:56:55 -0500

> On Tue, Nov 22, 2011 at 03:14:29PM -0500, David Miller wrote:
>> From: "John W. Linville" <linville@tuxdriver.com>
>> Date: Tue, 22 Nov 2011 14:35:05 -0500
>> 
>> > Here is the latest batch of fixes intended for 3.2.  This includes a
>> > correction for a user-visible error in mac80211's debugfs info, a fix
>> > for a potential memory corrupter in prism54, an endian fix for rt2x00,
>> > an endian fix for mac80211, a fix for a NULL derefernce in cfg80211, a
>> > locking fix and a deadlock fix for p54spi, and a pair of rt2x00 fixes
>> > for handling some spurious interrupts that hardware can generate.
>> > 
>> > Please let me know if there are problems!
>> 
>> The rt2800pci change doesn't look correct.
>> 
>> If the IRQ line is shared with another device, this change will make it
>> never see interrupts.  Once you say "IRQ_HANDLED" the IRQ dispatch
>> stops processing the interrupt handler list.
> 
> I thought this at first as well.  But looking at the code in
> kernel/irq/handle.c doesn't support that conclusion.  In fact, every
> handler gets invoked no matter what they all return.  All of the irq
> handler return values are ORed together and passed to note_interrupt.
> Only if every irq handler returns IRQ_NONE does the code in
> kernel/irq/spurious.c start getting involved.
> 
> Anyway, this seems to be safe even for shared interrupts.  That said,
> this is a bit ugly.  But it makes a serious difference in performance
> for those afflicted with this issue.

It just means that we won't notice spurious interrupts if the device
sharing the line with rt2800pci generates one.

This change is wrong.
