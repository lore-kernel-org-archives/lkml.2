Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1CYTtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:49:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35408 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab1CYTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:49:49 -0400
Date: Fri, 25 Mar 2011 20:49:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, Ian Lance Taylor <ian@airs.com>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 2/2] Replace the linear search with a binary search for locate the symbols
Message-ID: <20110325194946.GQ21838@one.firstfloor.org>
References: <1300914043-2297-1-git-send-email-abogani@kernel.org> <1300914043-2297-3-git-send-email-abogani@kernel.org> <m27hbov7hq.fsf@firstfloor.org> <8739mblr2n.fsf@rustcorp.com.au> <20110325154118.GN21838@one.firstfloor.org> <AANLkTinW4GA094Yz94Y0qTEJvjOmRe4_C+5yc7_VcKM3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinW4GA094Yz94Y0qTEJvjOmRe4_C+5yc7_VcKM3@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 05:30:11PM +0100, Alessio Igor Bogani wrote:
> Dear Mr. Kleen,
> 
> 2011/3/25 Andi Kleen <andi@firstfloor.org>:
> [...]
> >> > Patch looks good to me. SORT is a nice trick, too bad it won't
> >> > work for the main kernel.
> >>
> >> Why not?
> >
> > Because kallsyms is supposed to be in address order, not name order.
> 
> What should that break exactly?
> Thanks you very much!

For kallsyms you either look it up by address or by name.
You can only sort for one of those.

Most likely address lookup is more important.

If you sorted by name you would make the address case slower.

Then the order is also exposed in /proc/kallsyms. If people use
this like System.map they likely expect numeric order.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
