Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2GWUcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:32:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33778 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab2GWUcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:32:21 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: rusty@rustcorp.com.au, mst@redhat.com, penberg@kernel.org,
        asias.hejun@gmail.com
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, anthony@codemonkey.ws,
        wency@cn.fujitsu.com, Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 0/2] virtio: provide a way for host to monitor critical events in the device
Date: Mon, 23 Jul 2012 22:32:39 +0200
Message-Id: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it was discussed recently, there's currently no way for the guest to notify
the host about panics. Further more, there's no reasonable way to notify the
host of other critical events such as an OOM kill.

This short patch series introduces a new device named virtio-notifier which
does two simple things:

 1. Provide a simple interface for the guest to notify the host of critical
 events. This is easily expandible to add support for any events we may find
 interesting for the host to know about.

 2. Provide an "echo" interface for the host to ping the guest. This allows
 the host to ping the guest at intervals chosen by the host, and act
 accordingly if no response has been received.

Sasha Levin (2):
  virtio: Introduce virtio-notifier
  kvm tools: support virtio-notifier

 drivers/virtio/Kconfig                  |   11 ++
 drivers/virtio/Makefile                 |    1 +
 drivers/virtio/virtio_notifier.c        |  135 ++++++++++++++++++++
 include/linux/virtio_ids.h              |    1 +
 include/linux/virtio_notifier.h         |   15 +++
 tools/kvm/Makefile                      |    1 +
 tools/kvm/builtin-run.c                 |    6 +
 tools/kvm/include/kvm/virtio-notifier.h |    9 ++
 tools/kvm/include/kvm/virtio-pci-dev.h  |    1 +
 tools/kvm/virtio/notifier.c             |  203 +++++++++++++++++++++++++++++++
 10 files changed, 383 insertions(+), 0 deletions(-)
 create mode 100644 drivers/virtio/virtio_notifier.c
 create mode 100644 include/linux/virtio_notifier.h
 create mode 100644 tools/kvm/include/kvm/virtio-notifier.h
 create mode 100644 tools/kvm/virtio/notifier.c

-- 
1.7.8.6

