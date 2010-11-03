Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0KCBaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 21:30:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34423 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab0KCBaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 21:30:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=czfSyWnISYq+U+g416lUgneTJPGfygTwzOy8y4ROVNZ/i5K7ZQFfKkaVbJm4MB3I3
	/lLTZrK3hCPgooW+UlGpA==
Subject: [PATCH v1 03/12] kmsg_dumper: Introduce a new 'SOFT' dump reason
To: simon.kagstrom@netinsight.net, davem@davemloft.net
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, akpm@linux-foundation.org, chavey@google.com,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Date: Tue, 02 Nov 2010 18:29:43 -0700
Message-ID: <20101103012942.4641.6432.stgit@crlf.mtv.corp.google.com>
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

It is a useful to be able to exercise kmsg_dumper implementations without
requiring a kernel oops or panic.  This commit adds a new reason called
KMSG_DUMP_SOFT, which signifies that the system isn't really going down.

This logic is used in a later commit that introduces the netoops driver.

Signed-off-by: Mike Waychison <mikew@google.com>
---

It is also possible that we not introduce KMSG_DUMP_SOFT, and simply overload
the existing KMSG_DUMP_OOPS reason, but I figured that this would be cleaner.

TODO: Make sure mtdoops and ramoops do something useful with this flag?
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

