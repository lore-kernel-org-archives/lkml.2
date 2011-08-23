Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1HWCSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 22:18:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45545 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1HWCSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 22:18:35 -0400
Date: Mon, 22 Aug 2011 19:13:48 -0700 (PDT)
Message-Id: <20110822.191348.2099822249437201579.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        mikey@neuling.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org
Subject: Re: linux-next: boot test failure (net tree)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110823114129.ceb18da164bf7df3c145941b@canb.auug.org.au>
References: <20110822113032.15087c2e190e2b0c3ee7dfb8@canb.auug.org.au>
	<20110823114011.a059aea0138b75bfa7eed1ce@canb.auug.org.au>
	<20110823114129.ceb18da164bf7df3c145941b@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 22 Aug 2011 19:14:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 23 Aug 2011 11:41:29 +1000

> On Tue, 23 Aug 2011 11:40:11 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> On Mon, 22 Aug 2011 11:30:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >
>> > Here's what I am applying as a merge fixup to the net tree today so that
>> > my ppc64_defconfig builds actually build more or less the same set of
>> > drivers as before this rearrangement.
>> 
>> And this today:
> 
> And this:

I'm starting to get uncomfortable with this whole situation, and I
feel more and more that these new kconfig guards are not tenable.

Changing defconfig files might fix the "automated test boot with
defconfig" case but it won't fix the case of someone trying to
automate a build and boot using a different, existing, config file.
It ought to work too, and I do know people really do this.

And just the fact that we would have to merge all of these defconfig changes
through the networking tree is evidence of how it's really not reasonable
to be doing things this way.

Jeff, I think we need to revert the dependencies back to what they were
before the drivers/net moves.  Could you prepare a patch which does that?

