Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab0GAQWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:22:25 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35334 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab0GAQWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:22:23 -0400
Date: Thu, 1 Jul 2010 18:24:24 +0200
From: Borislav Petkov <bp@amd64.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/21] perf_events: Add a helper to search for an event
 in a context
Message-ID: <20100701162424.GI17823@aftab>
References: <1277992175-19821-1-git-send-email-bp@amd64.org>
 <1277992175-19821-4-git-send-email-bp@amd64.org>
 <1277992805.1917.142.camel@laptop>
 <20100701141352.GA17823@aftab>
 <20100701161133.GE10616@nowhere>
 <1278000765.1917.220.camel@laptop>
 <20100701161448.GF10616@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701161448.GF10616@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, Jul 01, 2010 at 12:14:50PM -0400

Hi Frederic,

> On Thu, Jul 01, 2010 at 06:12:45PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-07-01 at 18:11 +0200, Frederic Weisbecker wrote:
> > > I suspect we need another syscall that can list all the persistent events
> > > with a unique id and the attrs that follow.
> > > 
> > > So you get a unique id for all of them and you can create an fd on top
> > > of this id by using a PERF_FLAG_REQUEST_PERSISTENT and this id put in
> > > attr.config. 
> > 
> > Isn't that what filesystems were invented for?
> 
> 
> The problem is when you create a persistent event, you lose the fd.
> So you need to retrieve it somehow.

actually the idea is to decouple those from the fd alltogether and
provide specific file_operations in debugfs and such, as Peter
suggested. Which sounds much more sane to me especially since, at least
in the MCE case, all the entities that register into that event need to
see the same samples (and read the same buffers etc).

And let's try not to read too much into those persistent events - it may
just as well be that we need them only for MCEs and nothing else :)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
