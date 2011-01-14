Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab1ANJTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:19:11 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54038 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046Ab1ANJTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:19:06 -0500
X-Sasl-enc: IJVb4vmpmcdQsXqqO/H177LxGFKumJiJSaT+hZgQEiIi 1294996745
X-User-Agent: K-9 Mail for Android
References: <1294989246-1621-1-git-send-email-viresh.kumar@st.com>
In-Reply-To: <1294989246-1621-1-git-send-email-viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] kernel/async.c: fixing compilation warnings
From: Jack Stone <jwjstone@fastmail.fm>
Date: Fri, 14 Jan 2011 09:18:56 +0000
To: Viresh Kumar <viresh.kumar@st.com>, linux-kernel@vger.kernel.org
Message-ID: <7f454c6e-eeb9-4de0-acfe-6ced96ecdad0@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Viresh Kumar" <viresh.kumar@st.com> wrote:

>This patch fixes following compilation warnings:
>270:10: warning: ‘starttime.tv64’ may be used uninitialized in this
>function
>122:10: warning: ‘calltime.tv64’ may be used uninitialized in this
>function
>
>Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>---
> kernel/async.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/kernel/async.c b/kernel/async.c
>index cd9dbb9..9c06931 100644
>--- a/kernel/async.c
>+++ b/kernel/async.c
>@@ -119,7 +119,7 @@ static void async_run_entry_fn(struct work_struct
>*work)
> 	struct async_entry *entry =
> 		container_of(work, struct async_entry, work);
> 	unsigned long flags;
>-	ktime_t calltime, delta, rettime;
>+	ktime_t calltime = {0}, delta, rettime;

I think this is a false positive so we can use uninitalized_var().

> 	/* 1) move self to the running queue */
> 	spin_lock_irqsave(&async_lock, flags);
>@@ -267,7 +267,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
> void async_synchronize_cookie_domain(async_cookie_t cookie,
> 				     struct list_head *running)
> {
>-	ktime_t starttime, delta, endtime;
>+	ktime_t starttime = {0}, delta, endtime;
> 

Same for this one.

> 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
> 		printk("async_waiting @ %i\n", task_pid_nr(current));

Thanks,

Jack


-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
