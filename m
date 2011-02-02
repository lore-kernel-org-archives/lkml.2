Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1BBXXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 18:23:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37509
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278Ab1BBXXP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:23:15 -0500
Date: Wed, 02 Feb 2011 15:23:50 -0800 (PST)
Message-Id: <20110202.152350.28800670.davem@davemloft.net>
To: mans@mansr.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: ARM unaligned MMIO access with attribute((packed))
From: David Miller <davem@davemloft.net>
In-Reply-To: <yw1xei7qm3vy.fsf@unicorn.mansr.com>
References: <20110202163702.GA23240@n2100.arm.linux.org.uk>
	<20110202.133831.193702414.davem@davemloft.net>
	<yw1xei7qm3vy.fsf@unicorn.mansr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Måns Rullgård <mans@mansr.com>
Date: Wed, 02 Feb 2011 23:08:01 +0000

> David Miller <davem@davemloft.net> writes:
> 
>> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
>> Date: Wed, 2 Feb 2011 16:37:02 +0000
>>
>>> 1. there's no way to tell GCC that the inline assembly is a load
>>>    instruction and therefore it needs to schedule the following
>>>    instructions appropriately.
>>
>> Just add a dummy '"m" (pointer)' asm input argument to the inline asm
>> statement.  Just make sure "typeof(pointer)" has a size matching the
>> size of the load your are performing.
> 
> That should be "m"(*pointer).

Right, thanks for the correction.

>> But you really need that memory clobber there whether you like it or
>> not, see above.
> 
> I don't know of any device where the side-effects are not explicitly
> indicated by other means in the code triggering them, so it probably
> is safe without the clobber as Russel says.

You're probably right.
