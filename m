Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0FYKKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 06:10:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab0FYKKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 06:10:09 -0400
Date: Fri, 25 Jun 2010 12:08:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chris Friesen <chris.friesen@genband.com>, paulmck@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100625100809.GB6292@redhat.com>
References: <20100618223354.GL2365@linux.vnet.ibm.com> <20100621170919.GA13826@redhat.com> <20100621205128.GI2354@linux.vnet.ibm.com> <20100622212357.GA19670@redhat.com> <20100622221226.GP2290@linux.vnet.ibm.com> <20100623152421.GA8445@redhat.com> <20100624180726.GK2373@linux.vnet.ibm.com> <4C23A90A.9040303@genband.com> <20100624220007.GB21360@redhat.com> <m1sk4c7z4l.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sk4c7z4l.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> If what we are looking for is a stable list_head that won't disappear
> on us we should be able to put one in sighand_struct or signal_struct
> (I forget which is which at the moment) and have a list_head that
> lives for the life of the longest living thread, and that won't get
> messed up by things like de_thread, and then next_thread could simply
> return NULL when we hit the end of the list.

This was already discussed.

Yes, we can add list_head into signal_struct. But this breaks, say,
thread_group_empty() and the similar code. This is fixeable.

But. We need to convert the code which does while_each_thread(g, t) to
use list_for_each(t, head). And, if g != group_leader this can't work.

Not to mention the increase of sizeof(signal_struct).

Oleg.

