Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab1EYDNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:13:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43565 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab1EYDNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:13:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDC73D8.5050900@jp.fujitsu.com>
Date: Wed, 25 May 2011 12:13:28 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com
Subject: [PATCH 3/3] swap-token: add a comment for priority aging
References: <4DD480DD.2040307@jp.fujitsu.com>	<4DD481A7.3050108@jp.fujitsu.com> <20110520123004.e81c932e.akpm@linux-foundation.org> <4DDB1388.2080102@jp.fujitsu.com>
In-Reply-To: <4DDB1388.2080102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add to a few comment of design decision of swap token aging.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/thrash.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/mm/thrash.c b/mm/thrash.c
index 0504e8a..8832edb 100644
--- a/mm/thrash.c
+++ b/mm/thrash.c
@@ -50,6 +50,17 @@ void grab_swap_token(struct mm_struct *mm)
 	if (!swap_token_mm)
 		goto replace_token;

+	/*
+	 * Usually, we don't need priority aging because long interval faults
+	 * makes priority decrease quickly. But there is one exception. If the
+	 * token owner task is sleeping, it never make long interval faults.
+	 * Thus, we need a priority aging mechanism instead. The requirements
+	 * of priority aging are
+	 *  1) An aging interval is reasonable enough long. Too short aging
+	 *     interval makes quick swap token lost and decrease performance.
+	 *  2) The swap token owner task have to get priority aging even if
+	 *     it's under sleep.
+	 */
 	if ((global_faults - last_aging) > TOKEN_AGING_INTERVAL) {
 		swap_token_mm->token_priority /= 2;
 		last_aging = global_faults;
-- 
1.7.3.1



