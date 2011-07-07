Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1GGSOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:14:43 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45661 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1GGSOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:14:42 -0400
MIME-Version: 1.0
In-Reply-To: <151c1f3fc402d2f19f95e44de07cdc04917f7278.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
References: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com> <151c1f3fc402d2f19f95e44de07cdc04917f7278.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 7 Jul 2011 20:14:22 +0200
X-Google-Sender-Auth: BcU9GJdWOuMpJPW-oFSwqN1w5Fk
Message-ID: <CAO+b5-pxk_5+gvR6N8_vW5zMTn1RZW0ghBRGZiMVGqWOoXYTiA@mail.gmail.com>
Subject: Re: [PATCH 02/10] dynamic_debug: Consolidate prefix output to single routine
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 7:24 PM, Jason Baron <jbaron@redhat.com> wrote:
>
> From: Joe Perches <joe@perches.com>
>
> Adding dynamic_dev_dbg duplicated prefix output.
> Consolidate that output to a single routine.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  lib/dynamic_debug.c |   38 ++++++++++++++++++--------------------
>  1 files changed, 18 insertions(+), 20 deletions(-)
>
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 5c5f8f9..758e922 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -428,15 +428,10 @@ static int ddebug_exec_query(char *query_string)
>        return 0;
>  }
>
> -int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
> +static int dynamic_emit_prefix(const struct _ddebug *descriptor)
>  {

How about renaming dynamic_emit_prefix() into ddebug_emit_prefix() ?
Personally I prefer the latter name over the former.

Bart.
