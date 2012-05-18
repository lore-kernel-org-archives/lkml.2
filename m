Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2EROhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:37:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:58363 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2EROhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:37:47 -0400
Message-ID: <1337351857.573.47.camel@twins>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 18 May 2012 16:37:37 +0200
In-Reply-To: <20120518142131.GO20215@aftab.osrc.amd.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
	 <1332340496-21658-2-git-send-email-bp@amd64.org>
	 <1337336040.573.12.camel@twins> <20120518110357.GH20215@aftab.osrc.amd.com>
	 <1337340263.573.31.camel@twins> <20120518115957.GB19785@gmail.com>
	 <20120518125505.GK20215@aftab.osrc.amd.com> <1337348267.573.37.camel@twins>
	 <20120518140945.GN20215@aftab.osrc.amd.com> <1337350462.573.39.camel@twins>
	 <20120518142131.GO20215@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 16:21 +0200, Borislav Petkov wrote:
> On Fri, May 18, 2012 at 04:14:22PM +0200, Peter Zijlstra wrote:
> > On Fri, 2012-05-18 at 16:09 +0200, Borislav Petkov wrote:
> > > What happens here if a second user wants to enable a second set of
> > > persistent events, allocate a second set of per-CPU buffers? 
> > 
> > I'm not seeing the relation to VM_SHARED here.
> 
> Well, in the sense that if mmap fails in the !VM_SHARED case, I can't
> enable any persistent events except the ones which are enabled and so
> I need to allocate another set of resources for that second persistent
> events user.

Right, well, you could actually allow operations on the fd, just not a
second mapping :-)

Anyway.. I'd push that error back to the user. If they need a second
set, let them create it.

Do you really need multiple consumers for your MCE stuff? If so, what
would be the problem of using VM_SHARED?
