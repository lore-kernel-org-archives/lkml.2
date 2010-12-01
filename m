Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0LASxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:53:36 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40332 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab0LASxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:53:35 -0500
Subject: Re: [PATCH 4/9] x86, NMI: Remove DIE_NMI_IPI and add priorties to
 handlers
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101201184128.GB6478@lenovo>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
	 <1291156050-4482-5-git-send-email-dzickus@redhat.com>
	 <20101201184128.GB6478@lenovo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 19:53:42 +0100
Message-ID: <1291229622.32004.1886.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 21:41 +0300, Cyrill Gorcunov wrote:
> On Tue, Nov 30, 2010 at 05:27:25PM -0500, Don Zickus wrote:
> > When re-ordering how the NMI handles its callbacks, a conversation started
> > asking what DIE_NMI_IPI meant.  No one could answer it.
> 
> It should have came from commit
> 
>  | commit c4b2bffee2a4115fed2825530f2b906ee2f17bd7
>  | Author: Andi Kleen <ak@suse.de>
>  | Date:   Fri Jan 23 18:46:40 2004 -0800
>  |
>  |   [PATCH] x86-64 merge
>  |   
>  |   Mainly lots of bug fixes and a few minor features. One change is that
>  |   it uses drivers/Kconfig now like i386. This requires a few minor changes in
>  |   outside Kconfig files which I am sending separately.
>  ...
> 
> Andi do you remember what the initial idea was? Didn't find any user of it
> even in this old commit. Just curious.
> 
> > 
> > Noticing that is was wasteful to call the die_chain a second time with just
> > another argument, DIE_NMI_IPI, it was decided to nuke it and add priorities
> > to the die_chain handlers to maintain existing behaviour.
> > 
> > This patch replaces DIE_NMI_IPI with the appropriate option, mostly DIE_NMI.
> > Then it adds priorities to those handlers, using a globally defined set of
> > priorities for NMI.
> > 
> > The thought is eventually we will just switch the nmi handlers from the
> > die_chain to something more nmi specific.
> > 
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > ---
> 
>  Don, maybe switching to say new chains like chain_perf and friends would be
> more readable/clean? I'm not against this patch by any means, but just a thought ;)

Its a single event (NMI) so we only need a single notifier list, the
current one seems to be just fine.

