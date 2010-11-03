Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0KCBbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 21:31:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:35852 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab0KCBaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 21:30:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=SkiHg7m03qRUVlq+w41fz6gGOvjM2SQMIzUBa9AWRdKdR6yj3FKoedftaa7dbAVvx
	HqvCNCa8IqD0Zv4Wu62Fw==
Subject: [PATCH v1 12/12] netoops: Allow the driver to be built as a module
To: simon.kagstrom@netinsight.net, davem@davemloft.net
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, akpm@linux-foundation.org, chavey@google.com,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Date: Tue, 02 Nov 2010 18:30:37 -0700
Message-ID: <20101103013036.4641.84407.stgit@crlf.mtv.corp.google.com>
In-Reply-To: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the netoops driver is completely decoupled from the rest of the
kernel, it can be compiled as a module.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/net/Kconfig   |    2 +-
 drivers/net/netoops.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 4dc53d4..c50411b 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3321,7 +3321,7 @@ config NETCONSOLE_DYNAMIC
 	  See <file:Documentation/networking/netconsole.txt> for details.
 
 config NETOOPS
-	bool "Network oops support"
+	tristate "Network oops support"
 	depends on PROC_FS
 	help
 	  This option enables the ability to have the kernel logs emitted on
diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
index 87b2122..3c6d592 100644
--- a/drivers/net/netoops.c
+++ b/drivers/net/netoops.c
@@ -688,3 +688,5 @@ static void __exit netoops_exit(void)
 
 module_init(netoops_init);
 module_exit(netoops_exit);
+
+MODULE_LICENSE("GPL");

