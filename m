Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2JWNTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:19:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59786 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab2JWNTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:19:03 -0400
Date: Tue, 23 Oct 2012 15:19:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 15/34] perf, core: Add a concept of a weightened sample
Message-ID: <20121023131901.GU16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org> <1350602382-12771-16-git-send-email-andi@firstfloor.org> <1350998032.13456.25.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350998032.13456.25.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:13:52PM +0200, Peter Zijlstra wrote:
> > @@ -562,6 +565,7 @@ enum perf_event_type {
> >          *      { u64                   stream_id;} && PERF_SAMPLE_STREAM_ID
> >          *      { u32                   cpu, res; } && PERF_SAMPLE_CPU
> >          *      { u64                   period;   } && PERF_SAMPLE_PERIOD
> > +        *      { u64                   weight;   } && PERF_SAMPLE_WEIGHT
> >          *
> >          *      { struct read_format    values;   } && PERF_SAMPLE_READ
> >          * 
> 
> So the only issues I have are that his makes every sample more expensive
> by having to 0 out that weight data and the sample placement.

It's only reported when explicitely enabled (-W). So most users
shouldn't see any overhead (except two untaken if()s or so)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
