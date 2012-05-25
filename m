Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2EYRkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:40:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:19631 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab2EYRkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:40:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147867696"
Message-ID: <4FBFC421.3020901@linux.intel.com>
Date: Fri, 25 May 2012 10:40:49 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: BUG - function tracing with breakpoints
References: <20120524160146.GA6226@redhat.com>  <1337876398.13348.178.camel@gandalf.stny.rr.com>  <20120524172223.GA10689@redhat.com>  <1337902816.13348.224.camel@gandalf.stny.rr.com>  <4FBEC9E6.8040301@linux.intel.com>  <1337909963.13348.232.camel@gandalf.stny.rr.com>  <1337910106.13348.234.camel@gandalf.stny.rr.com>  <1337956262.13348.257.camel@gandalf.stny.rr.com> <1337959746.13348.264.camel@gandalf.stny.rr.com>
In-Reply-To: <1337959746.13348.264.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 08:29 AM, Steven Rostedt wrote:
> 
> This would make sense for this bug, as if modifying_ftrace_code was not
> seen by other CPUs, it wouldn't go into the ftrace_int3_handler() path.
> That would cause this issue. But the bug remains after the smp_mb()'s
> were put in place. Although it behaves a little differently not. Maybe
> there's something else I missed?
> 

Perhaps you should make the modifying_ftrace_code modification atomic...
it seems odd to have it not be atomic when it is clearly accessed across
CPUs that way.

	-hpa


