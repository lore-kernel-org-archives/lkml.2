Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0CWK7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:59:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab0CWK7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:59:08 -0400
Date: Tue, 23 Mar 2010 11:57:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/3] proc: make task_sig() lockless
Message-ID: <20100323105707.GA8634@redhat.com>
References: <20100322184136.GA3967@redhat.com> <15829.1269333449@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15829.1269333449@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > task_sig() doesn't need ->siglock.
>
> Except that the data returned might then be inconsistent because you don't
> hold a lock as you read the various bits of it.

Yes. From the changelog:

	Of course, this means we read pending/blocked/etc nonatomically,
	but I hope this is OK for fs/proc.

But I don't think the returned data could be "really" inconsistent
from the /bin/ps pov. Yes, it is possible that, say, some signal is
seen as both pending and ignored without ->siglock. Or we can report
user->sigpending != 0 while pending/shpending are empty.

But this looks harmless to me. We never guaranteed /proc/pid/status
can't report the "intermediate" state, and I don't think we can
confuse the user-space.

Do you agree? Or do you think this can make problems ?

Oleg.

