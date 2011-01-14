Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab1ANJd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:33:29 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52737 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606Ab1ANJdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:33:20 -0500
X-Sasl-enc: /Uv4iQDbwVp+gdzZ1JX8ZcP5pzc+KtglTSi1T7HPK0tL 1294997600
X-User-Agent: K-9 Mail for Android
References: <1294989352-2003-1-git-send-email-viresh.kumar@st.com>
In-Reply-To: <1294989352-2003-1-git-send-email-viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] fs/eventpoll.c: fix compilation warning
From: Jack Stone <jwjstone@fastmail.fm>
Date: Fri, 14 Jan 2011 09:33:16 +0000
To: Viresh Kumar <viresh.kumar@st.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Message-ID: <2426ea8f-7e52-4329-bf20-884c2b996f98@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Viresh Kumar" <viresh.kumar@st.com> wrote:

>This patch fixes following compilation warning
>fs/eventpoll.c:1119: warning: 'slack' may be used uninitialized in this
>function
>
>Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>---
> fs/eventpoll.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>index 8cf0724..c24a032 100644
>--- a/fs/eventpoll.c
>+++ b/fs/eventpoll.c
>@@ -1116,7 +1116,7 @@ static int ep_poll(struct eventpoll *ep, struct
>epoll_event __user *events,
> {
> 	int res, eavail, timed_out = 0;
> 	unsigned long flags;
>-	long slack;
>+	long slack = 0;
> 	wait_queue_t wait;
> 	struct timespec end_time;
> 	ktime_t expires, *to = NULL;

I don't think this is the correct fix. This function is fine unless timeout is negative.

If a negative timeout is possible then this function will create timer far in the future. I'll leave it up to the maintainer how to solve that one. The two solutions I can see are making timeout unsigned or extending the bottom case of the if to <=0.

Either way we should use uninitalized_var() rather than setting it to zero.

Hope this makes sense,

Jack

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
