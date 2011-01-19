Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1ASW3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:29:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754749Ab1ASW3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:29:44 -0500
Date: Wed, 19 Jan 2011 14:29:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Re: [patch 2/2] fix compiler warning and optimize the non-blocking
 path
Message-Id: <20110119142942.e4898861.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1101151137590.6884@davide-lnx1>
References: <alpine.DEB.2.00.1101151137590.6884@davide-lnx1>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Jan 2011 11:43:45 -0800 (PST)
Davide Libenzi <davidel@xmailserver.org> wrote:

> +/**
> + * ep_poll - Retrieves ready events, and delivers them to the caller supplied
> + *           event buffer.
> + *
> + * @ep: Pointer to the eventpoll context.
> + * @events: Pointer to the userspace buffer where the ready events should be
> + *          stored.
> + * @maxevents: Size (in terms of number of events) of the caller event buffer.
> + * @timeout: Maximum timeout for the ready events fetch operation, in
> + *           milliseconds. If the @timeout is zero, the function will not block,
> + *           while if the @timeout is less than zero, the function will block
> + *           until at least one event has been retrieved (or an error
> + *           occurred).

Ah, that's what timeout<0 means.

My `man epoll_wait' says "a timeout of -1 makes epoll_wait() wait
indefinitely", whereas the implementation accepts any -ve value.

So we lost the ability to later make -[2..MAX_INT] meaningful in some
new way.  Oh well.

> + * Returns: Returns the number of ready events which have been fetched, or an
> + *          error code, in case of error.
> + */
