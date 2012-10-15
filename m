Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2JOH54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:57:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62296 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab2JOH5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:57:54 -0400
From: sjur.brandeland@stericsson.com
To: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv7 0/4] virtio_console: Add rproc_serial driver
Date: Mon, 15 Oct 2012 09:57:32 +0200
Message-Id: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

This patch-set introduces a new virtio type "rproc_serial" for communicating
with remote processors over shared memory. The driver depends on the
the remoteproc framework. As preparation for introducing "rproc_serial"
I've done a refactoring of the transmit buffer handling.

This patch-set is a rework of the patch-set from Sept 25th, hopefully all
review comments has been addressed.

The fist patch is a bugfix and migth be applicable for 3.7.

Thanks,
Sjur

Sjur Brændeland (4):
  virtio_console: Free buffer if splice fails
  virtio_console: Use kmalloc instead of kzalloc
  virtio_console: Merge struct buffer_token into struct port_buffer
  virtio_console: Add support for remoteproc serial

 drivers/char/virtio_console.c |  328 +++++++++++++++++++++++++++++------------
 include/linux/virtio_ids.h    |    1 +
 2 files changed, 234 insertions(+), 95 deletions(-)

-- 
1.7.5.4

