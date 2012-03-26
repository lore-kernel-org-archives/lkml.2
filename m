Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab2CZKls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:41:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44437 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab2CZKlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:41:47 -0400
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 26 Mar 2012 16:11:24 +0530
Message-ID: <CAO_48GGXBNLqW8cBpAekzVQV8xZ_pLugg7uVaB+dXN4jLEE+iw@mail.gmail.com>
Subject: [GIT PULL]: dma-buf updates for 3.4
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: Jesse Barker <jesse.barker@linaro.org>, akpm@linux-foundation.org,
        Daniel Vetter <daniel@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the dma-buf updates for 3.4? This includes the
following key items:

- kernel cpu access support,
- flag-passing to dma_buf_fd,
- relevant Documentation updates, and
- some minor cleanups and fixes.

These changes are needed for the drm prime/dma-buf interface code that
Dave Airlie plans to submit in this merge window.

Thanks, and best regards,
~Sumit.

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:
  git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git for-linus-3.4

Daniel Vetter (3):
      dma-buf: don't hold the mutex around map/unmap calls
      dma-buf: add support for kernel cpu access
      dma_buf: Add documentation for the new cpu access support

Dave Airlie (1):
      dma-buf: pass flags into dma_buf_fd.

Laurent Pinchart (4):
      dma-buf: Constify ops argument to dma_buf_export()
      dma-buf: Remove unneeded sanity checks
      dma-buf: Return error instead of using a goto statement when possible
      dma-buf: Move code out of mutex-protected section in dma_buf_attach()

Rob Clark (2):
      dma-buf: add get_dma_buf()
      dma-buf: document fd flags and O_CLOEXEC requirement

Sumit Semwal (2):
      dma-buf: add dma_data_direction to unmap dma_buf_op
      dma-buf: correct dummy function declarations.

 Documentation/dma-buf-sharing.txt |  120 ++++++++++++++++++++++++++-
 drivers/base/dma-buf.c            |  165 +++++++++++++++++++++++++++++++------
 include/linux/dma-buf.h           |   97 +++++++++++++++++++--
 3 files changed, 345 insertions(+), 37 deletions(-)
