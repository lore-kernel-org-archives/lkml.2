Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1GUQiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:38:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33918 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847Ab1GUQiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:38:11 -0400
Date: Thu, 21 Jul 2011 17:37:57 +0100
From: Will Deacon <will.deacon@arm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
Message-ID: <20110721163757.GF8446@e102144-lin.cambridge.arm.com>
References: <4E1C0F02.9040906@redhat.com>
 <1310462046.14978.11.camel@twins>
 <4E1C10F8.6010300@redhat.com>
 <1310462335.14978.12.camel@twins>
 <4E1C1373.5080500@redhat.com>
 <1310463060.14978.17.camel@twins>
 <20110721153238.GC8446@e102144-lin.cambridge.arm.com>
 <4E28478B.1070907@redhat.com>
 <20110721154648.GD8446@e102144-lin.cambridge.arm.com>
 <4E284CC4.8060902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E284CC4.8060902@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 04:59:00PM +0100, Avi Kivity wrote:
> On 07/21/2011 06:46 PM, Will Deacon wrote:
> > >
> > >  This is (and must be) called from a preempt disabled context, no mutexes
> > >  around here.
> >
> > Bah, yes, that is essential if you're dealing with current. Maybe use a
> > spinlock instead?
> 
> Could work.  Not thrilled about adding it to the kvm hot path, but I 
> can't say it will make a measurable impact.

Understood, but at least it doesn't contribute to finish_task_switch. I also
wouldn't expect to have multiple preempt registrations in parallel for the
same task so that lock should rarely (if ever) be contended.

Will
