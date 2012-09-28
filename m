Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab2I1Om2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:42:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38520 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab2I1Om1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:42:27 -0400
Date: Fri, 28 Sep 2012 16:42:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, eranian@google.com, acme@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/31] perf, x86: Add PEBSv2 record support
Message-ID: <20120928144221.GP16230@one.firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org> <1348806696-31170-2-git-send-email-andi@firstfloor.org> <1348821784.3292.50.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348821784.3292.50.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:43:04AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
> > +               if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
> 
> Shouldn't that be: && x86_pmu.intel_cap.pebs_trap, like most other sites
> instead? Or didn't they flip the trap capability on Haswell?

In theory you're right, but trap wouldn't work for TSX aborts. Even if PEBS 
was a trap (it isn't) the trap would abort. Looking at the stack frame I
would get the wrong IP after the abort, not the abort event itself.

So to do the trap check would need to explicitely check for TSX abort
events too, which would be possible but fairly ugly.

If the flag ever changes could revisit this but I don't see it right
now. Also when available there's no good reason not to use EventingRip.

-andi
-- 
ak@linux.intel.com -- Speaking for myself only.
