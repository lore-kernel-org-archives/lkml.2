Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab2IFVqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:46:33 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50652 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab2IFVqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <1346966267-1780-1-git-send-email-tmshlvck@gmail.com>
References: <1346966267-1780-1-git-send-email-tmshlvck@gmail.com>
Date: Thu, 6 Sep 2012 23:46:30 +0200
Message-ID: <CAEB7QLBpf2HupqOR9xe2S6cZLk1vnxv7Oqvq4NdRQNaCKjfrNQ@mail.gmail.com>
Subject: Re: [PATCH] tty_register_device_attr updated for tty-next
From: Tomas Hlavacek <tmshlvck@gmail.com>
To: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: marek.vasut@gmail.com, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Thu, Sep 6, 2012 at 11:17 PM, Tomas Hlavacek <tmshlvck@gmail.com> wrote:
> Added tty_device_create_release() and bound to dev->release in
> tty_register_device_attr().
> Added tty_port_register_device_attr() and used in uart_add_one_port()
> instead of tty_register_device_attr().
>
> Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>
> ---
>  drivers/tty/serial/serial_core.c |    8 ++++----
>  drivers/tty/tty_io.c             |    7 +++++++
>  drivers/tty/tty_port.c           |   24 ++++++++++++++++++++++++
>  include/linux/tty.h              |    4 ++++
>  4 files changed, 39 insertions(+), 4 deletions(-)
>

A little bit more explanation regarding this patch: It fixes two
problems with my previous patch (tty: uartclk value from serial_core
exposed to sysfs) which Jiri has pointed out earlier today. Both are
related to the changed interface in the tty-next branch and both
should have been dealt with in the first patch. It also fixes minor
problems (one const keyword added and newlines rearranged in the
uart_get_attr_uartclk() function).

Tomas
