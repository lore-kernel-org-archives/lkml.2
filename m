Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1B1VhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:37:01 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57686 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1B1VhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:37:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aynwY1ilWx5PmEJUzfTkRKzFD8VDTX9VtcT8RqGB0QzJHzYdzhTKOGH70UafkT7fZX
         /XDRJAEm/wbwTcbgnYiO8RQ+3JMPGOODVvERf3YzXwJpRqsTbPsnuZl1KgiDJymHcFVl
         6lJxBF7buCrIlnGq+kF2O2kIkb2ggmo607L5A=
From: aliaksei.katovich@gmail.com
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>
Subject: [PATCH 0/2] mfd: bq2415x charger driver
Date: Mon, 28 Feb 2011 23:36:13 +0200
Message-Id: <cover.1298918741.git.aliaksei.katovich@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <"cover.1298918741.git.aliaksei.katovich@nokia.com">
References: <"cover.1298918741.git.aliaksei.katovich@nokia.com">
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aliaksei Katovich <aliaksei.katovich@nokia.com>

The bq2415x family of Texas Instruments charger ICs are multifunctional chips
that combine voltage/current regulation with Li-Ion battery charge controller.

Given bq2415x driver implements both regulator and i2c devices within single
module. Despite not being mfd core dependant this driver however is thought
to belong to mfd subsystem rather than regulators or i2c one.

Also I have some concern about hardcoded i2c addresses which may well limit
driver usage to some certain hardware set. Alternatively driver can be extented
to support device tree or another relevant interface to eliminate this possible
limit.

Implementation is based on BQ24153/6/8 datasheet.

The patch set applies cleanly to the MFD repository at
git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git

Please review.

Aliaksei Katovich (2):
  mfd: bq2415x charger driver
  mfd: bq2415x compilation enablers

 drivers/mfd/Kconfig         |    7 +
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/bq2415x.c       |  780 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/bq2415x.h |   88 +++++
 4 files changed, 876 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/bq2415x.c
 create mode 100644 include/linux/mfd/bq2415x.h

