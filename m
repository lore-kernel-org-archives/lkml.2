Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315Ab2D0U1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:27:05 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:55921 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760531Ab2D0U1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:27:03 -0400
Date: Fri, 27 Apr 2012 22:27:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: RFC: How to handle function tracing, frame pointers and
	-mfentry?
Message-ID: <20120427202701.GA5949@merkur.ravnborg.org>
References: <1335552399.28106.228.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335552399.28106.228.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 02:46:39PM -0400, Steven Rostedt wrote:
> I have code that implements -mfentry for the function tracer.
> 
> For those that are unfamiliar with this, it was introduced into gcc in
> 4.6.0 for x86 only. Used with the -pg option, it replaces mcount with
> fentry, and is placed at the first instruction of a function (instead of
> after the frame has been built, as mcount does).
> 
> So what's my problem?  With -mfentry, function tracer does not depend on
> frame pointers. As frame pointers may add overhead, some distros
> (Debian) has disabled frame pointers from their kernels and with that,
> has also disabled function tracing.
> 
> Currently, function tracing selects CONFIG_FRAME_POINTER for various
> archs (including x86), as the kernel will not compile without it, if
> function tracing is enabled. But if -mfentry is available with the
> compiler, it does not have this dependency. The kernel will compile fine
> with -pg -mfentry and without frame pointers.
> 
> My question is, how do I remove the dependency in kconfig based on the
> compiler?

Allow the user to select one of:
1) function tracer
2) frame pointer
3) none of the above

This should be trivial to do in Kconfig language.

If "function tracer" is selected then use -mfentry if supported,
with a fallback to frame pointers.

This looks simple IMO and should be easy to implement too.

	Sam
