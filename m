Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2IQHLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:11:21 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49912 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2IQHLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:11:20 -0400
Date: Mon, 17 Sep 2012 09:11:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 3/3 v2] perf tool: give user better message if precise is
 not supported
Message-ID: <20120917071113.GA31305@gmail.com>
References: <1347569955-54626-4-git-send-email-dsahern@gmail.com>
 <20120914054344.GB9043@gmail.com>
 <50531151.9020202@gmail.com>
 <20120914113617.GA13299@gmail.com>
 <5053186E.6000302@gmail.com>
 <20120914180013.GA27766@ghostprotocols.net>
 <1347646039.7172.66.camel@twins>
 <20120914200518.GA16872@gmail.com>
 <20120914201138.GA17024@gmail.com>
 <1347657962.7172.82.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347657962.7172.82.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2012-09-14 at 22:11 +0200, Ingo Molnar wrote:
> >   return -EPERF_CPU_PRECISE_EV_NOTSUPP;
> 
> I just don't like having to enumerate all possible fails, I'm 
> too lazy. Can't we be smarter about that? Could we do a 
> {reason}x{bit-offset} like thing?
> 
> Where we limit reason to a few simple things like:
> 
>  invalid
>  out-of-range
>  not-supported
> 
> and have the bit-offset indicate the field we're having the particular
> problem with?
> 
> Then all we need is a smart way to generate and map the bit-offsets
> without too much manual labour. 

Putting the 'where' into a separate field would do that, and 
thus we could generate and report such structured errors as well 
- but nevertheless there will always be special/individual 
errors as well that won't fit into such a scheme, for which we 
should include a 'boring' errno range as well ...

I.e. a {where},{what} s32 pair of fields - if 'where' is zero 
then 'what' is the enumerated errno value I suggested, if it's 
nonzero then it's the 'where' indication you suggested.

Thanks,

	Ingo
