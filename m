Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1GLJzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:55:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:49142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1GLJzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:55:17 -0400
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
In-Reply-To: <4E1C10F8.6010300@redhat.com>
References: <1309362157-6596-1-git-send-email-avi@redhat.com>
	 <1309362157-6596-2-git-send-email-avi@redhat.com>
	 <20110629160841.GA2032@somewhere>
	 <20110629162725.GH15521@e102144-lin.cambridge.arm.com>
	 <20110704135820.GD5551@somewhere> <4E11C9CC.2070909@redhat.com>
	 <20110704143655.GE5551@somewhere>
	 <20110711210753.GA3582@e102144-lin.cambridge.arm.com>
	 <4E1BF5A1.5070301@redhat.com> <1310459898.18678.108.camel@twins>
	 <4E1C0F02.9040906@redhat.com> <1310462046.14978.11.camel@twins>
	 <4E1C10F8.6010300@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Jul 2011 11:18:55 +0200
Message-ID: <1310462335.14978.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 12:16 +0300, Avi Kivity wrote:
> On 07/12/2011 12:14 PM, Peter Zijlstra wrote:
> > On Tue, 2011-07-12 at 12:08 +0300, Avi Kivity wrote:
> > >  Similar, but with stronger guarantees: when the function is called,
> > >  current == p, and the task was either sleeping or in userspace.
> >
> > If the task is sleeping, current can never be p.
> 
> The guarantee is that the task was sleeping just before the function is 
> called.  Of course it's woken up to run the function.
> 
> The idea is that you run the function in a known safe point to avoid 
> extra synchronization.
> 

I'd much rather we didn't wake the task and let it sleep, that's usually
a very safe place for tasks to be. All you'd need is a guarantee it
won't be woken up while you're doing your thing.
