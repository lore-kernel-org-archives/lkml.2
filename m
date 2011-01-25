Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1AYOXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:23:11 -0500
Received: from mail.perches.com ([173.55.12.10]:3326 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab1AYOXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:23:10 -0500
Subject: Re: [PATCH] get_maintainer.pl: Add support to match arbitrary text
From: Joe Perches <joe@perches.com>
To: "L. Alberto" =?ISO-8859-1?Q?Gim=E9nez?= <agimenez@sysvalve.es>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Mickler <florian@mickler.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>
In-Reply-To: <1295911951-12615-1-git-send-email-agimenez@sysvalve.es>
References: <1295911951-12615-1-git-send-email-agimenez@sysvalve.es>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 06:23:09 -0800
Message-ID: <1295965389.15568.25.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 00:32 +0100, L. Alberto Giménez wrote:
> Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cf0f3a5..c1e33ac 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6145,6 +6145,7 @@ TRIVIAL PATCHES
>  M:	Jiri Kosina <trivial@kernel.org>
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
>  S:	Maintained
> +K:	^Subject:.*\[(?i)trivial\].*

The trailing .* isn't necessary.

This matches just case insensitive "[trivial]".

Looking at the trivial patches posted:
https://patchwork.kernel.org/project/LKML/list/?q=trivial
that's not a very good matching pattern.

Maybe this is better:

K:	^(?i:subject):.*(?i:trivial)\s*[:,\]]


