Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab2GISZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:25:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47838 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2GISZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:25:33 -0400
MIME-Version: 1.0
In-Reply-To: <1341785361.13174.25.camel@joe2Laptop>
References: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
	<1341784614-2797-10-git-send-email-dh.herrmann@googlemail.com>
	<1341785361.13174.25.camel@joe2Laptop>
Date: Mon, 9 Jul 2012 20:25:30 +0200
Message-ID: <CANq1E4QHuAtAQ5F9i99JVquy1Ae9rA1ovKXhD4Upnm2sOF+bLg@mail.gmail.com>
Subject: Re: [PATCH v2 09/11] fblog: register console driver
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

On Mon, Jul 9, 2012 at 12:09 AM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2012-07-08 at 23:56 +0200, David Herrmann wrote:
>> We want to print the kernel log to all FBs so we need a console driver.
>> This registers the driver on startup and writes all messages to all
>> registered fblog instances.
>
> Hi David.  Trivia only:
>
>> diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
> []
>> @@ -47,6 +71,107 @@ static struct fblog_fb *fblog_fbs[FB_MAX];
>>  static bool active = 1;
>>
>>  #define to_fblog_dev(_d) container_of(_d, struct fblog_fb, dev)
>> +#define FBLOG_STR(x) x, sizeof(x) - 1
>
> That's a rather ugly macro.

But handy ;) I've removed it and replaced the call below with a local
variable which works fine too and seems to be even shorter than with
this macro.

>> +static void fblog_buf_resize(struct fblog_buf *buf, size_t width,
>> +                          size_t height)
>> +{
>> +     u16 **lines = NULL;
>> +     size_t i, j, minw, minh;
>> +
>> +     if (buf->height == height && buf->width == width)
>> +             return;
>> +
>> +     if (width && height) {
>> +             lines = kzalloc(height * sizeof(char*), GFP_KERNEL);
>
> sizeof(char *) is a bit more kernel style like.

Thanks, both fixed.
David
