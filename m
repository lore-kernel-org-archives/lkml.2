Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2IUQlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:41:46 -0400
Received: from cust-218-222.on4.ontelecoms.gr ([92.118.218.222]:53387 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab2IUQlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:41:45 -0400
Message-ID: <505C98C7.20302@asyr.hopto.org>
Date: Fri, 21 Sep 2012 19:41:43 +0300
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
References: <505B522F.9090808@asyr.hopto.org> <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com> <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com>
In-Reply-To: <20120921152828.GA24364@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 09/21/2012 06:28 PM Francois Romieu wrote the following:
> Thanasis <thanasis@asyr.hopto.org> :
>> on 09/21/2012 02:20 AM Francois Romieu wrote the following:
> [...]
>>> Thanasis, can you narrow down a bit the failing revision ?
>>
>> Sure, let me know how to do it please.
> 
> A rough kernel estimate had been enough. Nevermind.
> 
> You will find a hopefully not too quick 2.6.38 backport at :
> 
> git://violet.fr.zoreil.com/romieu/r8169
> 
> It does not reach the current in-kernel r8169.c state - call me lazy - but
> stops somewhere between 3.2 and 3.3. While only 76 commits long, it should
> be enough to spot a r8169 regression.
> 
> Assuming you run a 2.6.38-something kernel whose build tree lays at the
> usual place, the included makefile will build a out-of-kernel r8169 driver.

In order to run the following steps, should I be running (should I boot)
the system with the 2.6.38-8 or the 3.5.4 kernel?
What kernel source trees do I need to have under /usr/src ?
Do I need to run make clean/mrproper beforehand?
Does it matter which source tree the /usr/src/linux symlink points to?

> 
> You can use it as:
> 
> git clone git://violet.fr.zoreil.com/romieu/r8169
> cd r8169
> git rev-list --all | tac | while read c; do
> git reset --hard $c
> make
> rmmod r8169
> sync
> insmod ./r8169.ko
> <insert your ip addr add ... / link up and test sequence here>
> done > /tmp/lets-go-shopping.log
> 
> ^C when things go wrong.
> 
> You could do a git bisect but there may be several stupidly broken
> commits and I have not checked that the top of the tree works.
> 
> Of course you are suggested to check that the code won't try to abuse
> your system.
> 

