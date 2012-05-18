Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab2ERLER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:04:17 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39094 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2ERLEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:04:16 -0400
Date: Fri, 18 May 2012 13:03:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
Message-ID: <20120518110357.GH20215@aftab.osrc.amd.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
 <1332340496-21658-2-git-send-email-bp@amd64.org>
 <1337336040.573.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337336040.573.12.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 12:14:00PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-03-21 at 15:34 +0100, Borislav Petkov wrote:
> > +int perf_add_persistent_on_cpu(int cpu, struct pers_event_desc *desc,
> > +                              struct dentry *dir, unsigned nr_pages) 
> 
> OK, so this creates an even and registers it somewhere in debugfs.

(debugfs)/mce/

>  - you allow an arbitrary place in debugfs; this might make finding
> them 'interesting'. Should we put them all in the same place?

My take on this is that we want to be able to make the same events we
have now, persistent. Basically not trace for the duration of a child
process but in a process-agnostic way, system-wide.

In that case, we probably want to be able to mark events as persistent,
maybe add another node in debugfs:

(debugfs)/tracing/events/mce/mce_record/attr

which can be used for flags or whatever, or something to that effect...

>  - persistent events created from userspace don't seem to get a debugfs
> entry and will be lost forever?

Yeah, see above.

> In general I think a little more exploring of the semantics and
> ramifications might be in order.

Absolutely!

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
