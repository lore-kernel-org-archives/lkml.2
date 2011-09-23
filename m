Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1IWKbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:31:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43060 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab1IWKbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <1316725066.29447.16.camel@Joe-Laptop>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1316642115-20029-26-git-send-email-jim.cromie@gmail.com> <1316725066.29447.16.camel@Joe-Laptop>
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 23 Sep 2011 12:31:22 +0200
X-Google-Sender-Auth: Jh4A7w_wOul_Xc0eVctB5t69cbM
Message-ID: <CAO+b5-qTB2YW4rpS-sGqgXhFWeaEYrM4k87RonmdAz-2t6asCg@mail.gmail.com>
Subject: Re: [PATCH 25/26] dynamic_debug: add pr_fmt_dbg() for dynamic_pr_debug
To: Joe Perches <joe@perches.com>
Cc: jim.cromie@gmail.com, jbaron@redhat.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 10:57 PM, Joe Perches <joe@perches.com> wrote:
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
> I think pr_fmt_debug is better than pr_fmt_dbg
> because the function/macro is named pr_debug.
>
> Maybe add all the pr_<level> variants too because
> some like to prefix __func__ to pr_err but not pr_info
> etc.
>
> #ifndef pr_fmt_emerg
> #define pr_fmt_emerg(fmt) pr_fmt(fmt)
> #endif
> #ifndef pr_fmt_crit
> #define pr_fmt_crit(fmt) pr_fmt(fmt)
> #endif
> #ifndef pr_fmt_alert
> #define pr_fmt_alert(fmt) pr_fmt(fmt)
> #endif
> #ifndef pr_fmt_err
> #define pr_fmt_err(fmt) pr_fmt(fmt)
> #endif
> #ifndef pr_fmt_notice
> #define pr_fmt_notice(fmt) pr_fmt(fmt)
> #endif
> #ifndef pr_fmt_warn
> #define pr_fmt_warn(fmt) pr_fmt(fmt)
> #endif
> #ifndef pr_fmt_info
> #define pr_fmt_info(fmt) pr_fmt(fmt)
> #endif
> #ifndef pr_fmt_debug
> #define pr_fmt_debug(fmt) pr_fmt(fmt)
> #endif

Hi Joe,

Are you sure it makes sense to introduce all these new macros ?
Introducing pr_fmt_dbg() makes sense to me, but the usefulness of the
macros proposed above is not clear to me.

Bart.
