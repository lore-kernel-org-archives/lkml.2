Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2I0MJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:09:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20077 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2I0MJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:09:26 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=LrhBLfKaQO8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SlKO6I3lSDoA:10 a=SzY6Sz0nNkzNtCK9TloA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348747763.22822.70.camel@gandalf.local.home>
Subject: Re: [PATCH v6] hashtable: introduce a small and naive hashtable
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        torvalds@linux-foundation.org, tj@kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, neilb@suse.de, bfields@fieldses.org,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        josh@joshtriplett.org, rmallon@gmail.com, palves@redhat.com
Date: Thu, 27 Sep 2012 08:09:23 -0400
In-Reply-To: <50640F4E.4020305@gmail.com>
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com>
	 <1348667992.22822.50.camel@gandalf.local.home> <506310AA.2050700@gmail.com>
	 <20120926143905.GB22699@Krystal>
	 <1348675764.22822.56.camel@gandalf.local.home>
	 <20120926161956.GB28648@Krystal>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7009@saturn3.aculab.com>
	 <50640F4E.4020305@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 10:33 +0200, Sasha Levin wrote:

> Right, the flag thing in the macro was there just to make it work properly as a macro.
> 
> >> Agreed that the flags should be removed. Moving to define + static
> >> inline is still important though.
> > 
> > Not sure I'd bother making the function inline.
> 
> I usually never make anything 'inline', I just let gcc do it's own thing when it compiles the code. If there are any objections
> please let me know before I send the new version.

But this is a header file. You guys have no problem with macros, but
refuse to use 'inline' for functions defined in header files? That
doesn't make sense. A 'static inline' is basically a gcc macro, but
without the side-effects.

-- Steve


