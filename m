Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010Ab1GOGl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:41:56 -0400
Received: from mail.perches.com ([173.55.12.10]:4008 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964778Ab1GOGlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:41:55 -0400
Subject: Re: [PATCH 11/11] dynamic_debug: use a single printk() to emit msgs
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
	 <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 23:41:53 -0700
Message-ID: <1310712113.7582.24.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 12:09 -0400, Jason Baron wrote:
> We were using KERN_CONT to combine msgs with their prefix.
[]
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c

Perhaps instead:

> +static int dynamic_emit_prefix(const struct _ddebug *descriptor, char *buf)

static char *dynamic_emit_prefix(...)
[]

	snprintf(buf, PREFIX_SIZE, KERN_DEBUG"%s%s%s%s%s%s",

Add a space please after KERN_DEBUG

[]
	return buf;

>  int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
[]
> +	res = dynamic_emit_prefix(descriptor, buf);
> +	res += printk("%s %pV", buf, &vaf);

This double counts the length of dynamic_emit_prefix.
I think this and the others should be:

	res = printk("%s %pV", dynamic_emit_prefix(descriptor, buf), &vaf);
 

