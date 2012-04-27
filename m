Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381Ab2D0UbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:31:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:32723 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760239Ab2D0UbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:31:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="93971036"
Message-ID: <4F9B020B.9050205@linux.intel.com>
Date: Fri, 27 Apr 2012 13:31:07 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: RFC: How to handle function tracing, frame pointers and -mfentry?
References: <1335552399.28106.228.camel@gandalf.stny.rr.com> <20120427202701.GA5949@merkur.ravnborg.org>
In-Reply-To: <20120427202701.GA5949@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 01:27 PM, Sam Ravnborg wrote:
>>
>> My question is, how do I remove the dependency in kconfig based on the
>> compiler?
> 
> Allow the user to select one of:
> 1) function tracer
> 2) frame pointer
> 3) none of the above
> 
> This should be trivial to do in Kconfig language.
> 
> If "function tracer" is selected then use -mfentry if supported,
> with a fallback to frame pointers.
> 
> This looks simple IMO and should be easy to implement too.
> 

Except it is the wrong thing.  This is not the only user of frame
pointer.  What I think you mean is remove the dependency in Kconfig, but
force the frame pointer enabled if -mfentry is not supported.

	-hpa


