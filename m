Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1HNQT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:19:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab1HNQT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:19:26 -0400
Date: Sun, 14 Aug 2011 18:15:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, bonbons@linux-vserver.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        serge@hallyn.com
Subject: Re: [PATCH 1/2] add SA_CLDREBOOT flag
Message-ID: <20110814161532.GA30846@redhat.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <1313094241-3674-2-git-send-email-daniel.lezcano@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313094241-3674-2-git-send-email-daniel.lezcano@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Daniel Lezcano wrote:
>
> Add the SA_CLDREBOOT flag to enable the CLD_REBOOT on SIGCHLD
> when a process of a child pid namespace calls the reboot syscall.

I doubt this is really useful in general. SIGCHLD doesn't queue,
if the parent of init already has the pending SIGCHLD it won't see
CLD_REBOOTED anyway. Anyway, you do not need a special helper to
fill siginfo.

And personally I strongly dislike SA_CLDREBOOT. For what? Imho, this
is unnecessary complication. If we want SIGCHLD-on-reboot, just send
it unconditionally.

Oleg.

