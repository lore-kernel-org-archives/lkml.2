Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2D0U5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:57:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10492 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2D0U5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:57:43 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=szhx8aRwONgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=dKikoRH4szyxAt15q8UA:9 a=Ysl6gAdm4LLEnX_SRJcA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335560259.28106.234.camel@gandalf.stny.rr.com>
Subject: Re: RFC: How to handle function tracing, frame pointers and
 -mfentry?
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 27 Apr 2012 16:57:39 -0400
In-Reply-To: <4F9B020B.9050205@linux.intel.com>
References: <1335552399.28106.228.camel@gandalf.stny.rr.com>
	 <20120427202701.GA5949@merkur.ravnborg.org>
	 <4F9B020B.9050205@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 13:31 -0700, H. Peter Anvin wrote:
> On 04/27/2012 01:27 PM, Sam Ravnborg wrote:
> >>
> >> My question is, how do I remove the dependency in kconfig based on the
> >> compiler?
> > 
> > Allow the user to select one of:
> > 1) function tracer
> > 2) frame pointer
> > 3) none of the above
> > 
> > This should be trivial to do in Kconfig language.
> > 
> > If "function tracer" is selected then use -mfentry if supported,
> > with a fallback to frame pointers.
> > 
> > This looks simple IMO and should be easy to implement too.
> > 
> 
> Except it is the wrong thing.  This is not the only user of frame
> pointer.  What I think you mean is remove the dependency in Kconfig, but
> force the frame pointer enabled if -mfentry is not supported.

You mean option 3?

3) Add frame pointers silently if gcc fails to build with gcc -pg.

Which I should have added, relies on the same thing as option 2:

2) Remove the select entirely.


-- Steve


