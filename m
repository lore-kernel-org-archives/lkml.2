Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab1GLAZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 20:25:38 -0400
Received: from mail.perches.com ([173.55.12.10]:3893 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1GLAZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 20:25:37 -0400
Subject: Re: [PATCH 21/21] dynamic_debug: delete pending queries
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, bvanassche@acm.org,
        gregkh@suse.de, gnb@fmeh.org
In-Reply-To: <1310370416-6322-22-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
	 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
	 <1310370416-6322-22-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 17:25:35 -0700
Message-ID: <1310430335.3550.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-11 at 01:46 -0600, Jim Cromie wrote:
> delete pending queries by re-issuing it with disabled flags
[]
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
[]
> @@ -505,7 +505,17 @@ static int ddebug_save_pending(struct ddebug_query *query,
>  
>  	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
>  		if (queries_match(query, &pq->query)) {
> -			/* query already in list, update flags */
> +			/* query already in list */
> +			if (!flags) {
> +				/* zeroed flags, remove query */
> +				if (verbose)
> +					pr_info("delete pending: %s\n",
> +						show_pending_query(pq));

I think these should be pr_debug.
I know you're only using the current style.

Jason, any reason these can not be converted?

