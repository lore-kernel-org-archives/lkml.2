Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0FSEpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 00:45:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47066 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0FSEpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 00:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XKuas90nJ6faxdsaV3bg09PDyQXxvGTzwQ4N97ZAyfyW1gO0wqY/lvDiidD6gHDoQB
         LjCegCM+6zkt3zUrM+mCZOtER8Uy4npGfuwfI785aOofIlQe8s7r8Aw1QdZRg3umh4Iw
         1GehyuYM503TeuTrVi9Gpv1PbZ0n9Oq5p+aGU=
Message-ID: <4C1C4B55.8070209@gmail.com>
Date: Fri, 18 Jun 2010 21:45:09 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       zippel@linux-m68k.org, linux-fsdevel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 2/6]kernel:audit.c Fix warning: variable 'nlh' set but
 not 	used
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>	<1276288869-16815-3-git-send-email-justinmattock@gmail.com> <AANLkTildzUcfd6GghHbO53ebPAc4m4BahJrXUr8B7SQF@mail.gmail.com>
In-Reply-To: <AANLkTildzUcfd6GghHbO53ebPAc4m4BahJrXUr8B7SQF@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> This is not dead code. NLMSG_NEW() sets up an nlmsg in ab->skb.
> If you remove the code, it's no longer initialized.

I played around with this code some more, but am still getting confused 
with nlmsg_new and NLMSG_NEW. if I remove the nlmsghdr struct I can get 
a clean build without a warning, but still am a bit confused.

here is an updated patch let me know if it still needs work..
or if it's legit I can resend this.

 From 7515a08ba921d3beed33fa5c6b1fbe59cf52e069 Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Fri, 18 Jun 2010 19:44:30 -0700
Subject: [PATCH 4/4] audit
  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
  kernel/audit.c |    3 +--
  1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index c71bd26..1d51258 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1041,7 +1041,6 @@ static struct audit_buffer * 
audit_buffer_alloc(struct audit_context *ctx,
  {
  	unsigned long flags;
  	struct audit_buffer *ab = NULL;
-	struct nlmsghdr *nlh;

  	spin_lock_irqsave(&audit_freelist_lock, flags);
  	if (!list_empty(&audit_freelist)) {
@@ -1065,7 +1064,7 @@ static struct audit_buffer * 
audit_buffer_alloc(struct audit_context *ctx,
  	if (!ab->skb)
  		goto nlmsg_failure;

-	nlh = NLMSG_NEW(ab->skb, 0, 0, type, 0, 0);
+	NLMSG_NEW(ab->skb, 0, 0, type, 0, 0);

  	return ab;

-- 
1.7.1.rc1.21.gf3bd6

Justin P. Mattock
