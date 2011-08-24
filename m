Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab1HXLro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:47:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39701 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab1HXLrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:47:41 -0400
Message-ID: <4E54E4D9.6070802@suse.cz>
Date: Wed, 24 Aug 2011 13:47:37 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: gregkh@suse.de, alan@linux.intel.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
References: <13141210141189@kroah.org> <73013289.R6WJLciOm2@wuerfel> <4E54C4ED.3060809@suse.cz> <201108241320.47635.arnd@arndb.de>
In-Reply-To: <201108241320.47635.arnd@arndb.de>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 01:20 PM, Arnd Bergmann wrote:
> It's not clear to me what state->mutex protects in the serial_core, but
> it has been around forever (used to be called state->sem)

It was actually moved in uart_close back in 2003. Formerly (when there
was only a coarse grained port_sem) it was right before uart_shutdown.
But there were some flags to handle some races. I'm not sure whether the
flags protected any race here though.

> and is held in
> all uart functions, which is at least consistent. IIRC what Alan's plan
> for this was, uart_close should eventually get changed to use
> tty_port_close_start or even tty_port_close. Maybe the time for that has
> come now, lacking better alternatives?

Yes, I have such a patch in my queue. But it's not easy to get there.
You may take a look at:
http://decibel.fi.muni.cz/gitweb/?p=linux.git;a=shortlog;h=refs/heads/devel

But it's still far from ready. And yet, in the queue, I still have
port->mutex locked before tty_port_close_start like it is now.

> A lot of other drivers call tty_port_close_start() before taking port->mutex.

Yes, that's true. That's why I wrote that before. But most of the
drivers doesn't have so complex locking dependencies like uart.

thanks,
-- 
js
suse labs
