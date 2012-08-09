Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2HINf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:35:56 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:50234 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2HINfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:35:54 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com F1F9E8210C
Date: Thu, 9 Aug 2012 15:35:44 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Michel Lespinasse <walken@google.com>,
        John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] [RFC] Add volatile range management code
Message-ID: <20120809133544.GA2086@thinkpad>
References: <1343447832-7182-1-git-send-email-john.stultz@linaro.org>
 <1343447832-7182-2-git-send-email-john.stultz@linaro.org>
 <CANN689HWYO5DD_p7yY39ethcFu_JO9hudMcDHd=K8FUfhpHZOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689HWYO5DD_p7yY39ethcFu_JO9hudMcDHd=K8FUfhpHZOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 02:46:37AM -0700, Michel Lespinasse wrote:
> On Fri, Jul 27, 2012 at 8:57 PM, John Stultz <john.stultz@linaro.org> wrote:
> > v5:
> > * Drop intervaltree for prio_tree usage per Michel &
> >   Dmitry's suggestions.
> 
> Actually, I believe the ranges you need to track are non-overlapping, correct ?
> 
> If that is the case, a simple rbtree, sorted by start-of-range
> address, would work best.
> (I am trying to remove prio_tree users... :)
> 

John,

JFYI, if you want to try a possible rbtree-based implementation, as
suggested by Michel you could try this one:
https://github.com/arighi/kinterval

This implementation supports insertion, deletion and transparent merging
of adjacent ranges, as well as splitting ranges when chunks removed or
different chunk types are added in the middle of an existing range; so
if I'm not wrong probably you should be able to use this code as is,
without any modification.

If you decide to go this way and/or need help to use it in your patch
set just let me know.

-Andrea
