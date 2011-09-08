Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab1IHAF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:05:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab1IHAF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:05:27 -0400
Date: Wed, 7 Sep 2011 20:04:29 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Nelson Elhage <nelhage@nelhage.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        stable@kernel.org
Subject: Re: [PATCH] epoll: Fix spurious lockdep warnings
Message-ID: <20110908000429.GK10700@zod.bos.redhat.com>
References: <1312913515-432-1-git-send-email-nelhage@nelhage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312913515-432-1-git-send-email-nelhage@nelhage.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 02:11:55PM -0400, Nelson Elhage wrote:
> epoll can acquire recursively acquire ep->mtx on multiple "struct
> eventpoll"s at once in the case where one epoll fd is monitoring
> another epoll fd. This is perfectly OK, since we're careful about the
> lock ordering, but it causes spurious lockdep warnings. Annotate the
> recursion using mutex_lock_nested, and add a comment explaining the
> nesting rules for good measure.
> 
> Recent versions of systemd are triggering this, and it can also be
> demonstrated with the following trivial test program:
> 
> --------------------8<--------------------
> 
> int main(void) {
>    int e1, e2;
>    struct epoll_event evt = {
>        .events = EPOLLIN
>    };
> 
>    e1 = epoll_create1(0);
>    e2 = epoll_create1(0);
>    epoll_ctl(e1, EPOLL_CTL_ADD, e2, &evt);
>    return 0;
> }
> --------------------8<--------------------
> 
> Cc: stable@kernel.org
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Tested-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Nelson Elhage <nelhage@nelhage.com>

Any progress on this heading upstream?

josh
