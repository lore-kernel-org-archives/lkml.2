Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762710Ab2ERKuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:50:08 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39002 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab2ERKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:50:05 -0400
Date: Fri, 18 May 2012 12:49:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
Message-ID: <20120518104947.GG20215@aftab.osrc.amd.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
 <1332340496-21658-2-git-send-email-bp@amd64.org>
 <1337335753.573.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337335753.573.9.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 12:09:13PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-03-21 at 15:34 +0100, Borislav Petkov wrote:
> > +                               persistent     :  1, /* always-on event */
> 
> Should creating something like that be privileged?

Yeah, I dunno, do we want that? Well, what it is when we enable an event
during boot, i.e. say "boot_trace=<event>..." on the kernel command line
and this event is enabled until we finish booting. Then we disable it
with perf or over debugfs. Is that privileged or can any user boot-trace
the system?

All good questions.

> And it looks like you allow creating persistent per-task events; is
> that useful, if so why? And like already pointed out, your cleanup
> seems broken in that case.

This was dumb - I wanted to have task-agnostic events which get enabled
for the whole system and there's a buffer on each CPU which collects
their output. It was a first attempt and it is a good thing you gave it
a look so that I can address the issues properly.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
