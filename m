Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2IUPrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:47:00 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:58511 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2IUPq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:46:59 -0400
Date: Fri, 21 Sep 2012 17:28:28 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
Message-ID: <20120921152828.GA24364@electric-eye.fr.zoreil.com>
References: <505B522F.9090808@asyr.hopto.org> <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com> <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505BF437.4090506@asyr.hopto.org>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> :
> on 09/21/2012 02:20 AM Francois Romieu wrote the following:
[...]
> > Thanasis, can you narrow down a bit the failing revision ?
> 
> Sure, let me know how to do it please.

A rough kernel estimate had been enough. Nevermind.

You will find a hopefully not too quick 2.6.38 backport at :

git://violet.fr.zoreil.com/romieu/r8169

It does not reach the current in-kernel r8169.c state - call me lazy - but
stops somewhere between 3.2 and 3.3. While only 76 commits long, it should
be enough to spot a r8169 regression.

Assuming you run a 2.6.38-something kernel whose build tree lays at the
usual place, the included makefile will build a out-of-kernel r8169 driver.

You can use it as:

git clone git://violet.fr.zoreil.com/romieu/r8169
cd r8169
git rev-list --all | tac | while read c; do
git reset --hard $c
make
rmmod r8169
sync
insmod ./r8169.ko
<insert your ip addr add ... / link up and test sequence here>
done > /tmp/lets-go-shopping.log

^C when things go wrong.

You could do a git bisect but there may be several stupidly broken
commits and I have not checked that the top of the tree works.

Of course you are suggested to check that the code won't try to abuse
your system.

-- 
Ueimor
