Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1KWFsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 00:48:35 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40812 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1KWFse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 00:48:34 -0500
MIME-Version: 1.0
In-Reply-To: <20111122.232111.1611305088991571289.davem@davemloft.net>
References: <jah1te$h33$1@dough.gmane.org>
	<20111122.155557.1954460980055957565.davem@davemloft.net>
	<4ECC512D.2010002@gmail.com>
	<20111122.232111.1611305088991571289.davem@davemloft.net>
Date: Tue, 22 Nov 2011 23:48:33 -0600
Message-ID: <CADLC3L2SUPkDoLRiP8pjCv6f+QhqgRUkJpDj5MBkO6xS1zmZ_A@mail.gmail.com>
Subject: Re: Kernelpanic on eeePC and MSI Wind (both using rt2800pci) with
 Linux 3.x
From: Robert Hancock <hancockrwd@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: michael@alpha-unix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:21 PM, David Miller <davem@davemloft.net> wrote:
> From: Robert Hancock <hancockrwd@gmail.com>
> Date: Tue, 22 Nov 2011 19:49:33 -0600
>
>> On 11/22/2011 02:55 PM, David Miller wrote:
>>> From: Michael Basse<michael@alpha-unix.de>
>>> Date: Tue, 22 Nov 2011 21:49:49 +0100
>>>
>>>> Hi,
>>>>
>>>> just for the record. This thread is hopefully providing a patch
>>>>
>>>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/80759
>>>>
>>>> already built the kernel and doing some testing now.
>>>
>>> That patch is wrong, it returns IRQ_HANDLED when it can't tell if the
>>> chip generated the interrupt or not.
>>>
>>> Therefore, if any other device shares that interrupt line it's
>>> interrupts can be lost when this case triggers.
>>>
>>> This has to be fixed another way.
>>
>> Huh? IRQ_HANDLED is the "safe" return value when you don't know for
>> sure whether your device generated the interrupt. Returning that
>> doesn't prevent other handlers on the same IRQ from being called.
>
> But it prevents being able to notice spurious interrupts from
> other devices sharing the IRQ.
>
> You absolutely must return an accurate return value here for correct
> operation, you simply cannot "guess".

Certainly it's best to do so when possible, but with some hardware it
simply isn't possible to do this. In some cases there's no register
that reliably indicates whether or not the device raised an interrupt.
