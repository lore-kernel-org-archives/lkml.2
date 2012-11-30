Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab2K3Nx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:53:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061Ab2K3Nxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:53:54 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=bHYkjrJBMqQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Prf3J34inRMA:10 a=p6LN8kkkT-RizCNk7ewA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354283631.6276.143.camel@gandalf.local.home>
Subject: Re: [PATCH 1/3] aerdrv: Trace Event for AER
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
        lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2012 08:53:51 -0500
In-Reply-To: <20121130134232.GD6869@liondog.tnic>
References: <20121129215443.5483.43364.stgit@grignak.americas.hpqcorp.net>
	 <1354240279.6276.131.camel@gandalf.local.home>
	 <20121130105311.GA6869@liondog.tnic>
	 <1354275551.6276.140.camel@gandalf.local.home>
	 <20121130134232.GD6869@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-30 at 14:42 +0100, Borislav Petkov wrote:

> So, it sounds to me like we should we move all RAS-specific tracepoints
> to <trace/events/ras.h> and then in each usage site do:

Note, the CREATE_TRACE_POINTS must only be done in one location. Not
every place. It creates the code that does the work to make the
tracepoints show up in /debug/tracing/events/* as well as the callback
code and other such things. If you define it in more than one .c file,
then you will have linker issues due to the functions being created more
than once.

> 
> #define CREATE_TRACE_POINTS
> #include <trace/events/ras.h>
> 
> Correct?

That's the default way to do things.

> 
> FWIW, it looks neat and clean to me that way.

Yep, that's why it's default ;-)

-- Steve


