Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab2DXTPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:15:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37377 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab2DXTPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:15:02 -0400
Message-ID: <1335294860.28150.219.camel@twins>
Subject: Re: [PATCH 1/3] Range tree implementation
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Tue, 24 Apr 2012 21:14:20 +0200
In-Reply-To: <1335289787-11089-2-git-send-email-john.stultz@linaro.org>
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org>
	 <1335289787-11089-2-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 10:49 -0700, John Stultz wrote:
> This makes it
> very difficult to provide generic list_head like behavior, as
> the parent structures would need to be duplicated and removed,
> and that has lots of memory ownership issues. 

You can in fact modify the rb-tree to have O(1) iteration by using the
empty leaf pointers to keep pointers to next/prev nodes.

Its a bit of a bother since you'd need to wrap ->rb_left and ->rb_right
in functions.. but now that we have coccinelle that shouldn't actually
be too hard.


