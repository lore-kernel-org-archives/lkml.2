Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0DSSR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:17:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135Ab0DSSR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:17:27 -0400
Date: Mon, 19 Apr 2010 11:14:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, tilman@imap.cc,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: tip: origin tree build failure, [patch] fix isdn/gigaset build
 failure
In-Reply-To: <20100419180520.GA9244@elte.hu>
Message-ID: <alpine.LFD.2.00.1004191112550.14500@i5.linux-foundation.org>
References: <20100419.003857.260094283.davem@davemloft.net> <20100419172731.GA4358@elte.hu> <20100419.103304.35342954.davem@davemloft.net> <20100419180520.GA9244@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Apr 2010, Ingo Molnar wrote:
> 
> Note, i just found that my patch is not enough as we fail the build elsewhere as well:

Maybe add the #include <linux/sched.h> into gigaset.h, instead of 
common.c?

IOW..

		Linus
---
 drivers/isdn/gigaset/gigaset.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/gigaset/gigaset.h b/drivers/isdn/gigaset/gigaset.h
index d32efb6..05947f9 100644
--- a/drivers/isdn/gigaset/gigaset.h
+++ b/drivers/isdn/gigaset/gigaset.h
@@ -20,6 +20,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
