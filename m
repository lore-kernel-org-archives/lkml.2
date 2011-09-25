Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1IYM7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 08:59:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60818 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1IYM7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 08:59:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=aKIG7wupdW+HZ9Ic2m4iIYxjomwK+gY5pUsw5rZgK3SDZY6pIOlnPp3gSET5X0kGC
	ROVpluwJSZwIDqLSXom8A==
MIME-Version: 1.0
In-Reply-To: <1316818998-30711-3-git-send-email-sjg@chromium.org>
References: <1316818998-30711-1-git-send-email-sjg@chromium.org> <1316818998-30711-3-git-send-email-sjg@chromium.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sun, 25 Sep 2011 06:59:27 -0600
Message-ID: <CAErSpo6PFPLRAfPd_myJXrGdYofOR82YXy6U4YZEfp-bfXhQuA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] bootstage: Insert bootstage_mark to record timing
 for bootup.
To: Simon Glass <sjg@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Da Zheng <zhengda@chromium.org>, Da Zheng <zhengda@chromium.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 5:03 PM, Simon Glass <sjg@chromium.org> wrote:
> From: Da Zheng <zhengda@chromium.org>
>
> From: Da Zheng <zhengda@chromium.org>
>
> This inserts calls to bootstage_mark() to timestamp the kernel moving
> between the different initcall levels.
>
> Signed-off-by: Da Zheng <zhengda@chromium.com>
> ---
>  init/bootstage.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  init/main.c      |    7 +++++++
>  2 files changed, 56 insertions(+), 0 deletions(-)
>
> diff --git a/init/bootstage.c b/init/bootstage.c
> index 79e9761..6f4668f 100644
> --- a/init/bootstage.c
> +++ b/init/bootstage.c
> @@ -226,3 +226,52 @@ static int __init bootstage_init(void)
>  }
>
>  postcore_initcall(bootstage_init);
> +
> +static int __init post_core_initcall(void)
> +{
> +       bootstage_mark("core_initcall");
> +       return 0;
> +}
> +core_initcall_sync(post_core_initcall);

I'm sure you considered just instrumenting do_one_initcall() rather
than adding these individual initcall marks?  That would get you a lot
more timestamps (maybe too many), and would help identify individual
drivers, which I suspect will be common offenders.

Bjorn
