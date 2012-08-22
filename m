Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab2HVWKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:10:38 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:23692 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab2HVWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:10:34 -0400
From: Yann Cantin <yann.cantin@laposte.net>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [RFC ebeam PATCH v4 0/2] new USB eBeam input driver
Date: Thu, 23 Aug 2012 00:11:52 +0200
Message-Id: <1345673514-11575-1-git-send-email-yann.cantin@laposte.net>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

New USB input driver for eBeam devices.

Currently supported (tested) :
- Luidia eBeam classic projection and edge projection models
- Nec "interactive solution" NP01Wi1 & NP01Wi2 accessories.

In fact, from basic usb point of view, all these devices are
indistinguishable : they have the same usb ids and (blank) hid
report descriptors. There's other re-branded hardware that need to be
test, but i bet on same ids. 

So, the code :

Patch 1 to blacklist the devices for hid generic-usb.

Patch 2 is the actual driver.

Notable stuff :
- use div64_s64 for portable 64/64-bits divisions.
- 13 sysfs custom files : 9 values for the transformation matrix,
  4 for xy ranges and a calibration trigger.

The module run fine with a 3.3.6 and a 3.5.0 kernel, both x86_32 and 64.

Thanks for your help.


