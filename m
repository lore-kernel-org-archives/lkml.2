Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab2FQVF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 17:05:29 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46837 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab2FQVF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 17:05:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] Plan to get rid of all legacy PM handling
Date: Sun, 17 Jun 2012 23:10:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206172310.49148.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a plan to replace all of the legacy device PM callbacks throughout
the kernel with PM handling based on struct dev_pm_ops objects.  Ultimately,
that should make it possible to remove the legacy hooks from struct bus_type
and struct device_driver and to siplify the PM core and some bus types
(most importantly PCI) quite a bit.

I'm going to start with platform drivers that should be the most
straightforward to convert and when they all have been dealt with it
should be possible to drop the platform bus type's PM callbacks entirely.
Next, I'm going to take care of the bus types that only define PM callbacks
to call drivers' callbacks, which is completely unnecessary after some PM
core changes that went in during the 3.4 development cycle.  Finally, I will
be looking at PCI drivers.

The task is huge, but I've done similar things already, so it's nothing new
to me.  So, if you're a maintainer of code that contains legacy PM handling,
please be prepared to see some patches from me in a not-too-distant-future.

Thanks,
Rafael
