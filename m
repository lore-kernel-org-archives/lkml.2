Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762611Ab2ERJ47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:56:59 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38614 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762250Ab2ERJ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:56:57 -0400
Date: Fri, 18 May 2012 11:56:38 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory
 controller events
Message-ID: <20120518095638.GA20215@aftab.osrc.amd.com>
References: <1337287277-523-1-git-send-email-mchehab@redhat.com>
 <20120517214859.GA16777@aftab.osrc.amd.com>
 <20120518071244.GE429@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518071244.GE429@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 09:12:44AM +0200, Ingo Molnar wrote:
> > > Of course, any userspace tools meant to handle errors should not parse
> > > the above data. They should, instead, use the binary fields provided by
> > > the tracepoint, mapping them directly into their MIBs.
> > 
> > Nacked-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> Just wondering why this got nacked, and what the 
> suggestions/plans are to improve the situation:

Basically this is the thread which lead to it: http://marc.info/?l=linux-kernel&m=133709477524773&w=2

> I assume Mauro is working on these things to solve problems, or to
> add features, Mauro could you please give a higher level list of
> those problems or features? There must be more to it than just a new
> tracepoint! :-)

My main objection was that the tracepoint to report errors from edac
contains the following prototype:

+	TP_PROTO(const unsigned int err_type,
+		 const unsigned int mc_index,
+		 const char *error_msg,
+		 const char *label,
+		 const char *location,
+		 const char *core_detail,
+		 const char *driver_detail),

and that the last args should be merged simply into one 'const char
*detail' which every driver can populate as it sees fit.

But Mauro did not want to parse the string in userspace but feed it
straight into a MIB (which could mean "Men In Black" for all I know),
right from the tracepoint:

> Of course, any userspace tools meant to handle errors should not parse
> the above data. They should, instead, use the binary fields provided by
> the tracepoint, mapping them directly into their MIBs.

And I wanted to have a generic, usable-for-all tracepoint output
which anyone in userspace can parse, decode, cut, paste as she sees
fit without forcing kernel output formatting into any abstract error
management hierarchy or whatever.

As Tony put it, we need to hammer that out properly now before it
becomes an ABI.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
