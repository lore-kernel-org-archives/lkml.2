Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab0JAOZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:25:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab0JAOZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:25:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1285929315-2856-1-git-send-email-steve@digidescorp.com>
References: <1285929315-2856-1-git-send-email-steve@digidescorp.com>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: dhowells@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH][RESEND] nommu: add anonymous page memcg accounting
Date: Fri, 01 Oct 2010 15:24:55 +0100
Message-ID: <5206.1285943095@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Steven J. Magnani <steve@digidescorp.com> wrote:

> Add the necessary calls to track VM anonymous page usage.

Do we really need to do memcg accounting in NOMMU mode?  Might it be better to
just apply the attached patch instead?

David
---
diff --git a/init/Kconfig b/init/Kconfig
index 2de5b1c..aecff10 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -555,7 +555,7 @@ config RESOURCE_COUNTERS
 
 config CGROUP_MEM_RES_CTLR
 	bool "Memory Resource Controller for Control Groups"
-	depends on CGROUPS && RESOURCE_COUNTERS
+	depends on CGROUPS && RESOURCE_COUNTERS && MMU
 	select MM_OWNER
 	help
 	  Provides a memory resource controller that manages both anonymous
