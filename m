Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab2I1Ox0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:53:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38531 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973Ab2I1OxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:53:25 -0400
Date: Fri, 28 Sep 2012 16:53:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, eranian@google.com, acme@redhat.com,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 04/31] perf, core: Add generic intx/intx_checkpointed counter modifiers
Message-ID: <20120928145324.GQ16230@one.firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org> <1348806696-31170-5-git-send-email-andi@firstfloor.org> <1348822920.3292.60.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348822920.3292.60.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:02:00AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
> > +                               intx           :  1, /* count inside transaction */
> > +                               intx_checkpointed :  1, /* checkpointed in transaction */ 
> 
> I really hate those names.. what are they called in transactional memory
> literature?

Don't know of any other names. The papers I looked at normally don't
bother with PMUs.

At some point I had intx_cp, would that be better?

> Also do we really need this? Using the event format stuff we could
> equally well do:
> 
> {cpu/cycles/, cpu/cycles,intx/, cpu/cycles,intx_checkpointed/}
> 
> No need to push those bits through perf_event_attr::flags when you can
> stuff then through perf_event_attr::config, esp. for very hardware
> specific features.

I can't use config, because the qualifiers are valid for events that
already use config (like offcore). 

So would need a new field. In fact that is what I did, I reused some
unused bits.

If I moved this into sysfs this would imply that the perf stat -T 
code would become Haswell specific. As far as I understand normally
you guys don't want things like that. Would everyone be ok with
having specific code there?

The perf stat -T equations output is fairly important -- it's normally
the first thing to look at for TSX -- so I would like to keep it.

Also as a selfish reason I would prefer something that is short 
to type. The qualifiers are quite common in scripts that do
measurements here. So I would prefer to keep :t and :c as user
interface.  But the internal implementation can be adjusted 
of course.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
