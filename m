Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0EKW4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 18:56:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391Ab0EKW4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 18:56:22 -0400
Date: Tue, 11 May 2010 15:56:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: DRM Error on Acer Aspire One
Message-Id: <20100511155600.5c416992.akpm@linux-foundation.org>
In-Reply-To: <AANLkTilMWTbgcjx8_T-jCwykQmd7hwfXd2ijfP6flIiO@mail.gmail.com>
References: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com>
	<89kc63$grtht6@fmsmga002.fm.intel.com>
	<20100511104818.8382a7de.akpm@linux-foundation.org>
	<89khjo$fd26d3@orsmga002.jf.intel.com>
	<20100511113555.a78c9c8e.akpm@linux-foundation.org>
	<89kc63$grv1m8@fmsmga002.fm.intel.com>
	<20100511121001.0731a9c2.akpm@linux-foundation.org>
	<89k77n$noi3t4@fmsmga001.fm.intel.com>
	<AANLkTikM916RlCBudL9_Pw--cpiu5mg_xcLFG9N1l9tL@mail.gmail.com>
	<20100511153217.5c7661d7.akpm@linux-foundation.org>
	<AANLkTilMWTbgcjx8_T-jCwykQmd7hwfXd2ijfP6flIiO@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 08:51:05 +1000
Dave Airlie <airlied@gmail.com> wrote:

> On Wed, May 12, 2010 at 8:32 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 12 May 2010 08:22:49 +1000
> > Dave Airlie <airlied@gmail.com> wrote:
> >
> >> On Wed, May 12, 2010 at 5:57 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >> > On Tue, 11 May 2010 12:10:01 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> >> >> On Tue, 11 May 2010 19:52:31 +0100
> >> >> Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >> >>
> >> >> > On Tue, 11 May 2010 11:35:55 -0400, Andrew Morton <akpm@linux-foundation.org> wrote:
> >> >> > > No, io_mapping_map_atomic_wc() cannot be used from [soft]irq context:
> >> >> > > it hardwires use of KM_USER0. __I suggest that io_mapping_create_wc(),
> >> >> > > io_mapping_map_atomic_wc() etc be changed so that the caller passes in the
> >> >> > > KM_foo kmap slot index.
> >> >> >
> >> >> > Argh, sorry for the noise, read the mail in the wrong order. Thanks for
> >> >> > the review. It would be sensible to go with your simpler patch whilst
> >> >> > io_mapping_map_atomic_wc() is improved.
> >> >>
> >> >> OK. __I'll be sending a bunch of fixes Linuswards in an hour or two.
> >> >> Should I include this?
> >> >
> >> > Yes.
> >> >
> >> > Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
> >> >
> >>
> >> I'm not sure pushing this in at this point is a good idea, if I'm
> >> reading it correctly we've no idea what KM_IRQ is being used for,
> >
> > It's used for taking kmaps from IRQ contexts.
> >
> >> and
> >> this codepath is called from non-irq contexts just as much as irq
> >> contexts.
> >
> > That's fine. __As long as we do a local_irq_disable(), KM_IRQ0 can be
> > used from both irq- and non-irq contexts. __All we need to do is to
> > ensure that some interrupt cannot come along on this CPU and corrupt
> > the slot.
> 
> I don't think we do that in a lot of places, and I'd rather not add
> that in to fix this problem at this point in the release cycle, as
> we've no idea what it might break/regress.

What is "that"?  The switch to irq-protected KM_IRQ0?  That won't break
anything.

> Its easier to just disable the hangcheck copy and try again for 2.6.35
> with a workqueue or slow work.

