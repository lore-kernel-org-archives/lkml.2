Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2HAAvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 20:51:44 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38152 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2HAAvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 20:51:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120622180423.24c0001b@pyramind.ukuu.org.uk>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
	<20120622154438.1405.43658.stgit@localhost.localdomain>
	<20120622153657.GB6081@kroah.com>
	<20120622180423.24c0001b@pyramind.ukuu.org.uk>
Date: Tue, 31 Jul 2012 17:51:42 -0700
X-Google-Sender-Auth: EumNOTS1oX84uGAgyF8q-4b_3Kg
Message-ID: <CAE9FiQX7HjcitKU7OWRS5m_r9YCBSPLBj6e3+d87fAYnwjDq=A@mail.gmail.com>
Subject: Re: [PATCH 09/12] commit 22126843cb3c2a782c2d52614486115f3e9db478
From: Yinghai Lu <yinghai@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 10:04 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 22 Jun 2012 08:36:57 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
>
>> On Fri, Jun 22, 2012 at 04:44:59PM +0100, Alan Cox wrote:
>> > From: Alan Cox <alan@linux.intel.com>
>> >
>> > tty: move the termios object into the tty
>> >
>> >     This will let us sort out a whole pile of tty related races. The
>> >     alternative would be to keep points and refcount the termios objects.
>> >     However
>> >     1. They are tiny anyway
>> >     2. Many devices don't use the stored copies
>> >     3. We can remove a pty special case
>> >
>> >     Signed-off-by: Alan Cox <alan@linux.intel.com>
>>
>> Odd subject line, and formatting, did something go wrong with your
>> scripts?
>
> Apparently so. I will given them a stern talking to and repost

looks the one in tty-next still missed some changes...

commit adc8d746caa67fff4b53ba3e5163a6cbacc3b523
Author: Alan Cox <alan@linux.intel.com>
Date:   Sat Jul 14 15:31:47 2012 +0100

    tty: move the termios object into the tty

    This will let us sort out a whole pile of tty related races. The
    alternative would be to keep points and refcount the termios objects.
    However
    1. They are tiny anyway
    2. Many devices don't use the stored copies
    3. We can remove a pty special case

    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

...

still need

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index b9cca6d..9a56428 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -165,8 +165,8 @@ static int usb_console_setup(struct console *co,
char *options)
                }

                if (serial->type->set_termios) {
-                       tty->termios->c_cflag = cflag;
-                       tty_termios_encode_baud_rate(tty->termios, baud, baud);
+                       tty->termios.c_cflag = cflag;
+                       tty_termios_encode_baud_rate(&tty->termios, baud, baud);
                        memset(&dummy, 0, sizeof(struct ktermios));
                        serial->type->set_termios(tty, port, &dummy);
