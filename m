Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1CFKhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 05:37:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50568 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1CFKhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 05:37:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrey Vagin <avagin@openvz.org>
Subject: Re: [PATCH] mm: skip zombie in OOM-killer
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1299286307-4386-1-git-send-email-avagin@openvz.org>
References: <1299286307-4386-1-git-send-email-avagin@openvz.org>
Message-Id: <20110306193519.49DD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  6 Mar 2011 19:37:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When we check that task has flag TIF_MEMDIE, we forgot check that
> it has mm. A task may be zombie and a parent may wait a memor.
> 
> v2: Check that task doesn't have mm one time and skip it immediately
> 
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

This seems incorrect. Do you have a reprodusable testcasae?
Your patch only care thread group leader state, but current code
care all thread in the process. Please look at oom_badness() and 
find_lock_task_mm(). 



