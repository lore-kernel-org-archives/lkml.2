Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0KOLGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:06:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40763 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab0KOLGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:06:10 -0500
Date: Mon, 15 Nov 2010 12:06:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu, fweisbec@gmail.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
Message-ID: <20101115110608.GE7269@basil.fritz.box>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
 <AANLkTimJ3nLwmRfmf+uTuUvg6HVrHBzrjgQXuTi5dxyp@mail.gmail.com>
 <1289583192.2084.339.camel@laptop>
 <20101113101753.GE6418@gargoyle.fritz.box>
 <1289644462.2084.528.camel@laptop>
 <AANLkTikr-rOYALdUiRDFahqE1GECO5XNKnbN9LNZBebU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikr-rOYALdUiRDFahqE1GECO5XNKnbN9LNZBebU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 12:03:28PM +0100, Stephane Eranian wrote:
> On Sat, Nov 13, 2010 at 11:34 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Sat, 2010-11-13 at 11:17 +0100, Andi Kleen wrote:
> >> > That would assume a single event doesn't contain offcore and lbr, no?
> >> > Currently the extra_reg thing assumes there's only one extra reg encoded
> >> > in the config word.
> >>
> >> It would not be too hard to make it an array if that's needed.
> >
> > I don't think we want to go there anyway, one extra_reg per config value
> > is fine.
> >
> I think offcore goes into .config, lbr goes into extra_reg. That should take
> care of combinations as well.

The context switch code needs extra_reg for any extra regs including 
offcore, I don't want to walk the event table for that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
