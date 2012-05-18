Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab2EROda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:33:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab2EROd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:33:28 -0400
Date: Fri, 18 May 2012 16:33:15 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] lib: Proportions with flexible period
Message-ID: <20120518143315.GB6875@quack.suse.cz>
References: <1337096583-6049-1-git-send-email-jack@suse.cz>
 <1337096583-6049-2-git-send-email-jack@suse.cz>
 <1337290512.4281.91.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337290512.4281.91.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 17-05-12 23:35:12, Peter Zijlstra wrote:
> On Tue, 2012-05-15 at 17:43 +0200, Jan Kara wrote:
> > +               if (numerator > ((long long)denominator) * max_frac / 100)
> 
> Does that even compile on 32bit archs?
> 
> Operator precedence is *,/ left-to-right, so that's:
> 
>   long long t1 = (long long)denom * max_frac
>   long long t2 = t1 / 100;
> 
> Which is a 64bit signed division.
> 
> There's a reason I used that max_prop_frac thing you removed, it avoids
> having to do the division at all and allows a mult and shift instead.
  Yeah, I misunderstood it's purpose when I read the code originally. I'll
put it back to avoid the division since this is a hot path.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
