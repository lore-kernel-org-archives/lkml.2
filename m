Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab2CTUAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:00:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58703 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2CTUAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:00:18 -0400
Message-ID: <1332273597.18960.454.camel@twins>
Subject: Re: [PATCH 1/1] Fix number of events displayed in header
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ashay Rane <ashay.r@gmail.com>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-perf-users@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ashay Rane <ashay.rane@tacc.utexas.edu>
Date: Tue, 20 Mar 2012 20:59:57 +0100
In-Reply-To: <CANn2t1n3fiVGqMKm=a7k3bKgKRzVdo3zu54ZKiCMqtDFbS4MeA@mail.gmail.com>
References: <1332271396-21756-1-git-send-email-ashay.r@gmail.com>
	 <20120320194241.GA24870@infradead.org> <4F68DE88.1040301@gmail.com>
	 <1332272870.18960.450.camel@twins>
	 <CANn2t1n3fiVGqMKm=a7k3bKgKRzVdo3zu54ZKiCMqtDFbS4MeA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 14:51 -0500, Ashay Rane wrote:
> The problem I am seeing is that the `perf record' output does not
> comform with the output of `perf stat'. For example, for `hackbench 10
> process 1000', I see 19 x 10^9 cycles reported by `perf stat'.
> However, `perf report -n' prints "Events: 2K cycles" and `perf report
> -n --dso hackbench' prints "Events: 47 cycles". 

Ah, read it as if perf report is saying: Samples: 47 of event: cycles.

That is, its telling you the cycles event had 47 overflows causing 47
samples to be taken (IP, etc..) and written out.

The point of reporting this number is that it puts the accuracy of the
percentages into perspective. The more samples, the greater the coverage
and more accurate the actual percentage of time spend in the various
functions.
