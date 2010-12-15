Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0LOAHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:07:44 -0500
Received: from smtp-out.google.com ([216.239.44.51]:54291 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0LOAHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:07:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=B/A7NVExfdMh1e7DKSb16qHsMTR0GkeWl3g2LP7BWBRClHl1bGt0ZQwajCO9IaNAAa
         Ojbh/AcWJQFqDXVV9hmg==
MIME-Version: 1.0
In-Reply-To: <20101214213010.17022.54049.stgit@mike.mtv.corp.google.com>
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com> <20101214213010.17022.54049.stgit@mike.mtv.corp.google.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 14 Dec 2010 16:07:20 -0800
Message-ID: <AANLkTimxv8kO5vQfL-dEhCgkU7YX+qYUWONqyt1uj45y@mail.gmail.com>
Subject: Re: [PATCH v3 14/22] netpoll: Move target code into netpoll_targets.c
To: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>
Cc: adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh.  I just realized that I was missing a MODULE_LICENSE("GPL"); for
this new module, otherwise module load fails to find the link for
cancel_work_sync.

---
netpoll: Add missing module license for netpoll_targets

Add a missing module license declaration to netpoll_targets that allows
it to use exported symbols (cancel_work_sync).

Signed-off-by: Mike Waychison <mikew@google.com>

diff --git a/net/core/netpoll_targets.c b/net/core/netpoll_targets.c
index 5fc84f8c..0887268 100644
--- a/net/core/netpoll_targets.c
+++ b/net/core/netpoll_targets.c
@@ -747,3 +747,4 @@ void unregister_netpoll_targets(struct netpoll_targets *nts)
 }
 EXPORT_SYMBOL_GPL(unregister_netpoll_targets);

+MODULE_LICENSE("GPL");
