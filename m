Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1HVQW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:22:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab1HVQWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:22:24 -0400
Date: Mon, 22 Aug 2011 18:19:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, bookjovi@gmail.com,
        dhowells@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
Message-ID: <20110822161914.GA9399@redhat.com>
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com> <4E527684.3020206@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E527684.3020206@draigBrady.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Pádraig Brady wrote:
>
> On 08/21/2011 11:36 PM, Neil Horman wrote:
> > Concur.  The comment should be changed
> > Neil
> >
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> >> On 08/21, Oleg Nesterov wrote:
> >>>
> >>> On 08/21, bookjovi@gmail.com wrote:
> >>>>
> >>>> For non-pipe case, limit 0 also means drop the coredump, so just put
> >>>> the zero limit check at do_coredump function begining.
> >>>
> >>> Neil, what do you think? Should we change the code or the comment?
> >>
> >> Personally I think we should fix the comment. I think RLIMIT_CORE
> >> doesn't apply in this case, limit == 1 check is very special. And
> >> this is what linux always did, except between 725eae32 and 898b374a.
>
> Sorry for jumping in late here.
> I would really like `ulimit -c 0` to completely disable core dumps,
> including not running core_pattern, as I also mentioned here:
> https://bugs.launchpad.net/ubuntu/+source/apport/+bug/62511
> I noticed this in a script where ctrl-\ was taking a long
> time to be registered as the core_pattern was run unconditionally.

May be. As I said, I do not really know and personally I agree with
everything. My only point was, this is not the bug, this is what we
always did.

This is up to Neil, I think.

Oleg.

