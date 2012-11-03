Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab2KCWEV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:04:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48038 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab2KCWCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:02:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 6/9] =?UTF-8?q?virtio=5Fmmio:=20Cast=20&resources[1].start=20?= =?UTF-8?q?to=20=E2=80=98unsigned=20int=20*=E2=80=99=20to=20rid=20compiler=20?= =?UTF-8?q?warning?=
Date: Sat,  3 Nov 2012 23:02:27 +0100
Message-Id: <1351980150-24145-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/virtio/virtio_mmio.c: In function ‘vm_cmdline_set’:
drivers/virtio/virtio_mmio.c:535:4: warning: format ‘%u’ expects argument of type ‘unsigned int *’, but argument 4 has type ‘resource_size_t *’ [-Wformat]

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/virtio/virtio_mmio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 6b1b7e1..077e9ca 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -531,7 +531,7 @@ static int vm_cmdline_set(const char *device,
 	resources[0].end = memparse(device, &str) - 1;
 
 	processed = sscanf(str, "@%lli:%u%n:%d%n",
-			&base, &resources[1].start, &consumed,
+			&base, (unsigned int *)&resources[1].start, &consumed,
 			&vm_cmdline_id, &consumed);
 
 	if (processed < 2 || processed > 3 || str[consumed])
-- 
1.7.9.5

