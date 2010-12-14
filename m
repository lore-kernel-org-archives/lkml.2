Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab0LNVbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:31:01 -0500
Received: from smtp-out.google.com ([216.239.44.51]:28099 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab0LNVa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:30:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=bLanOvZllgNQkgEmn7D2XzO2JAt5MWbtwPfgmuFMXhOxrDcYWKxU/IhAonPe/Z9x+
	HpeJfm8aL3Sg55MYKBdzg==
Subject: [PATCH v3 17/22] kmsg_dumper: Introduce a new 'SOFT' dump reason
To: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Date: Tue, 14 Dec 2010 13:30:27 -0800
Message-ID: <20101214213026.17022.26883.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a useful to be able to exercise kmsg_dumper implementations without
requiring a kernel oops or panic.  This commit adds a new reason called
KMSG_DUMP_SOFT, which signifies that the system isn't really going down.

This logic is used in a later commit that introduces the netoops driver.

Signed-off-by: Mike Waychison <mikew@google.com>
---
Notes:

It is also possible that we not introduce KMSG_DUMP_SOFT, and simply overload
the existing KMSG_DUMP_OOPS reason, but I figured that this would be cleaner.
---
 include/linux/kmsg_dump.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
index a229acc..0abc2d7 100644
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -20,6 +20,7 @@ enum kmsg_dump_reason {
 	KMSG_DUMP_OOPS,
 	KMSG_DUMP_PANIC,
 	KMSG_DUMP_KEXEC,
+	KMSG_DUMP_SOFT,
 };
 
 /**

