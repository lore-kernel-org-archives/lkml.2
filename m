Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab0LBG5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 01:57:44 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54272 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0LBG5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 01:57:43 -0500
Date: Thu, 2 Dec 2010 15:56:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Bennee <kernel-hacker@bennee.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] flex_array: export symbols to modules
Message-ID: <20101202065642.GC3367@linux-sh.org>
References: <AANLkTik_TQfQDERdRQaQek3S7280sQBmHGKOnhJwU5EE@mail.gmail.com> <alpine.DEB.2.00.1012011714510.22420@chino.kir.corp.google.com> <20101202063054.GB3367@linux-sh.org> <20101202065735.GE5196@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202065735.GE5196@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 02:57:35PM +0800, Am??rico Wang wrote:
> On Thu, Dec 02, 2010 at 03:30:55PM +0900, Paul Mundt wrote:
> >On Wed, Dec 01, 2010 at 05:16:05PM -0800, David Rientjes wrote:
> >> On Wed, 1 Dec 2010, Alex Bennee wrote:
> >> > I want to be able to use the flex_array functions in my module so I
> >> > wanted to EXPORT_SYMBOL the API.
> >> > 
> >> > I added the appropriate EXPORT_SYMBOL runes into lib/flex_array.c and
> >> > added externs in the header files but after re-building there is still
> >> > no sign of them in Module.symvers.
> >> 
> >> You shouldn't need to add any externs in include/linux/flex_array.h, they 
> >> should already be publically declared.
> >> 
> >> Perhaps you forgot to include linux/module.h in lib/flex_array.c?
> >> 
> >> flex_array: export symbols to modules
> >> 
> >> Add EXPORT_SYMBOL() for all publically accessible flex array functions.
> >> 
> >> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> >> Signed-off-by: David Rientjes <rientjes@google.com>
> >> ---
> >>  lib/flex_array.c |   10 ++++++++++
> >>  1 files changed, 10 insertions(+), 0 deletions(-)
> >> 
> >This will be ineffective so long as flex_array.o remains lib-y. It will
> >need to be moved to obj-y if modules are to also make use of it.
> 
> Not moved, it needs to be added to obj-y.

Wrong, try again. Unless something has recently changed, an object can
not be both lib-y and obj-y. The object needs to be moved for modules to
make use of it, period.
