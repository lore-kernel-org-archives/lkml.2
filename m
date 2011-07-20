Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1GTFkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 01:40:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37796 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1GTFkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 01:40:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110712205000.GA2500@redhat.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-22-git-send-email-jim.cromie@gmail.com>
 <1310430335.3550.3.camel@Joe-Laptop> <20110712205000.GA2500@redhat.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 19 Jul 2011 23:39:52 -0600
Message-ID: <CAJfuBxxaL=Xz4vWnuHizGZrEbJyTPGy4aN4ByaWBy42mjo_Ypw@mail.gmail.com>
Subject: Re: [PATCH 21/21] dynamic_debug: delete pending queries
To: Jason Baron <jbaron@redhat.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        bvanassche@acm.org, gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 2:50 PM, Jason Baron <jbaron@redhat.com> wrote:
> On Mon, Jul 11, 2011 at 05:25:35PM -0700, Joe Perches wrote:
>> On Mon, 2011-07-11 at 01:46 -0600, Jim Cromie wrote:
>> > delete pending queries by re-issuing it with disabled flags
>> []
>> > diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
>> []
>> > @@ -505,7 +505,17 @@ static int ddebug_save_pending(struct ddebug_query *query,
>> >
>> >     list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
>> >             if (queries_match(query, &pq->query)) {
>> > -                   /* query already in list, update flags */
>> > +                   /* query already in list */
>> > +                   if (!flags) {
>> > +                           /* zeroed flags, remove query */
>> > +                           if (verbose)
>> > +                                   pr_info("delete pending: %s\n",
>> > +                                           show_pending_query(pq));
>>
>> I think these should be pr_debug.
>> I know you're only using the current style.
>>
>> Jason, any reason these can not be converted?
>>
>
> it should be ok, although we have to be careful not to use them in the
> printing path, since that will cause a recursion.
>
> Also, if there is an issue with the dynamic debug code, it makes it more
> of a pain to debug :)
>
> -Jason
>


I replaced almost all pr_info with pr_debug,
works nicely.

One pr_info remains, cuz code also uses pr_cont(),
which has no corresponding fn

	if (verbose) {
		int i;
		pr_info("split into words: %d ", i);
		for (i = 0 ; i < nwords ; i++)
			pr_cont(" \"%s\"", words[i]);
		pr_cont("\n");
	}

Would you consider adding it ?
If so, I can drop verbose var completely.
