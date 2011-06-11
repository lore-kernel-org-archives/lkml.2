Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1FKXIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 19:08:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55051 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1FKXIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 19:08:47 -0400
Date: Sat, 11 Jun 2011 16:08:42 -0700 (PDT)
Message-Id: <20110611.160842.2135350880385482648.davem@davemloft.net>
To: minipli@googlemail.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc, exec: remove redundant addr_limit assignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <1307711453-17412-1-git-send-email-minipli@googlemail.com>
References: <1307642718-22257-1-git-send-email-minipli@googlemail.com>
	<20110609155630.0f734351.akpm@linux-foundation.org>
	<1307711453-17412-1-git-send-email-minipli@googlemail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 11 Jun 2011 16:08:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>
Date: Fri, 10 Jun 2011 15:10:53 +0200

> The address limit is already set in flush_old_exec() so this
> assignment of USER_DS is redundant.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
 ...
> @@ -368,9 +368,6 @@ void flush_thread(void)
>  
>  	/* Clear FPU register state. */
>  	t->fpsaved[0] = 0;
> -	
> -	if (get_thread_current_ds() != ASI_AIUS)
> -		set_fs(USER_DS);
>  }

Yeah but now you're doing it unconditionally, the guard is here
because the %asi register write which set_fs() does is extremely
expensive on sparc64 and %99.99999 of the time we can avoid it.
