Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1JYWMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 18:12:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48236 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1JYWMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 18:12:32 -0400
MIME-Version: 1.0
Reply-To: gabebblack@gmail.com
Date: Tue, 25 Oct 2011 16:12:30 -0600
Message-ID: <CAHUoWVk-AWekfmXrbY8PeZ2c9nzm6jyuE=orzd7Mxb8HiDuepQ@mail.gmail.com>
Subject: unres_qlen and arp resolution/cache behavior
From: Gabe Black <gabebblack@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation about net.ipv4.neigh.*.unres_qlen seems to indicate that
it determines the number of frames that will be held while an arp is
being resolved.

Say packets start transmitting at a destination that needs to be (arp)
resolved.  If the number of backlogged packets exceeds the queue
length, then the frames are dropped (from what I understand).  My
question is what if the arp cached address expires and another arp is
issued.  Does the same scenario occur (i.e. packets are backlogged
until that arp returns)?  Or is the kernel smart enough to use the old
cached value until the arp returns, at which point it then uses the
updated address?

Thank you for your time,
Gabe
