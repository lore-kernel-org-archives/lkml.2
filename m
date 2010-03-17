Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0CQWHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:07:41 -0400
Received: from mail-ew0-f221.google.com ([209.85.219.221]:36827 "EHLO
	mail-ew0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab0CQWHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sSngivNuEpZiTLTMqs1nhY8DbLU/2F5mm7oa+uiqVoJMVcUf7A2P0vfi7HYsY5B19B
         U2cWlkjSvCN80ZWmePqB2O6cjsqDCV76gH4BBOBJJ/27i1GlHu5h5f+v/TTPMNyzmr7G
         PSdLAC3mTOf9bnoWZUCZERTp/iZifEi3rx3Eo=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 0/9] USB: serial: generic driver fixes and bulk buffer feature
Date: Wed, 17 Mar 2010 23:00:36 +0100
Message-Id: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a few of fixes to the generic driver as well as a new feature that
lets drivers determine the size of the bulk buffers more easily. It turns out
that increasing the out-buffer sizes for cp210x and pl2303 have a significant
effect on throughput.

Thanks,
Johan

Johan Hovold (9):
  USB: serial: allow drivers to define bulk buffer sizes
  USB: cp210x: increase the bulk-out buffer size to 256 byte
  USB: cp210x: increase bulk-in buffer size to 256 byte
  USB: pl2303: increase the bulk-out buffer size to 256 byte
  USB: pl2303: increase bulk-in buffer size to 256 byte
  USB: serial: fix generic chars_in_buffer
  USB: serial: fix missing locking on fifo in write callback
  USB: serial: clear fifo on close
  USB: serial: refactor generic close

 drivers/usb/serial/ark3116.c     |    7 ++-----
 drivers/usb/serial/belkin_sa.c   |    4 +---
 drivers/usb/serial/ch341.c       |    5 +----
 drivers/usb/serial/cp210x.c      |    7 +++----
 drivers/usb/serial/ftdi_sio.c    |   16 +---------------
 drivers/usb/serial/generic.c     |   31 ++++++++++++++++++++++++-------
 drivers/usb/serial/ipaq.c        |   28 ++--------------------------
 drivers/usb/serial/iuu_phoenix.c |   30 ++----------------------------
 drivers/usb/serial/mct_u232.c    |    7 ++-----
 drivers/usb/serial/pl2303.c      |    2 ++
 drivers/usb/serial/usb-serial.c  |    8 ++++++--
 include/linux/usb/serial.h       |    5 +++++
 12 files changed, 51 insertions(+), 99 deletions(-)

