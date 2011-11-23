Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab1KWEVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 23:21:20 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58171 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab1KWEVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 23:21:19 -0500
Date: Tue, 22 Nov 2011 23:21:11 -0500 (EST)
Message-Id: <20111122.232111.1611305088991571289.davem@davemloft.net>
To: hancockrwd@gmail.com
Cc: michael@alpha-unix.de, linux-kernel@vger.kernel.org
Subject: Re: Kernelpanic on eeePC and MSI Wind (both using rt2800pci) with
 Linux 3.x
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ECC512D.2010002@gmail.com>
References: <jah1te$h33$1@dough.gmane.org>
	<20111122.155557.1954460980055957565.davem@davemloft.net>
	<4ECC512D.2010002@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 Nov 2011 20:21:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Hancock <hancockrwd@gmail.com>
Date: Tue, 22 Nov 2011 19:49:33 -0600

> On 11/22/2011 02:55 PM, David Miller wrote:
>> From: Michael Basse<michael@alpha-unix.de>
>> Date: Tue, 22 Nov 2011 21:49:49 +0100
>>
>>> Hi,
>>>
>>> just for the record. This thread is hopefully providing a patch
>>>
>>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/80759
>>>
>>> already built the kernel and doing some testing now.
>>
>> That patch is wrong, it returns IRQ_HANDLED when it can't tell if the
>> chip generated the interrupt or not.
>>
>> Therefore, if any other device shares that interrupt line it's
>> interrupts can be lost when this case triggers.
>>
>> This has to be fixed another way.
> 
> Huh? IRQ_HANDLED is the "safe" return value when you don't know for
> sure whether your device generated the interrupt. Returning that
> doesn't prevent other handlers on the same IRQ from being called.

But it prevents being able to notice spurious interrupts from
other devices sharing the IRQ.

You absolutely must return an accurate return value here for correct
operation, you simply cannot "guess".
