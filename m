Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2GIRzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:55:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47992 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2GIRzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:55:08 -0400
MIME-Version: 1.0
In-Reply-To: <1341785628.13174.28.camel@joe2Laptop>
References: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
	<1341784614-2797-6-git-send-email-dh.herrmann@googlemail.com>
	<1341785628.13174.28.camel@joe2Laptop>
Date: Mon, 9 Jul 2012 19:55:07 +0200
Message-ID: <CANq1E4TPk_Lu_+=npR2QHeY5HkKssga5sUcBskoQAeWa0odhqQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] fblog: register one fblog object per framebuffer
From: David Herrmann <dh.herrmann@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        florianschandinat@gmx.de, linux-fbdev@vger.kernel.org,
        gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk,
        bonbons@linux-vserver.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe

On Mon, Jul 9, 2012 at 12:13 AM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2012-07-08 at 23:56 +0200, David Herrmann wrote:
>>
>
> Hi David.  Trivial comments only:
>
>> diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
> []
>> @@ -23,15 +23,204 @@
>>   * all fblog instances before running other graphics applications.
>>   */
>
> Please add
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> before any #include and...

Thanks, I've added it.

>>  static int __init fblog_init(void)
>>  {
>> +     int ret;
>> +
>> +     ret = fb_register_client(&fblog_notifier);
>> +     if (ret) {
>> +             pr_err("fblog: cannot register framebuffer notifier");
>
> Missing newline, pr_fmt would add module name.
>
>                 pr_err("cannot register framebuffer notifier\n");

Fixed, too. Thanks!
David
