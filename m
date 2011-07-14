Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1GNMSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 08:18:35 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52975 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab1GNMSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 08:18:34 -0400
Message-ID: <4E1EDE96.8070700@gmail.com>
Date: Thu, 14 Jul 2011 14:18:30 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@suse.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 2/2] TTY: remove tty_locked
References: <201107122325.35013.arnd@arndb.de> <1310553086-27427-1-git-send-email-jslaby@suse.cz> <1310553086-27427-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <1310553086-27427-2-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.2pre
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2011 12:31 PM, Jiri Slaby wrote:
> --- a/drivers/tty/tty_mutex.c
> +++ b/drivers/tty/tty_mutex.c
...
> @@ -25,10 +23,7 @@ void __lockfunc tty_lock(void)
>  {
>  	struct task_struct *task = current;

Hmm I overlooked it generates a warning:
drivers/tty/tty_mutex.c: In function ‘tty_lock’:
drivers/tty/tty_mutex.c:24:22: warning: unused variable ‘task’
drivers/tty/tty_mutex.c: In function ‘tty_unlock’:
drivers/tty/tty_mutex.c:32:22: warning: unused variable ‘task’

> -	WARN_ON(__big_tty_mutex_owner == task);
> -
>  	mutex_lock(&big_tty_mutex);
> -	__big_tty_mutex_owner = task;
>  }

I will send whole series as v2 since it is confusing enough.

thanks,
-- 
js
