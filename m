Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2DYQUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:20:03 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35461 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab2DYQUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:20:00 -0400
Message-ID: <4F982424.9000603@linaro.org>
Date: Wed, 25 Apr 2012 09:19:48 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] Range tree implementation
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org> <1335289787-11089-2-git-send-email-john.stultz@linaro.org> <CAO6Zf6Bn7dHoXj=MN2dG8JynvxoAYjNZq3NqC3tWzO115T6uhA@mail.gmail.com>
In-Reply-To: <CAO6Zf6Bn7dHoXj=MN2dG8JynvxoAYjNZq3NqC3tWzO115T6uhA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042516-5806-0000-0000-00001499DC17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 05:16 AM, Dmitry Adamushko wrote:
> Hi John,
>
> range_tree_in_range_adjacent() is not used in your code, and it
> doesn't seem to be very useful in general case. range_tree_in_range()
> can do the same thing (and you use it that way in the 2nd patch) and
> is more flexible (can be paired with range_tree_next_in_range()). So I
> think it can be dropped altogether.

Agreed. I actually at one point meant to do this and forgot. Thanks for 
pointing it out!

> Now, I'm wondering whether it actually makes sense to make a dedicated
> interface out of the remaining bits.
>
> Almost everything is common rb_tree-handling code that can be found in
> any place where rb-trees are used (hard-coded for flexibility,
> performance or whatever other reasons). So my feeling is that it
> should not be different here.
>
Sorry, not sure I quite understand what you're suggesting. Are you 
saying it doesn't make sense to have a generic range tree 
implementation, since really its just a small shim over the rbtree 
code?  So instead range-tree users should just implment them 
themselves?  Or something else?

thanks
-john

