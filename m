Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1I0Uhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:37:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55344 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1I0Uhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:37:54 -0400
MIME-Version: 1.0
In-Reply-To: <1316725066.29447.16.camel@Joe-Laptop>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1316642115-20029-26-git-send-email-jim.cromie@gmail.com> <1316725066.29447.16.camel@Joe-Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 27 Sep 2011 14:37:23 -0600
Message-ID: <CAJfuBxxZdNRZAix8ARUjqjNzrQeG2iVea_rMYKysOaX4c=Avig@mail.gmail.com>
Subject: Re: [PATCH 25/26] dynamic_debug: add pr_fmt_dbg() for dynamic_pr_debug
To: Joe Perches <joe@perches.com>
Cc: jbaron@redhat.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 2:57 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2011-09-21 at 15:55 -0600, jim.cromie@gmail.com wrote:
>> dynamic_pr_debug can add module, function, file, and line selectively,
> []
>> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> []
>> +#ifndef pr_fmt_dbg
>> +#define pr_fmt_dbg(fmt) fmt
>> +#endif
> []
>> +#ifndef pr_fmt_dbg
>> +#define pr_fmt_dbg(fmt) pr_fmt(fmt)
>> +#endif
>
> This might better be placed in printk.h just
> once.
>

yes.  it seems to work smoothly.
Only minor annoyance is having to put local defns
above the #includes, but thats no different than previously.


> I think pr_fmt_debug is better than pr_fmt_dbg
> because the function/macro is named pr_debug.

Ok.  Done.

> Maybe add all the pr_<level> variants too because
> some like to prefix __func__ to pr_err but not pr_info
> etc.
>

Done. Only wrinkle is wrt pr_warning() vs pr_warn()
I added to your suggestion:
+#define pr_fmt_warn pr_fmt_warning

the imperfection is that user has 4 combos of warn/warning
rather than 2 pairs, but the latter seems less defensible.

revised patch forthcoming shortly
seems I havent mastered reply-to with git send-email :-}
