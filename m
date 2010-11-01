Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab0KAPvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:51:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39279
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756831Ab0KAPvC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:51:02 -0400
Date: Mon, 01 Nov 2010 08:51:26 -0700 (PDT)
Message-Id: <20101101.085126.71102684.davem@davemloft.net>
To: jwboyer@gmail.com
Cc: sfr@canb.auug.org.au, rsarmah@apm.com, therbert@google.com,
        eric.dumazet@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: All Applied micro boards are failing with current mainline
 kernel
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTin3nsb6FfNtXfqjZCuV66mwKVOsKgmZpTABFDUJ@mail.gmail.com>
References: <AANLkTikQuUcAMZKqZ3Rz5HVzOs+63-Y4VYUo5-3EM30H@mail.gmail.com>
	<20101102023650.bc553e74.sfr@canb.auug.org.au>
	<AANLkTin3nsb6FfNtXfqjZCuV66mwKVOsKgmZpTABFDUJ@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@gmail.com>
Date: Mon, 1 Nov 2010 11:39:47 -0400

> On Mon, Nov 1, 2010 at 11:36 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Josh,
>>
>> On Mon, 1 Nov 2010 11:05:53 -0400 Josh Boyer <jwboyer@gmail.com> wrote:
>>>
>>> A few hints would be appreciated.
>>
>> Remove the call to netif_stop_queue() from emac_probe().  Apparently,
>> calling this before register_netdev() is now wrong (maybe always was).
> 
> Yeah, I just discovered that myself.  I'm wondering
> 
> 1) why we do that in that function?

Because likely it was blindly copied from some other driver.

> 2) If it needs to be removed entirely, or moved to after the
> register_netdev call

Removed entirely.

> 3) If the call to netif_carrier_off also needs similar attention.

Not really.

> I can whip up a patch to remove those calls or move them after the
> register, but I don't want to do that without knowing which one is
> "right".

I've already taken care of this.
