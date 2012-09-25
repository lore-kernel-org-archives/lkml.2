Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2IYNrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:47:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40582 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab2IYNrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:47:36 -0400
From: sjur.brandeland@stericsson.com
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjurbren@stericsson.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCHv6 0/3] virtio_console: Add rproc_serial device
Date: Tue, 25 Sep 2012 15:47:14 +0200
Message-Id: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

I thought rebasing rproc_serial to linux-next was going to be trivial.
But when starting the merge I realized that I had to refactor the
the patches from  Masami Hiramatsu. The splice support has the same issue
as I faced, with different type of buffers in the out_vq.
So I ended up refactoring the splice functionality. The code
size got smaller so hopefully this a step in the right direction.

This refactoring also make introduction of rproc_serial cleaner.

As requested I also added a patch for not initializing buffers.

I have tested the VIRTIO_CONSOLE device by looping large amount of data
through character device and tty, with lockdep and slub-debug on.
This looks stable for me. I've also done a simple test of splice.

Thanks,
Sjur

cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Michael S. Tsirkin <mst@redhat.com>
cc: Amit Shah <amit.shah@redhat.com>
cc: Linus Walleij <linus.walleij@linaro.org>
cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>


Sjur Brændeland (3):
  virtio_console:Merge struct buffer_token into struct port_buffer
  virtio_console: Add support for remoteproc serial
  virtio_console: Don't initialize buffers to zero

 drivers/char/virtio_console.c |  318 +++++++++++++++++++++++++++++------------
 include/linux/virtio_ids.h    |    1 +
 2 files changed, 228 insertions(+), 91 deletions(-)

-- 
1.7.5.4

