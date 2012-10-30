Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2J3IwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:52:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56340 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab2J3IwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:52:02 -0400
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv8 0/3]virtio_console: Add rproc_serial driver
Date: Tue, 30 Oct 2012 09:51:50 +0100
Message-Id: <1351587113-2566-1-git-send-email-sjur@brendeland.net>
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

Changes since v7:
- Rebased to virtio-next branch.
- Removed extra added lines.
- Removed superfluous checks before calling reclaim_dma_bufs().
- Rusty raised some question regarding garbage collection of the
  out-vq, so I moved this into a separate patch.

Thanks,
Sjur


Sjur Brændeland (3):
  virtio_console: Merge struct buffer_token into struct port_buffer
  virtio_console: Add support for remoteproc serial
  virtio_console: Remove buffers from out_vq at port removal

 drivers/char/virtio_console.c   |  325 +++++++++++++++++++++++++++------------
 include/uapi/linux/virtio_ids.h |    1 +
 2 files changed, 230 insertions(+), 96 deletions(-)

-- 
1.7.9.5

