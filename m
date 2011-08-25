Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1HYPPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:15:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60189 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab1HYPPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:15:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/5] TTY: serial, use ASYNCB_CLOSING in uart_close
Date: Thu, 25 Aug 2011 17:15:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, alan@linux.intel.com, linux-serial@vger.kernel.org,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org
References: <4E556CB7.2010102@suse.cz> <1314277928-13388-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1314277928-13388-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108251715.01443.arnd@arndb.de>
X-Provags-ID: V02:K0:NVsXhli/uCdBjs5nOV+eQ+H+ZFfV7I9fJUXLK7Fui0R
 YvkhlT9VTnNAT31nxwsFfFYcGINKyWv7XNs+eszet+g9TJaawZ
 LtpXFHjxBPLpFZujBlTDs+1x/Uhr76ee9OTLka33cYS7XiCMeU
 SKZBzNTUsHHRPbDlvTdYrvwQoppnwPT9kRqBFcC0o/lzfsWXjQ
 x593WwgwrdKtN9EeyjjSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 August 2011, Jiri Slaby wrote:
> 
> We need to move port->mutex locking after wait_until_sent in
> uart_close (for rationale see next patches). But if we did it now, we
> would introduce a race between close and open. This is exactly why
> port->mutex is locked at the top of uart_close.
> 
> To avoid the race, we add ASYNCB_CLOSING to uart_close. Like every
> other sane TTY driver. Thanks to tty_port_block_til_ready used in
> uart_open we will have this for free. Then we can move the port->mutex
> lock.
> 
> Also note that this will make the conversion to tty_port helpers
> easier. They are currently handling ASYNC_CLOSING flag correctly.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

The series looks good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>

The only thing left to note is probably that there are a bunch
of drivers that implement their own *_wait_until_sent function
and call that from their *_close function instead of calling
tty_wait_until_sent. These drivers continue to suffer from the
same stalls that you are fixing the other ones.

	Arnd
