Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1FKXoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 19:44:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43430 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1FKXoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 19:44:21 -0400
Date: Sun, 12 Jun 2011 00:44:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: minipli@googlemail.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc, exec: remove redundant addr_limit assignment
Message-ID: <20110611234415.GE11521@ZenIV.linux.org.uk>
References: <1307642718-22257-1-git-send-email-minipli@googlemail.com>
 <20110609155630.0f734351.akpm@linux-foundation.org>
 <1307711453-17412-1-git-send-email-minipli@googlemail.com>
 <20110611.160842.2135350880385482648.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110611.160842.2135350880385482648.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 04:08:42PM -0700, David Miller wrote:
> From: Mathias Krause <minipli@googlemail.com>
> Date: Fri, 10 Jun 2011 15:10:53 +0200
> 
> > The address limit is already set in flush_old_exec() so this
> > assignment of USER_DS is redundant.
> > 
> > Signed-off-by: Mathias Krause <minipli@googlemail.com>
>  ...
> > @@ -368,9 +368,6 @@ void flush_thread(void)
> >  
> >  	/* Clear FPU register state. */
> >  	t->fpsaved[0] = 0;
> > -	
> > -	if (get_thread_current_ds() != ASI_AIUS)
> > -		set_fs(USER_DS);
> >  }
> 
> Yeah but now you're doing it unconditionally, the guard is here
> because the %asi register write which set_fs() does is extremely
> expensive on sparc64 and %99.99999 of the time we can avoid it.

OTOH, get_thread_current_ds() is cheap and moving that into set_fs()
itself wouldn't be particulary bad idea...
