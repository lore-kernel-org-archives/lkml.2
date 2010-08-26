Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0HZWb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 18:31:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754449Ab0HZWb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 18:31:58 -0400
Date: Thu, 26 Aug 2010 15:31:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH] hrtimer: make epoll_wait() use the hrtimer range
 feature
Message-Id: <20100826153156.9ca92942.akpm@linux-foundation.org>
In-Reply-To: <1281307532-3235-1-git-send-email-shawn.bohrer@gmail.com>
References: <1281307532-3235-1-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'd say this is an epoll patch, not an hrtimer patch.  So I renamed it
to "epoll: make epoll_wait() use the hrtimer range feature".

Davide looks after epoll, so let's cc him.

On Sun,  8 Aug 2010 17:45:32 -0500
Shawn Bohrer <shawn.bohrer@gmail.com> wrote:

> This make epoll use hrtimers for the timeout value which prevents
> epoll_wait() from timing out up to a millisecond early.
> 
> This mirrors the behavior of select() and poll().
> 
> ...
>
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c

Davide stuff ;)

> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -67,7 +67,7 @@ static long __estimate_accuracy(struct timespec *tv)
>  	return slack;
>  }
>  
> -static long estimate_accuracy(struct timespec *tv)
> +long estimate_accuracy(struct timespec *tv)

"estimate_accuracy" is a rotten name for a global symbol.  I queued a
preparatory patch which renames this to "select_estimate_accuracy".

