Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2INV0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:26:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:43313 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab2INV0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:26:14 -0400
Message-ID: <1347657962.7172.82.camel@twins>
Subject: Re: [PATCH 3/3 v2] perf tool: give user better message if precise
 is not supported
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Date: Fri, 14 Sep 2012 23:26:02 +0200
In-Reply-To: <20120914201138.GA17024@gmail.com>
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
	 <1347569955-54626-4-git-send-email-dsahern@gmail.com>
	 <20120914054344.GB9043@gmail.com> <50531151.9020202@gmail.com>
	 <20120914113617.GA13299@gmail.com> <5053186E.6000302@gmail.com>
	 <20120914180013.GA27766@ghostprotocols.net>
	 <1347646039.7172.66.camel@twins> <20120914200518.GA16872@gmail.com>
	 <20120914201138.GA17024@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 22:11 +0200, Ingo Molnar wrote:
>   return -EPERF_CPU_PRECISE_EV_NOTSUPP;

I just don't like having to enumerate all possible fails, I'm too lazy.
Can't we be smarter about that? Could we do a {reason}x{bit-offset} like
thing?

Where we limit reason to a few simple things like:

 invalid
 out-of-range
 not-supported

and have the bit-offset indicate the field we're having the particular
problem with?

Then all we need is a smart way to generate and map the bit-offsets
without too much manual labour. 
