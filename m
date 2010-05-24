Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab0EXW1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:27:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35496 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757150Ab0EXW1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:27:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [Regression] Commit "power_supply: Use attribute groups" breaks KDE battery monitor on openSUSE 11.3 M6
Date: Tue, 25 May 2010 00:28:24 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Daniel Mack <daniel@caiaq.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005250028.24687.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Your commit 5f487cd34f4337f9bc27ca19da72a39d1b0a0ab4 (power_supply: Use
attribute groups) unfortunately breaks KDE 4.4's battery monitor from openSUSE
11.3 Milestone 6 on my Acer Ferrari One.  Apparently, the battery monitor can't
access the sysfs battery attributes with this commit applied.

Reverting the commit along with commit 0011d2d4a5f7bb5666dcfb9f9b3dbdb084ab98f1
(power_supply: Add support for writeable properties) fixes the problem for me, but
reverting commit 0011d2d4a5f7bb5666dcfb9f9b3dbdb084ab98f1 alone doesn't fix it,
so it looks like your commit is the source of the problem.

Thanks,
Rafael
