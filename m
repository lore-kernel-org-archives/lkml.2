Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab0DWQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:56:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23293 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0DWQ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:56:23 -0400
Date: Fri, 23 Apr 2010 09:55:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Add documentation for trace commands mod,
 traceon/traceoff
Message-Id: <20100423095528.668decf8.randy.dunlap@oracle.com>
In-Reply-To: <1272039467-27413-1-git-send-email-chase.douglas@canonical.com>
References: <1272039467-27413-1-git-send-email-chase.douglas@canonical.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BD1D127.00C3:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 12:17:47 -0400 Chase Douglas wrote:

> The mod command went in as commit
> 64e7c440618998fd69eee6ab490b042d12248021
> 
> The traceon/traceoff commands when in as commit
> 23b4ff3aa479c9e3bb23cb6b2d0a97878399784a
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> ---
>  Documentation/trace/ftrace.txt |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index 03485bf..64e08d5 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -155,6 +155,9 @@ of ftrace. Here is a list of some of the key files:
>  	to be traced. Echoing names of functions into this file
>  	will limit the trace to only those functions.
>  
> +	This interface also allows for commands to be used. See the
> +	"Filter commands" section for more details.
> +
>    set_ftrace_notrace:
>  
>  	This has an effect opposite to that of
> @@ -1822,6 +1825,38 @@ this special filter via:
>   echo > set_graph_function
>  
>  
> +Filter commands
> +---------------
> +
> +A few commands are supported by the set_ftrace_filter interface.
> +Trace commands have the following format:
> +
> +<function>:<command>:<parameter>
> +
> +The following commands are supported:
> +
> +- mod
> +  This command enables function filtering per module. The
> +  parameter defines the module. For example, if only the write*
> +  functions in the ext3 module are useful in a trace, echo
> +  'write*:mod:ext3' > set_ftrace_filter. This command interacts

Can we have the echo command all on one line, please?  E.g.:

+  parameter defines the module. For example, if only the write*
+  functions in the ext3 module are useful in a trace, use:
+	echo 'write*:mod:ext3' > set_ftrace_filter
+  This command interacts



> +  with the filter in the same way as filtering based on function
> +  names. Thus, adding more functions in a different module is
> +  accomplished by appending (>>) to the filter file. Remove
> +  specific module functions by prepending '!'
> +  (!writeback*:mod:ext3).
> +
> +- traceon/traceoff
> +  These commands turn tracing on and off when the specified
> +  functions are hit. The parameter determines how many times the
> +  tracing system is turned on and off. If unspecified, there is
> +  no limit. For example, to disable tracing when a schedule bug
> +  is hit the first 5 times, use '__schedule_bug:traceoff:5'.
> +  These commands are cumulative whether or not they are appended
> +  to set_ftrace_filter. To remove a command, prepend it by '!'
> +  and drop the parameter (!__schedule_bug:traceoff).
> +
> +
>  trace_pipe
>  ----------


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
