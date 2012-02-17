Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab2BQF0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 00:26:17 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36297 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab2BQF0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 00:26:16 -0500
Message-ID: <1329456251.2373.44.camel@js-netbook>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: John Stultz <johnstul@us.ibm.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Date: Thu, 16 Feb 2012 21:24:11 -0800
In-Reply-To: <1329450227.2373.6.camel@js-netbook>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	 <1328832993-23228-2-git-send-email-john.stultz@linaro.org>
	 <CAO6Zf6B6nGqsz5zpT3ixbO-+JWxMsScABasnwo-CVHuMKPqpLQ@mail.gmail.com>
	 <1329450227.2373.6.camel@js-netbook>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021705-7182-0000-0000-000000D1F9CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 19:43 -0800, John Stultz wrote:
> On Sun, 2012-02-12 at 13:48 +0100, Dmitry Adamushko wrote:
> > 
> > On 10 February 2012 01:16, John Stultz <john.stultz@linaro.org> wrote:
> 
> >         +static inline void volatile_range_shrink(struct
> >         volatile_range *range,
> >         +                               pgoff_t start_index, pgoff_t
> >         end_index)
> >         +{
> >         +       size_t pre = range_size(range);
> >         +
> >         +       range->range_node.start = start_index;
> >         +       range->range_node.end = end_index;
> >         +
> > 
> > I guess, here we get a whole range of races with volatile_shrink(),
> > which may see inconsistent (in-the-middle-of-update) ranges
> > (e.g. .start and .end).
> 
> We should be holding the vlist_mutex to avoid any such races. But you
> also make clear that volatile_range_shrink() should really be called
> volatile_range_resize(), since having two _shrink calls is terrible. My
> apologies.

And sure enough in the shrinker we're not holding the vlist_mutex.
Thanks for pointing that out. 
-john

