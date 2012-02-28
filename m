Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965648Ab2B1VHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:07:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49380 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964902Ab2B1VHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:07:32 -0500
Date: Tue, 28 Feb 2012 16:07:20 -0500 (EST)
Message-Id: <20120228.160720.990486775074267929.davem@davemloft.net>
To: mcarlson@broadcom.com
Cc: James.Bottomley@HansenPartnership.com, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, florian@mickler.org, mchan@broadcom.com,
        bhutchings@solarflare.com, netdev@vger.kernel.org
Subject: Re: [Bug #42707] Hang deconfiguring network interface (in
 shutdown) on 3.3-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120228012408.GA29622@mcarlson.broadcom.com>
References: <qCQH7HfZS8E.A.x6F.98rRPB@chimera>
	<1330386274.2822.105.camel@dabdike.int.hansenpartnership.com>
	<20120228012408.GA29622@mcarlson.broadcom.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 13:07:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matt Carlson" <mcarlson@broadcom.com>
Date: Mon, 27 Feb 2012 17:24:08 -0800

> On Mon, Feb 27, 2012 at 05:44:34PM -0600, James Bottomley wrote:
>> On Thu, 2012-02-23 at 23:55 +0100, Rafael J. Wysocki wrote:
>> > This message has been generated automatically as a part of a summary report
>> > of recent regressions.
>> > 
>> > The following bug entry is on the current list of known regressions
>> > from 3.2.  Please verify if it still should be listed and let the tracking team
>> > know (either way).
>> > 
>> > 
>> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42707
>> > Subject		: Hang deconfiguring network interface (in shutdown) on 3.3-rc1
>> > Submitter	: James Bottomley <James.Bottomley@hansenpartnership.com>
>> > Date		: 2012-01-28 19:56 (27 days old)
>> > Message-ID	: <1327780565.2924.24.camel@dabdike.int.hansenpartnership.com>
>> > References	: http://marc.info/?l=linux-kernel&m=132778076214873&w=2
>> 
>> Still present in 3.3-rc4; I've bisected it back to this commit:
>> 
>> commit 92feeabf3f673767c6ee4cfc7fc224098446c1c1
>> Author: Matt Carlson <mcarlson@broadcom.com>
>> Date:   Thu Dec 8 14:40:14 2011 +0000
>> 
>>     tg3: Save stats across chip resets
>> 
>> and sure enough, just reverting this single commit on 3.3-rc4 fixes the
>> problem.
>> 
>> James
> 
> I don't see anything incorrect about the patch.  I'm guessing the patch
> just changes the timing somehow.
> 
> tg3_reset_chip() does not take any driver-internal spinlocks.  That
> happens at tg3_close().  I'm guessing the spinlock in the trace is coming
> from synchronize_irq().

If you can't figure it out, we need to revert, so send me a revert patch
as soon as possible.
