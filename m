Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab2DYMQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:16:44 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:52480 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab2DYMQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:16:43 -0400
MIME-Version: 1.0
In-Reply-To: <1335289787-11089-2-git-send-email-john.stultz@linaro.org>
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org>
	<1335289787-11089-2-git-send-email-john.stultz@linaro.org>
Date: Wed, 25 Apr 2012 14:16:43 +0200
Message-ID: <CAO6Zf6Bn7dHoXj=MN2dG8JynvxoAYjNZq3NqC3tWzO115T6uhA@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

range_tree_in_range_adjacent() is not used in your code, and it
doesn't seem to be very useful in general case. range_tree_in_range()
can do the same thing (and you use it that way in the 2nd patch) and
is more flexible (can be paired with range_tree_next_in_range()). So I
think it can be dropped altogether.

Now, I'm wondering whether it actually makes sense to make a dedicated
interface out of the remaining bits.

Almost everything is common rb_tree-handling code that can be found in
any place where rb-trees are used (hard-coded for flexibility,
performance or whatever other reasons). So my feeling is that it
should not be different here.

-- Dmitry
