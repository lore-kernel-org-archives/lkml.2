Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab2JLWYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 18:24:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab2JLWYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 18:24:36 -0400
Date: Fri, 12 Oct 2012 15:21:42 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Subject: Re: [PATCH 2/3] vmevent: Factor vmevent_match_attr() out of
 vmevent_match()
Message-ID: <20121012222141.GA15629@lizard>
References: <20121004102013.GA23284@lizard>
 <1349346078-24874-2-git-send-email-anton.vorontsov@linaro.org>
 <CAOJsxLFW3WbBDdFhuJDwUxvGVfsy_Tg8SpR4pxTWAcfQ+LG0UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOJsxLFW3WbBDdFhuJDwUxvGVfsy_Tg8SpR4pxTWAcfQ+LG0UQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 03:37:43PM +0300, Pekka Enberg wrote:
[...]
> > +static bool vmevent_match_attr(struct vmevent_attr *attr, u64 value)
> > +{
> > +       u32 state = attr->state;
> > +       bool attr_lt = state & VMEVENT_ATTR_STATE_VALUE_LT;
> > +       bool attr_gt = state & VMEVENT_ATTR_STATE_VALUE_GT;
> > +       bool attr_eq = state & VMEVENT_ATTR_STATE_VALUE_EQ;
> > +       bool edge = state & VMEVENT_ATTR_STATE_EDGE_TRIGGER;
> > +       u32 was_lt_mask = VMEVENT_ATTR_STATE_VALUE_WAS_LT;
> > +       u32 was_gt_mask = VMEVENT_ATTR_STATE_VALUE_WAS_GT;
> > +       bool lt = value < attr->value;
> > +       bool gt = value > attr->value;
> > +       bool eq = value == attr->value;
> > +       bool was_lt = state & was_lt_mask;
> > +       bool was_gt = state & was_gt_mask;
> 
> [snip]
> 
> So I merged this patch but vmevent_match_attr() is still too ugly for
> words. It really could use some serious cleanups.

Thanks a lot for merging these cleanups!

Yes, the patch wasn't meant to simplify the matching logic, but just to
let us use the function in other places.

I once started converting the function into table-based approach, but the
code started growing, and I abandoned the idea for now. I might resume the
work just for the fun of it, but the code will be larger than this ad-hoc
function, althouh surely it will be more generic and understandable.

But let's solve primary problems with the vmevent first. :-)

Thanks,
Anton.
