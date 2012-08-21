Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2HUNYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:24:55 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40695 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2HUNYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:24:52 -0400
MIME-Version: 1.0
In-Reply-To: <1345401285-14473-1-git-send-email-tmshlvck@gmail.com>
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
	<1345401285-14473-1-git-send-email-tmshlvck@gmail.com>
Date: Tue, 21 Aug 2012 15:24:51 +0200
Message-ID: <CAEB7QLDBjUp9GswRB20KdFNVLJme3WeX2Xd79-ovP6SWxVORpA@mail.gmail.com>
Subject: Re: [PATCHv4 1/1] [RFC] uartclk from serial_core exposed to sysfs
From: Tomas Hlavacek <tmshlvck@gmail.com>
To: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: marek.vasut@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Sun, Aug 19, 2012 at 8:34 PM, Tomas Hlavacek <tmshlvck@gmail.com> wrote:
> Added file /sys/devices/.../tty/ttySX/uartclk to allow reading
> uartclk value in struct uart_port in serial_core via sysfs.
>
> It simplifies initialization verification of no-name cards that
> have non-standard oscillator speed while having no distinguishing
> PCI IDs to allow autodetection.
>
> tty_register_device() has been generalized and refactored in order
> to add support for setting drvdata and attribute_group to the device.
>

I have updated the patch to a new v4 in order to remove the race in
sysfs file creation and add sysfs file description to a Documentation
directory. But still the patch creates the sysfs file separately for
each serial TTY device by assigning attribute_groups to the struct
device and not for the whole driver at once as Greg advised because I
was unable to figure out how to do that (even though I tried pretty
hard). Does it make sense like this? Or do you have any hint for a
better way to do it, please?

Thanks,
Tomas
