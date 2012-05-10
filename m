Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2EJUvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:51:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54268 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2EJUve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:51:34 -0400
Date: Thu, 10 May 2012 16:51:20 -0400 (EDT)
Message-Id: <20120510.165120.1054985033661946116.davem@davemloft.net>
To: alexander.h.duyck@intel.com
Cc: jrnieder@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stephen.s.ko@intel.com,
        jeffrey.t.kirsher@intel.com
Subject: Re: [ 33/52] net: Fix issue with netdev_tx_reset_queue not
 resetting queue from XOFF state
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FAC26A5.3050606@intel.com>
References: <20120510.145510.1040533529305157641.davem@davemloft.net>
	<20120510194658.GA9858@burratino>
	<4FAC26A5.3050606@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 13:51:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>
Date: Thu, 10 May 2012 13:35:49 -0700

> On 05/10/2012 12:46 PM, Jonathan Nieder wrote:
>> David Miller wrote:
>>> From: Alexander Duyck <alexander.h.duyck@intel.com>
>>>> All of the changes in igb are unnecessary.  I think they can be dropped
>>>> from the patch as they have already been reverted from the latest
>>>> net-next.  The only change that is really needed is the piece in
>>>> netdevice.h below.
>>> Does it hurt?  If not, just let it be.
>> Based on the commit description for dad8a3b3eaa0 ("igb, ixgbe:
>> netdev_tx_reset_queue incorrectly called from tx init path"), yes, it
>> hurts.  I don't know if it hurts enough to justify holding up this
>> patch until dad8a3b3eaa0 hits mainline.
>>
>> |                            this sort of works in most cases except
>> | when the number of real tx queues changes. When the number of real
>> | tx queues changes netdev_tx_reset_queue() only gets called on the
>> | new number of queues so when we reduce the number of queues we risk
>> | triggering the watchdog timer and repeated device resets.
>> |
>> | So this is not only a cosmetic issue but causes real bugs. For
>> | example enabling/disabling DCB or FCoE in ixgbe will trigger this.
> I'm fairly certain we really shouldn't make the changes to igb.  I would
> say to just modify the existing patch by just dropping the igb portion
> of it and it would be fine.

Ok, Greg, could you do me a huge favor and simply trim the IGB driver
changes from this patch and just keep the linux/netdevice.h part?
