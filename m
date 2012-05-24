Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab2EXQp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:45:26 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36792 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab2EXQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:45:23 -0400
Date: Thu, 24 May 2012 18:45:54 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120524164554.GM27063@aftab.osrc.amd.com>
References: <1337358773-6919-38-git-send-email-mchehab@redhat.com>
 <1337854460-25191-1-git-send-email-mchehab@redhat.com>
 <20120524105604.GC27063@aftab.osrc.amd.com>
 <4FBE5E1D.7070804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBE5E1D.7070804@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 01:13:17PM -0300, Mauro Carvalho Chehab wrote:
> > Why are we even exporting grain actually with each tracepoint
> > invocation? This is the granularity of reported error in bytes, and it,
> > as such, is statically assigned to a value in each driver. Userspace can
> > certainly figure out that value in a different way.
> 
> The API doesn't export the grain, except via the tracepoint/printk.

And this is exactly my question: if it is a static value which is set
once per driver, why do we have to issue it with _every_ tracepoint
invocation? Room in the per-cpu trace buffers is not for free.

> > But the more important question is: does the grain help us when handling
> > the error info in userspace?
> > 
> > It tells us that at this physical address with "grain" granularity we
> > had an error. So?
> 
> While a certain number of corrected errors that happened on different, sparsed,
> addresses may not mean a damaged memory, the same number of corrected errors
> happening at the same physical address/grain means that the DRAM chip that
> contains such address is damaged, so the corresponding DIMM needs to be 
> replaced.
> 
> So, the address/grain can be used by userspace algorithms to increase the
> probability that a DIMM is damaged.

I have no idea what you're saying here.

The DIMM can be pinpointed using the address only, why do you need the
grain too?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
