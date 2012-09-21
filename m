Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2IUSN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:13:26 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:58979 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab2IUSNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:13:25 -0400
Date: Fri, 21 Sep 2012 19:54:55 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
Message-ID: <20120921175455.GA28255@electric-eye.fr.zoreil.com>
References: <505B522F.9090808@asyr.hopto.org> <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com> <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505C98C7.20302@asyr.hopto.org>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> :
[...]
> Hmm, think I got it ... Here is what I put there:
>
> ifconfig eth0 192.168.0.19 up ; ping -c 3 192.168.0.1

If it fails with the r8169 driver included in the 3.5 tree, that's what
you can use, yes (you may add a second ping with -q -f -l and more
packets to wrap the descriptor rings quickly as well).

[...]
> In order to run the following steps, should I be running (should I boot)
> the system with the 2.6.38-8 or the 3.5.4 kernel?

2.6.38-8

> What kernel source trees do I need to have under /usr/src ?

Please take a look at the Makefile:
[...]
KDIR := /lib/modules/$(shell uname -r)/build

It's more a matter of "what do I have under /lib/modules/$(uname -r)/build ?"
(namely your 2.6.38-8 tree or a symlink to it).

> Do I need to run make clean/mrproper beforehand?

As long as it matches your running config, no.

> Does it matter which source tree the /usr/src/linux symlink points to ?

See above ?

-- 
Ueimor
