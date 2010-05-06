Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0EFSvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:51:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32977 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab0EFSvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:51:13 -0400
Subject: Re: [PATCH] epoll: use wrapper functions
From: Peter Zijlstra <peterz@infradead.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Changli Gao <xiaosuo@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Takashi Iwai <tiwai@suse.de>, David Howells <dhowells@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1005061140100.2642@makko.or.mcafeemobile.com>
References: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com>
	 <alpine.DEB.2.00.1005061140100.2642@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 20:51:03 +0200
Message-ID: <1273171863.1642.258.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 11:47 -0700, Davide Libenzi wrote:
> Since we already have __add_wait_queue(), __add_wait_queue_tail() and 
> __remove_wait_queue() (which all means "locked"), and while I agree in 
> having the exclusive-add wrapped into a function, I much better prefer a:
> 
> static inline void __add_wait_queue_excl(wait_queue_head_t *head, 
>                                          wait_queue_t *new)
> {
>         new->flags |= WQ_FLAG_EXCLUSIVE;
>         __add_wait_queue(head, new);
> }
> 
> The patch you posted introduces a different naming, which leaves all the 
> other __*() untouched, and wraps the already one-liner __remove_wait_queue() 
> with yet another one-liner. 

I concur, I always get confused by the _locked postfix (and its more
typing). Also, it goes against the lock data not code paradigm.

