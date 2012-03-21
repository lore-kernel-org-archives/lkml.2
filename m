Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2CULyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 07:54:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36072 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2CULyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 07:54:36 -0400
Message-ID: <1332330852.18960.482.camel@twins>
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 21 Mar 2012 12:54:12 +0100
In-Reply-To: <20120321095211.GA11122@gmail.com>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
	 <1332267341-26338-4-git-send-email-jolsa@redhat.com>
	 <1332269081.18960.444.camel@twins> <20120320204625.GA17142@gmail.com>
	 <1332321311.18960.474.camel@twins> <20120321095211.GA11122@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 10:52 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > # echo {}
> > {}
> > # echo {en,dis}able
> > enable disable
> > 
> > 
> > It somehow special cases {}, which is horrible.
> 
> Oh, indeed: brace expansion and sequence expressions both use 
> curly braces:
> 
>  $ echo foo-{a,b,c}-bar
>  foo-a-bar foo-b-bar foo-c-bar
> 
>  $ echo {1..10}
>  1 2 3 4 5 6 7 8 9 10
> 
> Too bad, it would be rather intuitive. All the brace characters 
> are taken by Bash.
> 
> Maybe something like:
> 
>  $ echo /minor-faults,major-faults/
>  /minor-faults,major-faults/
> 
> although it looks a bit weird.
> 
> So ... how about using another grouping operator, such as '+'?
> 
> Something like:
> 
>  -e minor-faults+major-faults
> 
> While when comma separated they are not grouped, or so.

I would much prefer a syntax that's more natural but requires quoting
than one that's quirky and tailor made to avoid whatever current bash
does. For one, there's other shells out there that might have different
quoting needs and bash is of course free to extend its syntax.


