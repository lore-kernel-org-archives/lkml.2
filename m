Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2EDRzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:55:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35878 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab2EDRzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:55:44 -0400
Date: Fri, 4 May 2012 10:55:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Sundar <sunder.svit@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: workqueue tracing removed?
Message-ID: <20120504175540.GG24639@google.com>
References: <CAMHCuPWNAWGMvEQz4yyBVuBJ9R86AZoH0MdUJbtumT+yd2CNMQ@mail.gmail.com>
 <1336078454.14207.105.camel@gandalf.stny.rr.com>
 <20120504170948.GE24639@google.com>
 <CAMHCuPWjCTDvGihodaojU84q0LuFa6VYPBmS+DdeeX0XPdtOiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMHCuPWjCTDvGihodaojU84q0LuFa6VYPBmS+DdeeX0XPdtOiw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 11:22:43PM +0530, Sundar wrote:
> I can get the workqueue insertion/execution/end events; but in the
> latest kernels, i see that worker:0/1 or worker:u/0 (similar) shows
> prominently on the traces, but I am not able to exactly pin point
> which worker thread was being executed; i remember on the older
> kernels, it used to be visible as something like work_dbs (ondemand
> governor) or work_*.
> 
> Am i missing something here?

Workers are now shared, so all the workqueues share the same set of
workers.  Work item execution can be tracked with tracepoints but
unfortunately there currently is no way to measure cpu consumption of
each work item.

Thanks.

-- 
tejun
