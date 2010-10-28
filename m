Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab0J1DST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 23:18:19 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:43305 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756615Ab0J1DSR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 23:18:17 -0400
From: "B. James Phillippe" <bryanp35@comcast.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Confusion on change from Jun '09, to remove connection-tracking notifier
Date: Wed, 27 Oct 2010 20:18:15 -0700
Message-Id: <C7A53805-4406-4663-9F28-F2ECBB28F875@comcast.net>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1081)
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

First let me thank you for reading my message.  I was a LKML subscriber and Linux hacker many years ago but made the switch over to the dark side (NetBSD, then OS X) and am just coming back to Linux.

I have a kernel module (GPL) I'm trying to update from 2.6.2x to 2.6.3x.  This module uses the old ip_conntrack_register_notifier() API to make use of conntrack events from netfilter.  This API was refactored in Jun '09 to become nf_conntrack_register_notifier() through commit e34d5c1a4f9919a81b4ea4591d7383245f35cb8e.  In its new form, it is a mutually-exclusive interface.  NETLINK is the only kernel-based user of this API that I can find.  Because it is now mutually-exclusive, for my module to use it, it would have to do so at the expense of NETLINK.

I'm trying to understand what the appropriate interface now is for me to get access to conntrack events in harmony with NETLINK.  It looks like I should be using NETLINK, which is fine, but I cannot find a clean example of how to do that from within the kernel.  The NETLINK socket interface (and corresponding library) for doing fancy things with NETLINK from userspace is certainly clear, but I don't think I should need to go through that much complexity.

Specifically, all I want to be able to do with my module is add additional tracking for creation/deletion of conntrack entries.  What is the intended (hopefully simple) mechanism that I should use for this purpose in 2.6.3x kernel?

Thanks again for reading,
--
-bp


