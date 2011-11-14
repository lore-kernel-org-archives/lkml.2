Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab1KNXrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:47:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab1KNXqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:46:23 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mst@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        penberg@kernel.org, mingo@elte.hu,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 3/5] iomap: Don't ignore offset
Date: Tue, 15 Nov 2011 01:43:15 +0200
Message-Id: <1321314197-5265-4-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1
In-Reply-To: <1321314197-5265-1-git-send-email-levinsasha928@gmail.com>
References: <20111114181854.GA24953@redhat.com>
 <1321314197-5265-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Offset was ignored for start calulcations, making all mappings start at
offset 0 always.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 lib/iomap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/iomap.c b/lib/iomap.c
index f28720e..93ae915 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -272,6 +272,7 @@ void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
 	if (len <= offset || !start)
 		return NULL;
         len -= offset;
+	start += offset;
         if (len < minlen)
 		return NULL;
 	if (maxlen && len > maxlen)
-- 
1.7.8.rc1

