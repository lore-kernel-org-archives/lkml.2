Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2AXMua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 07:50:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab2AXMt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 07:49:59 -0500
Message-ID: <4F1EA8EE.9010007@redhat.com>
Date: Tue, 24 Jan 2012 14:49:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <4F13EE3D.2070602@linux.vnet.ibm.com> <4F13EEC5.8050807@linux.vnet.ibm.com> <4F13F631.9010804@redhat.com> <4F14DD39.5000703@linux.vnet.ibm.com>
In-Reply-To: <4F14DD39.5000703@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 04:30 AM, Xiao Guangrong wrote:
> On 01/16/2012 06:04 PM, Avi Kivity wrote:
>
> > On 01/16/2012 11:32 AM, Xiao Guangrong wrote:
> >> Add 'perf kvm-events' support to analyze kvm vmexit/mmio/ioport smartly
> >>
> >> Usage:
> >> 	perf kvm-events record
> > 
> > Why not 'perf record -e kvm'?
>
>
> It works, many perf tools have this style, like:
> perf lock record,
> perf sched record,
> perf kmem record,
>
> I think the reason is that only enable the tracepoints we need to avoid
> unnecessary overload so that the result is more exacter.

Maybe a virtual event list:

  perf record -e kvm-pio

This allows us to combine the event list with other events:

  perf record -e kvm-pio -e timer


> >> +
> >> +	while (table_size--) {
> >> +		if (table->exit_code == exit_code)
> >> +			return table->reason;
> > 
> > ... table[exit_code] ...
> > 
>
>
> Actually, this array is not indexed by exit_code, it means:
> table[exit_code].exit_code != exit_code.

So make it indexed by exit code.



-- 
error compiling committee.c: too many arguments to function

