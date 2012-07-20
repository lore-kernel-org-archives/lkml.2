Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab2GTIU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 04:20:59 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43806 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2GTIU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:20:56 -0400
MIME-Version: 1.0
X-Originating-IP: [202.62.83.106]
In-Reply-To: <87hat35bq0.fsf@octavius.laptop.org>
References: <CANYdXnrf-f2e=3YKpwweSmvrYdmy7z_yOEyZ11k=La=8b3W6Pw@mail.gmail.com>
	<87hat35bq0.fsf@octavius.laptop.org>
Date: Fri, 20 Jul 2012 13:50:55 +0530
Message-ID: <CANYdXnrQfqhZZaXxPDxkee_RY052CcfEWfNK4vRhM5a6WwuhGw@mail.gmail.com>
Subject: Re: A question on printascii
From: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
To: Chris Ball <cjb@laptop.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks a lot Chris. Will try it out.

On Fri, Jul 20, 2012 at 9:24 AM, Chris Ball <cjb@laptop.org> wrote:
> Hi Shashidhar,
>
> On Wed, Jul 18 2012, Shashidhar Hiremath wrote:
>>   I want to use printascii to debug my serial driver. How do I enable
>> it and use the feature.
>>   Currently I have enabled in menuconfig and done an extern on the
>> printascii api, this doesn't seem to work, So any hints for debugging
>> serial drivers ?
>
> Sounds like you want this patch, against linux-next:
>
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 3991862..36abce8 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -45,6 +45,8 @@
>
>  #include <asm/uaccess.h>
>
> +extern void printascii(char *);
> +
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/printk.h>
>
> @@ -1542,6 +1544,8 @@ asmlinkage int vprintk_emit(int facility, int level,
>          */
>         text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
>
> +       printascii(text);
> +
>         /* mark and strip a trailing newline */
>         if (text_len && text[text_len-1] == '\n') {
>                 text_len--;
>
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child



-- 
regards,
Shashidhar Hiremath
