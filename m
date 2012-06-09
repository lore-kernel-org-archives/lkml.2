Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab2FIO6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 10:58:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35433 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2FIO6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 10:58:48 -0400
Message-ID: <4FD364A3.9090104@suse.cz>
Date: Sat, 09 Jun 2012 16:58:43 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120530 Thunderbird/14.0a2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 24/24] TTY: use tty_port_register_device
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz> <1338809738-18967-25-git-send-email-jslaby@suse.cz> <20120604180027.66a29823@pyramind.ukuu.org.uk>
In-Reply-To: <20120604180027.66a29823@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 07:00 PM, Alan Cox wrote:
>> In this patch we modify most of the drivers to do the latter. When the
>> drivers use tty_register_device and we have tty_port already, we
>> switch to tty_port_register_device. So we have the tty_struct =>
>> tty_port link for free for those.
> 
> Nice solution

Seems so on the first glance... But it is racy. There is a window since
tty_register_driver to tty_(port_)register_device where a node may be
opened already, but tty_port won't be set up yet.

The fix is to move cdev_add from tty_register_driver to
tty_register_device, which makes sense anyway. Any objections?

For the time being, Greg, please ignore 24/24 from these series (I see
you haven't applied any of the patches yet.)

thanks,
-- 
js
suse labs


