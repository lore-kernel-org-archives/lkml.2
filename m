Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2DZKAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:00:33 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:54085 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2DZKAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:00:31 -0400
MIME-Version: 1.0
In-Reply-To: <4F982424.9000603@linaro.org>
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org>
	<1335289787-11089-2-git-send-email-john.stultz@linaro.org>
	<CAO6Zf6Bn7dHoXj=MN2dG8JynvxoAYjNZq3NqC3tWzO115T6uhA@mail.gmail.com>
	<4F982424.9000603@linaro.org>
Date: Thu, 26 Apr 2012 12:00:31 +0200
Message-ID: <CAO6Zf6CsQTHAVP14xi_sOr0iik_rKWeuqT4R_04X6xamEh4c_w@mail.gmail.com>
Subject: Re: [PATCH 1/3] Range tree implementation
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> [ ... ]
>>
>> Almost everything is common rb_tree-handling code that can be found in
>> any place where rb-trees are used (hard-coded for flexibility,
>> performance or whatever other reasons). So my feeling is that it
>> should not be different here.
>>
> Sorry, not sure I quite understand what you're suggesting. Are you saying it
> doesn't make sense to have a generic range tree implementation, since really
> its just a small shim over the rbtree code?  So instead range-tree users
> should just implment them themselves?

Exactly. It's not much different from other rbtree
search-insert-delete implementations out there.

What are the generic use cases that we want to support with this interface?

Is the current notion of the 'overlapping range' as taken by
range_tree_in_range() common enough? What if another use-case requires
_only_ the ranges that are strictly inside the [ start, end ] range?
In this case, we might be better off sticking to the same
'implement-your-own-search' approach taken by the generic rbtree
interface.

-- Dmitry
