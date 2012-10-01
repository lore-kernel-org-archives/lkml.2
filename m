Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2JAOCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:02:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2JAOCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:02:15 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=z3dDlT83ks8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=zmiQl4g2j2sA:10 a=VwQbUJbxAAAA:8 a=Ac4JcXBWXwc4Ikoh0mIA:9 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349100133.22822.114.camel@gandalf.local.home>
Subject: Re: [PATCH] lib tools traceevent: Add back pevent assignment in
 __pevent_parse_format()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Mon, 01 Oct 2012 10:02:13 -0400
In-Reply-To: <1349098929.1613.11.camel@leonhard>
References: <1348885245.22822.104.camel@gandalf.local.home>
	 <1349098929.1613.11.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 22:42 +0900, Namhyung Kim wrote:
> 2012-09-28 (금), 22:20 -0400, Steven Rostedt:
> > Even though with the change of commit commit 2b29175 "tools lib traceevent:
> > Carve out events format parsing routine", allowed __pevent_parse_format() to
> > parse an event without the need of a pevent handler, the event still needs to
> > assign the pevent handed to it.
> > 
> > There's no problem with assigning it if the pevent is NULL, as the event->pevent
> > would be NULL without the assignment. But function parsing handlers may be
> > assigned to the pevent handler to help in parsing the event. If there's no
> > pevent then there would not be any function handlers, but if the pevent
> > isn't assigned first before parsing the event, it wont honor the function
> > handlers that were assigned.
> > 
> > Worse yet, the current code crashes if an event has a function that it tries
> > to parse. For example:
> > 
> >  # perf record -e scsi:scsi_dispatch_cmd_timeout
> >  Segmentation fault (core dumped)
> > 
> > This happens because the scsi_dispatch_cmd_timeout event format has the following:
> > 
> >   __print_hex(__get_dynamic_array(cmnd), REC->cmd_len)
> > 
> > which hasn't been defined by the pevent code.
> 
> ???  We have both of __print_hex() and __get_dynamic_array() handler,
> please see process_function.  In my case, the offending function was
> "scsi_trace_parse_cdb".
> 

Ah, you're right. I'll update the commit log. I missed that function. It
was late when I wrote this and should have look harder :-p

> Other than that, looks good to me.
> 
> Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,

Will submit with your tag and a changed log.

-- Steve



