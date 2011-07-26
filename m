Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1GZCYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 22:24:03 -0400
Received: from mail.perches.com ([173.55.12.10]:4268 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab1GZCX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 22:23:59 -0400
Subject: Re: [PATCH 24/25] dynamic_debug: drop pr_fmt() from
 dynamic_pr_debug
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
In-Reply-To: <1311630170-26057-25-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
	 <1311630170-26057-25-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 19:23:57 -0700
Message-ID: <1311647037.24377.7.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 15:42 -0600, Jim Cromie wrote:
> dynamic_pr_debug can add module, function, file, and line selectively,
> theres no need to also add them via macro.  Moreover, adding them
> via the macro, which is useful for pr_info and friends, causes
> pr_debug to double-print those fields added by the flag-settings.
[]
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
[]
> @@ -65,7 +65,7 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
>  #define dynamic_pr_debug(fmt, ...) do {					\
>  	DYNAMIC_DEBUG_METADATA(fmt);					\
>  	if (unlikely(descriptor.enabled))				\
> -		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__);\
> +		__dynamic_pr_debug(&descriptor, fmt, ##__VA_ARGS__);	\

For me, NAK.

I think this isn't a good idea for now.
Maybe in a year or two after all the #define pr_fmt(foo)
are sorted out better.

This is a #define, that is used by all uses of pr_fmt/pr_debug.

This will have problems with uses of pr_fmt that are not
using KBUILD_MODNAME like all uses of:

#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt

and those that use a specific fixed  string like:

#define pr_fmt(fmt) "foo: " fmt


