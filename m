Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0GAQ1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:27:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58567 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab0GAQ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HEfsq1IVsGFM/YwXhrARG7gnBLb07nkgWcuASLtLu25iGScDNFTGDR6c/HtgBuQ/AM
         nCJQnCMF1qrADIByJ/It3lFZx1XoXZ0us8v5p9uxPKg2miqE4O8waJ1Eh8qFl5BdqUJ8
         A86shvcV0A2WHdpRb2ktuoaOvcIyYWiscDEyw=
Date: Thu, 1 Jul 2010 18:27:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/21] perf_events: Add a helper to search for an event
	in a context
Message-ID: <20100701162742.GI10616@nowhere>
References: <1277992175-19821-1-git-send-email-bp@amd64.org> <1277992175-19821-4-git-send-email-bp@amd64.org> <1277992805.1917.142.camel@laptop> <20100701141352.GA17823@aftab> <20100701161133.GE10616@nowhere> <1278000765.1917.220.camel@laptop> <20100701161448.GF10616@nowhere> <20100701162424.GI17823@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701162424.GI17823@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 06:24:24PM +0200, Borislav Petkov wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Thu, Jul 01, 2010 at 12:14:50PM -0400
> 
> Hi Frederic,
> 
> > On Thu, Jul 01, 2010 at 06:12:45PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2010-07-01 at 18:11 +0200, Frederic Weisbecker wrote:
> > > > I suspect we need another syscall that can list all the persistent events
> > > > with a unique id and the attrs that follow.
> > > > 
> > > > So you get a unique id for all of them and you can create an fd on top
> > > > of this id by using a PERF_FLAG_REQUEST_PERSISTENT and this id put in
> > > > attr.config. 
> > > 
> > > Isn't that what filesystems were invented for?
> > 
> > 
> > The problem is when you create a persistent event, you lose the fd.
> > So you need to retrieve it somehow.
> 
> actually the idea is to decouple those from the fd alltogether and
> provide specific file_operations in debugfs and such, as Peter
> suggested. Which sounds much more sane to me especially since, at least
> in the MCE case, all the entities that register into that event need to
> see the same samples (and read the same buffers etc).



Sure the idea of putting that in fs is better.

Note the idea of a new syscall was quite close: it would have listed
unique ids of the persistent events, but not fds, you'd have yet to create
those fds on top of the ids.



> 
> And let's try not to read too much into those persistent events - it may
> just as well be that we need them only for MCEs and nothing else :)


Not really. It would be useful for boot tracing, amongst various other things
like flight recorder tracing, etc...

