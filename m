Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504Ab2EPH1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:27:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65469 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223Ab2EPH1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:27:20 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-1e-4fb356d28e92
From: Jingoo Han <jg1.han@samsung.com>
To: "'Joe Perches'" <joe@perches.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001f01cd3321$ff4260d0$fdc72270$%han@samsung.com>
 <1337146157.26509.9.camel@joe2Laptop>
In-reply-to: <1337146157.26509.9.camel@joe2Laptop>
Subject: RE: [PATCH v2 1/7] backlight: use pr_warn instead of printk
Date: Wed, 16 May 2012 16:27:14 +0900
Message-id: <003001cd3335$50cc4520$f264cf60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0zJNii00ox9uczT8CUUsYHdQ78pwAD8F7A
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012 14:29:00 +0900
Joe Perches <joe@perches.com> wrote:

> 
> On Wed, 2012-05-16 at 14:08 +0900, Jingoo Han wrote:
> > This patch uses pr_warn instead of printk to allow dynamic debugging.
> 
> A slight mistake in the commit message.
> pr_debug not pr_warn.
> 
> > diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> > index bf5b1ec..f7ce212 100644
> > --- a/drivers/video/backlight/backlight.c
> > +++ b/drivers/video/backlight/backlight.c
> > @@ -5,6 +5,8 @@
> >   *
> >   */
> >
> > +#define pr_fmt(fmt) "backlight: " fmt
> 
> I'd prefer:
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Hi, Joe Perches.

Thank you for your comment.
I will fix the commit message and pr_fmt.

Best regards,
Jingoo Han

> 
> > diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
> > index 1c298d5..e61db49 100644
> > --- a/drivers/video/backlight/lcd.c
> > +++ b/drivers/video/backlight/lcd.c
> > @@ -5,6 +5,8 @@
> >   *
> >   */
> >
> > +#define pr_fmt(fmt) "lcd: " fmt
> 
> KBUILD_MODNAME here too


