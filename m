Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab0EUPy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:54:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab0EUPy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:54:26 -0400
Date: Fri, 21 May 2010 17:51:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/2] misc: don't use sig->count
Message-ID: <20100521155152.GA14694@redhat.com>
References: <20100323144836.GA10420@redhat.com> <22494.1274436496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22494.1274436496@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > According to grep, get_nr_threads() becomes the only user of sig->count.
>
> Are these two patches going upstream in this window?

We should ask Andrew.

But personally I'd like to see them in 2.6.35. These changes allows
us to do more cleanups/improvements.

As for sizeof(int) added to signal_struct. I still hope we can kill
this "int nr_threads" later. Even if not, with these changes we can
move, say, ->group_leader from task_struct to signal_struct and kill
signal->leader_pid.

Oleg.

