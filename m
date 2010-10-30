Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0J3O2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:28:03 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40880 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab0J3O0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UzU4fNOAycC47fYqh5dIcGVqCedxRRcoov162VVES06EpE+6gNHyiQNfyKbJb5hf73
         LLHQLQY2w9qQqU2+wsY1adCf/iONG0tTwueFs6y6tzLh5gspyp1O2qVYFHUdkAF+1INf
         ykKtvspSLhBJZPGfcOHAjjjgbfTQPynjFDhdI=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bluetooth: cmtp: fix information leak to userland
Date: Sat, 30 Oct 2010 18:26:26 +0400
Message-Id: <1288448787-5848-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure cmtp_conninfo is copied to userland with some padding fields
unitialized.  It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 net/bluetooth/cmtp/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
index ec0a134..8e5f292 100644
--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -78,6 +78,7 @@ static void __cmtp_unlink_session(struct cmtp_session *session)
 
 static void __cmtp_copy_session(struct cmtp_session *session, struct cmtp_conninfo *ci)
 {
+	memset(ci, 0, sizeof(*ci));
 	bacpy(&ci->bdaddr, &session->bdaddr);
 
 	ci->flags = session->flags;
-- 
1.7.0.4

