Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0HaEDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 00:03:07 -0400
Received: from s318.xrea.com ([125.53.25.46]:53921 "HELO s318.xrea.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750720Ab0HaEDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 00:03:05 -0400
From: Naohiro Aota <naota@elisp.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Naohiro Aota <naota@elisp.net>
Subject: Re: [PATCH 2/2] idr: describe how nextidp works in idr_get_next().
References: <m27hj8cdsw.fsf@elisp.net> <m2pqx0az4h.fsf@elisp.net>
	<4C7BD45B.3050300@kernel.org>
Date: Tue, 31 Aug 2010 13:02:57 +0900
In-Reply-To: <4C7BD45B.3050300@kernel.org> (Tejun Heo's message of "Mon, 30
	Aug 2010 17:55:07 +0200")
Message-ID: <m2bp8jbf9q.fsf@elisp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (darwin)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> On 08/30/2010 05:39 PM, Naohiro Aota wrote:
>> It was unclear in original kernel-doc how nextidp worked in
>> idr_get_next(). Let's describe it.
>> 
>> Signed-off-by: Naohiro Aota <naota@elisp.net>
>> ---
>>  lib/idr.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>> 
>> diff --git a/lib/idr.c b/lib/idr.c
>> index fb86a67..cf8c46b 100644
>> --- a/lib/idr.c
>> +++ b/lib/idr.c
>> @@ -589,7 +589,8 @@ EXPORT_SYMBOL(idr_for_each);
>>   * @nextidp:  pointer to lookup key
>>   *
>>   * Returns pointer to registered object with id, which is next number to
>> - * given id.
>> + * given id. The id pointed by nextidp will be updated
>> + * appropriately for next iteration.
>>   */
>
> Maybe "After being looked up, *@nextidp will be updated for the next
> iteration" would be clearer?

Thanks, the fixed patch below.

==
>From 6c61c97b5b85a350e3f195309b70a271457208ca Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naota@elisp.net>
Date: Fri, 27 Aug 2010 17:43:46 +0900
Subject: [PATCH 2/2] idr: describe how nextidp works in idr_get_next().

It was unclear in original kernel-doc how nextidp worked in
idr_get_next(). Let's describe it.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 lib/idr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index fb86a67..5e0966b 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -589,7 +589,8 @@ EXPORT_SYMBOL(idr_for_each);
  * @nextidp:  pointer to lookup key
  *
  * Returns pointer to registered object with id, which is next number to
- * given id.
+ * given id. After being looked up, *@nextidp will be updated for the next
+ * iteration.
  */
 
 void *idr_get_next(struct idr *idp, int *nextidp)
-- 
1.7.2

