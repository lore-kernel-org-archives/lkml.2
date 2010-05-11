Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab0EKXZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:25:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab0EKXZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:25:19 -0400
Date: Tue, 11 May 2010 16:24:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: DRM Error on Acer Aspire One
Message-Id: <20100511162458.51a2da8b.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimNX2T_HWWxKCYsBdxz6LrvrTOz5MbFcyxTy1br@mail.gmail.com>
References: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com>
	<89khjo$fd26d3@orsmga002.jf.intel.com>
	<20100511113555.a78c9c8e.akpm@linux-foundation.org>
	<89kc63$grv1m8@fmsmga002.fm.intel.com>
	<20100511121001.0731a9c2.akpm@linux-foundation.org>
	<89k77n$noi3t4@fmsmga001.fm.intel.com>
	<AANLkTikM916RlCBudL9_Pw--cpiu5mg_xcLFG9N1l9tL@mail.gmail.com>
	<20100511153217.5c7661d7.akpm@linux-foundation.org>
	<AANLkTilMWTbgcjx8_T-jCwykQmd7hwfXd2ijfP6flIiO@mail.gmail.com>
	<20100511155600.5c416992.akpm@linux-foundation.org>
	<AANLkTimNX2T_HWWxKCYsBdxz6LrvrTOz5MbFcyxTy1br@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 09:17:09 +1000
Dave Airlie <airlied@gmail.com> wrote:

> >> >> and
> >> >> this codepath is called from non-irq contexts just as much as irq
> >> >> contexts.
> >> >
> >> > That's fine. __As long as we do a local_irq_disable(), KM_IRQ0 can be
> >> > used from both irq- and non-irq contexts. __All we need to do is to
> >> > ensure that some interrupt cannot come along on this CPU and corrupt
> >> > the slot.
> >>
> >> I don't think we do that in a lot of places, and I'd rather not add
> >> that in to fix this problem at this point in the release cycle, as
> >> we've no idea what it might break/regress.
> >
> > What is "that"? __The switch to irq-protected KM_IRQ0? __That won't break
> > anything.
> >
> 
> disabling local cpu irqs around all these kmap mappings.
> 

Ah.  Well if there are other uses of KM_USER0 from interrupt context
then yes, we have more problems.  CONFIG_DEBUG_HIGHMEM &&
CONFIG_TRACE_IRQFLAGS_SUPPORT will detect that and as long as Jaswinder
has hit all code paths in his testing, we're good.  Some manual review
for this would be good.

