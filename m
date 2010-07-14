Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0GNL2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:28:08 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37638 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab0GNL2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:28:06 -0400
Date: Wed, 14 Jul 2010 13:29:19 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH RESEND] tools/usb: Add Makefile
In-reply-to: <1279014642.18280.2.camel@cowboy>
To: dbrownell@users.sourceforge.net, Davidlohr Bueso <dave.bueso@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <op.vftzi5ku7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <1279014642.18280.2.camel@cowboy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You should Cc it to linux-usb@vger.kernel.org as well.

On Tue, 13 Jul 2010 11:50:42 +0200, Davidlohr Bueso <dave.bueso@gmail.com> wrote:
> Hi,
>
> This patch adds a Makefile for building 'testusb'.
>
> I am wondering if it should really still use usbdevfs (deprecated),
> instead of usbfs?

Patches welcome... ;)  Personally I dunno, I just took David's code
and changes it a bit.

> Thanks,
> Davidlohr
>
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

I'd say the above is not acceptable as a commit message.  Please
include only the text that is intended to go to the commit message
above.  All additional comments may go under the “---” marker.

> ---
>  tools/usb/Makefile |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>  create mode 100644 tools/usb/Makefile
>
> diff --git a/tools/usb/Makefile b/tools/usb/Makefile
> new file mode 100644
> index 0000000..45b5cab
> --- /dev/null
> +++ b/tools/usb/Makefile
> @@ -0,0 +1,14 @@
> +# Makefile for building 'usbtest'
> +
> +CC = $(CROSS_COMPILE)gcc
> +PTHREAD_LIBS = -lpthread
> +WARNINGS = -Wall
> +WARNINGS := $(WARNINGS) -Wextra

Is it necessary?  Wouldn't plain

WARNINGS = -Wall -Wextra

suffice?  I am aware “=” can be overridden by command line and
“:=” cannot but I'd use single line anyway.

> +CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS)
> +
> +all:
> +	$(CC) $(CFLAGS) -o testusb testusb.c

IMO, you should also include a rule for ffs-test, ie:

+all: testusb ffs-test
+
+%: %.c
+	$(CC) $(CFLAGS) -o $@ $^

Not tested.

> +
> +clean:
> +	$(RM) testusb

Instead:

> +	$(RM) testusb ffs-test

> +

Unnecessary empty line at EOF.

Other then that, I see no reason why not to include it.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
