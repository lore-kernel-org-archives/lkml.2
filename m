Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2JANmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:42:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41979 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2JANmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:42:15 -0400
Subject: Re: [PATCH] lib tools traceevent: Add back pevent assignment in
 __pevent_parse_format()
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
In-Reply-To: <1348885245.22822.104.camel@gandalf.local.home>
References: <1348885245.22822.104.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Oct 2012 22:42:09 +0900
Message-ID: <1349098929.1613.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-09-28 (금), 22:20 -0400, Steven Rostedt:
> Even though with the change of commit commit 2b29175 "tools lib traceevent:
> Carve out events format parsing routine", allowed __pevent_parse_format() to
> parse an event without the need of a pevent handler, the event still needs to
> assign the pevent handed to it.
> 
> There's no problem with assigning it if the pevent is NULL, as the event->pevent
> would be NULL without the assignment. But function parsing handlers may be
> assigned to the pevent handler to help in parsing the event. If there's no
> pevent then there would not be any function handlers, but if the pevent
> isn't assigned first before parsing the event, it wont honor the function
> handlers that were assigned.
> 
> Worse yet, the current code crashes if an event has a function that it tries
> to parse. For example:
> 
>  # perf record -e scsi:scsi_dispatch_cmd_timeout
>  Segmentation fault (core dumped)
> 
> This happens because the scsi_dispatch_cmd_timeout event format has the following:
> 
>   __print_hex(__get_dynamic_array(cmnd), REC->cmd_len)
> 
> which hasn't been defined by the pevent code.

???  We have both of __print_hex() and __get_dynamic_array() handler,
please see process_function.  In my case, the offending function was
"scsi_trace_parse_cdb".

Other than that, looks good to me.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung




