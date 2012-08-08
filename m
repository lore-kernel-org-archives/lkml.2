Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224Ab2HHULy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:11:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54450 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759060Ab2HHULw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:11:52 -0400
Message-ID: <5022C804.2070104@suse.cz>
Date: Wed, 08 Aug 2012 22:11:48 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120731 Thunderbird/15.0
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH 18/41] TTY: pty, switch to tty_alloc_driver
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz> <1344368886-24033-19-git-send-email-jslaby@suse.cz> <20120808163757.28a28df1@bob.linux.org.uk>
In-Reply-To: <20120808163757.28a28df1@bob.linux.org.uk>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 05:37 PM, Alan Cox wrote:
> On Tue,  7 Aug 2012 21:47:43 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> Switch to the new driver allocation interface, as this is one of the
>> special call-sites. Here, we need TTY_DRIVER_EXCESSIVE_LINES to not
>> allocate tty_driver->ports, cdevs and potentially other structures
>> because we reserve too many lines in pty. Instead, it provides the
>> tty_port<->tty_struct link in tty->ops->install already.
> 
> This is the only thing I would quibble about in the entire patch set.
> 
> We've got a pile of things that the pty does and one or two other
> drivers might want to do about dynamic allocation (termios objects is
> the same problem).
> 
> I think it's a mistake to call it EXCESSIVE_LINES, better a name which
> indicates what it implies - say TTY_DRIVER_DYNAMIC_ALLOC. Then it means
> other drivers can move that way if they wish.

I would stick only to the rename at this moment -- I will send a v2 for
this and 19/41. The merge with DEVPTS_MEM (the termios case) needs
devpts_kill_index to be moved from tty_release to
pty_driver->ops->cleanup/shutdown, but I don't feel comfortable to do it
now since it needs some testing. So I would add this to TODO and will
send it after the next merge window. If I understood your point correctly?

> for the entire series, and next time we are both at the same conference
> I owe you a a couple of beers at least !

Heh, OK, it would be honor for me ;).

thanks,
-- 
js
suse labs
