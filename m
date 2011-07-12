Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab1GLJVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:21:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45024 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab1GLJVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:21:06 -0400
MIME-Version: 1.0
In-Reply-To: <1310370416-6322-14-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-14-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 12 Jul 2011 11:20:45 +0200
X-Google-Sender-Auth: OyAWcw7yGqxMyWRp2IoyojwWoZc
Message-ID: <CAO+b5-pLVD7qKeY0pyt_oA8Ba1URdE-e06hiH+6AFanNChPU0g@mail.gmail.com>
Subject: Re: [PATCH 13/21] dynamic_debug: require 'a' flag to explicitly mark
 pending queries
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 9:46 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> +static int queries_match(struct ddebug_query *q1, struct ddebug_query *q2)
> +{
> +       if (!q1->module ^ !q2->module ||
> +               !q1->filename ^ !q2->filename ||
> +               !q1->function ^ !q2->function ||
> +               !q1->format ^ !q2->format)
> +               return 0;  /* a match-spec set/unset state differs */
> +
> +       if (q1->last_lineno != q2->last_lineno ||
> +               q1->first_lineno != q2->first_lineno)
> +               return 0;
> +
> +       if ((q1->module && strcmp(q1->module, q2->module)) ||
> +               (q1->filename && strcmp(q1->filename, q2->filename)) ||
> +               (q1->function && strcmp(q1->function, q2->function)) ||
> +               (q1->format && strcmp(q1->format, q2->format)))
> +               return 0;
> +       return 1;
> +}

Is there a reason why the return type of this function is "int" and
not "bool" ? Also, in the Linux kernel you can use the symbolic
constants "true" and "false" instead of "1" and "0".

Bart.
