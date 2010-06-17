Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469Ab0FQRbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:31:35 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52125 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760403Ab0FQRbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:31:34 -0400
Date: Thu, 17 Jun 2010 19:31:42 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100617173142.GC6115@kryptos.osrc.amd.com>
References: <20100528155719.GA10141@kryptos.osrc.amd.com>
 <1275070030.1645.362.camel@laptop>
 <20100603134301.GA30880@kryptos.osrc.amd.com>
 <20100603173242.GD29202@ghostprotocols.net>
 <20100614192514.GA7803@kryptos.osrc.amd.com>
 <20100614210116.GA26716@ghostprotocols.net>
 <20100614212426.GA19915@liondog.tnic>
 <20100615010201.GA27077@ghostprotocols.net>
 <20100617134357.GA6115@kryptos.osrc.amd.com>
 <1276791597.3556.118.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276791597.3556.118.camel@gandalf.stny.rr.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Thu, Jun 17, 2010 at 12:19:57PM -0400

> On Thu, 2010-06-17 at 15:43 +0200, Borislav Petkov wrote:
> 
> > > One of the goals at least I have with pursuing this path is to separate
> > > out everything that is not strictly 'perf' into things that can be reused
> > > by other tools, like yours.
> > 
> > I'm still splitting perf/util into a more or less generic lib.
> > Now, I want to reuse as much code as possible and am parsing
> > the "mce:mce_record" tracepoint using parse_events(). However,
> > this means that I have to push the not-so-generic perf bits
> > like util/parse-events.c into the lib. Which, in turn, pulls in
> > util/trace-event* etc.
> 
> Note, I have a separate generic library in trace-cmd that has the
> parsing of trace events as its own library now.
> 
> This is the code that started trace-event-parse.c.
> 
> It has evolved quite a bit since then. You can get the code from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
> 
> The files are parse-events.c and parse-events.h. As well as some
> filtering code: parse-filter.c.
> 
> It creates a libparsevent library.
> 
> I've been meaning to update the perf stuff with it, but just have not
> had the time. Seems that what you are doing might be a good fit for it.

I see, well, I could take it and merge it into tools/trace-cmd or
something and then we all could gradually weed out common code. But I'm
open to other suggestions as well.

I mean, it is only natural if we merry perf and ftrace in kernel space
to do the same in userspace, right :)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis München
Registergericht Muenchen, HRB Nr. 43632
