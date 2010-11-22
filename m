Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0KVQfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:35:23 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32864 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0KVQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=a1N6PAD5zpVma/YunrmqAgY11JJOTWhP/eFeYMw3MVX3L9Sd+E5CcSmFoKTD184Bn0
         t4WS2la3k755JRgc68P02YYKm84Jy15Du+huspqUJpSwMCt6/zkCvii9o1afH7kPTPzq
         Ndek+kY8XjN/AQaVrBVv4BXKtmL3mDpBCD48M=
From: mkl0301@gmail.com
To: cbouatmailru@gmail.com, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Cc: Mac Lin <mkl0301@gmail.com>
Subject: [PATCH v2 0/3] USB: add support for cns3xxx SOC's EHCI/OHCI controller
Date: Tue, 23 Nov 2010 00:32:42 +0800
Message-Id: <1290443565-20766-1-git-send-email-mkl0301@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mac Lin <mkl0301@gmail.com>

v2:
 - Changing CNS3XXX to cns3xxx in subjec for part of the patches are filtered due to "capital Triple-X in subject".

v1: 
The first patch prepare the mach-cns3xxx power management code for drivers use.
The other two patches add the bus glue for EHCI/OHCI controller in mach-cns3xxx 
and usb.

This patchset is based on linux-2.6.37-rc2

Mac Lin (3):
      ARM: cns3xxx: Add new and export the old power management functions
      ARM: cns3xxx: Add architecture definition for EHCI/OHCI controller
      USB: cns3xxx: Add EHCI and OHCI bus glue for cns3xxx SOCs

 arch/arm/mach-cns3xxx/cns3420vb.c            |   50 ++++++++
 arch/arm/mach-cns3xxx/core.h                 |    4 +-
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h |    2 -
 arch/arm/mach-cns3xxx/include/mach/pm.h      |   21 +++
 arch/arm/mach-cns3xxx/pm.c                   |   21 +++
 drivers/usb/Kconfig                          |    2 +
 drivers/usb/host/Kconfig                     |   15 +++
 drivers/usb/host/ehci-cns3xxx.c              |  176 ++++++++++++++++++++++++++
 drivers/usb/host/ehci-hcd.c                  |    5 +
 drivers/usb/host/ohci-cns3xxx.c              |  171 +++++++++++++++++++++++++
 drivers/usb/host/ohci-hcd.c                  |    5 +
 11 files changed, 468 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/mach-cns3xxx/include/mach/pm.h
 create mode 100644 drivers/usb/host/ehci-cns3xxx.c
 create mode 100644 drivers/usb/host/ohci-cns3xxx.c
