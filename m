Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1HUQBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 12:01:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab1HUQBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 12:01:02 -0400
Date: Sun, 21 Aug 2011 17:57:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: bookjovi@gmail.com
Cc: dhowells@redhat.com, nhorman@tuxdriver.com, roland@redhat.com,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
Message-ID: <20110821155756.GA316@redhat.com>
References: <1313925904-5935-1-git-send-email-bookjovi@gmail.com> <20110821152545.GA30955@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110821152545.GA30955@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Oleg Nesterov wrote:
>
> On 08/21, bookjovi@gmail.com wrote:
> >
> > For non-pipe case, limit 0 also means drop the coredump, so just put
> > the zero limit check at do_coredump function begining.
>
> Neil, what do you think? Should we change the code or the comment?

Personally I think we should fix the comment. I think RLIMIT_CORE
doesn't apply in this case, limit == 1 check is very special. And
this is what linux always did, except between 725eae32 and 898b374a.


Oleg.

