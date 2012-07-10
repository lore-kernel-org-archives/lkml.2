Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2GJK6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:58:08 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53636 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2GJK6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:58:06 -0400
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/8] Dmabuf synchronization
Date: Tue, 10 Jul 2012 12:57:43 +0200
Message-Id: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements my attempt at dmabuf synchronization.
The core idea is that a lot of devices will have their own
methods of synchronization, but more complicated devices
allow some way of fencing, so why not export those as
dma-buf?

This patchset implements dmabufmgr, which is based on ttm's code.
The ttm code deals with a lot more than just reservation however, 
I took out almost all the code not dealing with reservations.

I used the drm-intel-next-queued tree as base. It contains some i915
flushing changes. I would rather use linux-next, but the deferred
fput code makes my system unbootable. That is unfortunate since
it would reduce the deadlocks happening in dma_buf_put when 2
devices release each other's dmabuf.

The i915 changes implement a simple cpu wait only, the nouveau code
imports the sync dmabuf read-only and maps it to affected channels,
then performs a wait on it in hardware. Since the hardware may still
be processing other commands, it could be the case that no hardware
wait would have to be performed at all.

Only the nouveau nv84 code is tested, but the nvc0 code should work
as well.

