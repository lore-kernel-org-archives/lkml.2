Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2DXTZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:25:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49329 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806Ab2DXTZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:25:29 -0400
Message-ID: <4F96FE1D.8040906@linaro.org>
Date: Tue, 24 Apr 2012 12:25:17 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] Range tree implementation
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org> <1335289787-11089-2-git-send-email-john.stultz@linaro.org> <1335294860.28150.219.camel@twins>
In-Reply-To: <1335294860.28150.219.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042419-7182-0000-0000-00000159E86E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 12:14 PM, Peter Zijlstra wrote:
> On Tue, 2012-04-24 at 10:49 -0700, John Stultz wrote:
>> This makes it
>> very difficult to provide generic list_head like behavior, as
>> the parent structures would need to be duplicated and removed,
>> and that has lots of memory ownership issues.
> You can in fact modify the rb-tree to have O(1) iteration by using the
> empty leaf pointers to keep pointers to next/prev nodes.
>
> Its a bit of a bother since you'd need to wrap ->rb_left and ->rb_right
> in functions.. but now that we have coccinelle that shouldn't actually
> be too hard.
>
Sorry, I'm not sure I'm following you.

My point above was that a generic range-tree implementation that manages 
the splitting and coalescing of ranges internally is difficult, due to 
memory ownership issues.  This makes it hard to have a generic list_head 
style structure that you can use in your own structures. Thus in a way 
similar to how the rb_tree leaves the insert and search implementation 
to the suers,  there is a range_tree_node structure, and the splitting 
and coalescing logic is left to the range-tree user.

Does your suggestion address the ownership issue differently?  Or is it 
just a general optimization improvement?

thanks
-john

