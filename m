Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab2HWMug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:50:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59647 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab2HWMub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:50:31 -0400
Message-ID: <1345726401.1481.8.camel@localhost.localdomain>
Subject: [REGRESSION] dell-laptop: Caused by "Remove rfkill code" commit
From: Sebastian =?ISO-8859-1?Q?P=F6hn?= <sebastian.poehn@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: mjg@redhat.com
Date: Thu, 23 Aug 2012 14:53:21 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dell-laptop: Remove rfkill code
a6c2390cd6d2083d27a2359658e08f2d3df375ac

This patch causes some trouble with my dell laptop (Vostro 3300). It produces some annoying behaviour with the Wifi kill-switch.

As rfkill can not get the state of the physical kill-switch, both state may differ.

physical switch is OFF
rfkill state is ON
=> Laptop hangs on boot (maybe because a physical ascent device is used by network subsystem)

physical switch is OFF
rfkill state is OFF
=> Activate interface in Gnome Connection Manager => System hang

test setup:
Dell Vostro 3300
Broadcom 4313 Wifi
Kernel 3.5.[0-2] & 3.6
Fedora 17 

---

Again this is an example for patches accepted in mainline without being tested on supported hardware :-(

