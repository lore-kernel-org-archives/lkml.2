Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1KNXqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:46:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab1KNXqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:46:17 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mst@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        penberg@kernel.org, mingo@elte.hu,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 0/5] virtio-pci,kvm tools: Support new virtio-pci spec in kvm tools
Date: Tue, 15 Nov 2011 01:43:12 +0200
Message-Id: <1321314197-5265-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1
In-Reply-To: <20111114181854.GA24953@redhat.com>
References: <20111114181854.GA24953@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains two fixes for the RFC patch send by Michael. These
patches are pretty basic and should probably be merged into the next version
of that patch.

Other two patches add support to the new virtio-pci spec in KVM tools, allowing
for easy testing of any future virtio-pci kernel side patches. The usermode code
isn't complete, but it's working properly and should be enough for functionality
testing.

Michael S. Tsirkin (1):
  virtio-pci: flexible configuration layout

Sasha Levin (4):
  virtio-pci: Fix compilation issue
  iomap: Don't ignore offset
  kvm tools: Free up the MSI-X PBA BAR
  kvm tools: Support new virtio-pci configuration layout

 drivers/virtio/virtio_pci.c        |  184 ++++++++++++++++++++++--
 include/asm-generic/io.h           |    4 +
 include/asm-generic/iomap.h        |   11 ++
 include/linux/pci_regs.h           |    4 +
 include/linux/virtio_pci.h         |   41 ++++++
 lib/iomap.c                        |   41 +++++-
 tools/kvm/include/kvm/pci.h        |   13 ++-
 tools/kvm/include/kvm/virtio-pci.h |    5 +-
 tools/kvm/virtio/pci.c             |  275 ++++++++++++++++++++++++++++++++----
 9 files changed, 530 insertions(+), 48 deletions(-)

-- 
1.7.8.rc1

