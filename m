Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab1CYPDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:03:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:33555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab1CYPDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:03:05 -0400
Subject: Re: [PATCH] perf: Better fit max unprivileged mlock pages for
 tools needs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Han Pingtian <phan@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Stable <stable@kernel.org>
In-Reply-To: <AANLkTinB2EAh=mpqh-y4=5xKPdyJWwUWFVMk=WAx1QBp@mail.gmail.com>
References: <1300904979-5508-1-git-send-email-fweisbec@gmail.com>
	 <1301049130.2250.185.camel@laptop>
	 <AANLkTinB2EAh=mpqh-y4=5xKPdyJWwUWFVMk=WAx1QBp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 16:05:12 +0100
Message-ID: <1301065512.2250.223.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 15:50 +0100, Frederic Weisbecker wrote:
> 2011/3/25 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > On Wed, 2011-03-23 at 19:29 +0100, Frederic Weisbecker wrote:
> >
> >> -int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
> >> +/* Minimum for 128 pages + 1 for the user control page */
> >> +int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
> >
> > This assumes PAGE_SIZE = 4k..
> 
> Yeah, should I rebase the value on top of PAGE_SIZE?

Possibly yeah, I guess that when the base page size if 64k you really
can't do anything about wasting the whole first page, comes with the
territory.

