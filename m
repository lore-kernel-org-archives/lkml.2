Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1GLJov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:44:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab1GLJot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:44:49 -0400
Message-ID: <4E1C1771.9010300@redhat.com>
Date: Tue, 12 Jul 2011 12:44:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Will Deacon <will.deacon@arm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
References: <20110704143655.GE5551@somewhere> <20110711210753.GA3582@e102144-lin.cambridge.arm.com> <4E1BF5A1.5070301@redhat.com> <1310459898.18678.108.camel@twins> <4E1C0F02.9040906@redhat.com> <1310462046.14978.11.camel@twins> <4E1C10F8.6010300@redhat.com> <1310462335.14978.12.camel@twins> <4E1C1373.5080500@redhat.com> <1310463060.14978.17.camel@twins> <20110712094131.GA29812@8bytes.org>
In-Reply-To: <20110712094131.GA29812@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 12:41 PM, Joerg Roedel wrote:
> >  Using TIF_bits sounds like a much better solution for this, wakeups are
> >  really rather expensive and its best to avoid extra if at all possible.
>
> I would rather vote for Avi's solution too. Such a functionality is very
> helpful for LWP-perf integration as well (because we need a way to call
> do_mmap for a task != current).
>

It's not needed for that.  See use_mm() (caller must be a kernel thread).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

