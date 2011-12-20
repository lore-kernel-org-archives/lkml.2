Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab1LTIIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 03:08:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49750 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1LTIIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 03:08:43 -0500
MIME-Version: 1.0
In-Reply-To: <d817e288df0d43d36fde84353cda07772fe3b960.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
	<d817e288df0d43d36fde84353cda07772fe3b960.1324318997.git.jbaron@redhat.com>
Date: Tue, 20 Dec 2011 08:08:41 +0000
X-Google-Sender-Auth: y3gR_O3wnGixj4VUx1wBbFVy1Do
Message-ID: <CAO+b5-p6WY5fKpaPMumFBTO-9mdjxEO8e+WD-kPLPu9C8-H79g@mail.gmail.com>
Subject: Re: [PATCH 05/16] dynamic_debug: replace strcpy with strlcpy, in ddebug_setup_query()
From: Bart Van Assche <bvanassche@acm.org>
To: Jason Baron <jbaron@redhat.com>
Cc: greg@kroah.com, jim.cromie@gmail.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 10:12 PM, Jason Baron <jbaron@redhat.com> wrote:
>
> From: Jim Cromie <jim.cromie@gmail.com>
>
> Replace strcpy with strlcpy, and add define for the size constant.
>
> [jbaron@redhat.com: Use DDEBUG_STRING_SIZE for overflow check]
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  lib/dynamic_debug.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 8c88b89..6fc8622 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -525,14 +525,16 @@ EXPORT_SYMBOL(__dynamic_netdev_dbg);
>
>  #endif
>
> -static __initdata char ddebug_setup_string[1024];
> +#define DDEBUG_STRING_SIZE 1024
> +static __initdata char ddebug_setup_string[DDEBUG_STRING_SIZE];
> +
>  static __init int ddebug_setup_query(char *str)
>  {
> -       if (strlen(str) >= 1024) {
> +       if (strlen(str) >= DDEBUG_STRING_SIZE) {
>                pr_warn("ddebug boot param string too large\n");
>                return 0;
>        }
> -       strcpy(ddebug_setup_string, str);
> +       strlcpy(ddebug_setup_string, str, DDEBUG_STRING_SIZE);
>        return 1;
>  }

Sorry, but it's not clear to me why it make sense to introduce the
DDEBUG_STRING_SIZE macro instead of using ARRAY_SIZE().

Bart.
