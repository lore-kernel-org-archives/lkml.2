Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab2KSF3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:29:33 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49968 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab2KSF3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:30 -0500
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 14/58] x86: Mark EVT_TO_HPET_DEV static
Date: Sun, 18 Nov 2012 21:27:53 -0800
Message-Id: <1353302917-13995-15-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of arch/x86/kernel/hpet.c references this function, so
mark it static.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 1460a5d..2dd92ae 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -52,7 +52,7 @@ struct hpet_dev {
 	char				name[10];
 };
 
-inline struct hpet_dev *EVT_TO_HPET_DEV(struct clock_event_device *evtdev)
+static inline struct hpet_dev *EVT_TO_HPET_DEV(struct clock_event_device *evtdev)
 {
 	return container_of(evtdev, struct hpet_dev, evt);
 }
-- 
1.7.10.4

