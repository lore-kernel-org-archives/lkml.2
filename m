Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385Ab2DKOrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:47:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46108 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab2DKOrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:47:12 -0400
Date: Wed, 11 Apr 2012 11:47:16 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@redhat.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, fweisbec@gmail.com,
        eranian@google.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG PATCH] perf: kvm - finding struct machine fails for
 PERF_RECORD_MMAP
Message-ID: <20120411144716.GC16257@infradead.org>
References: <20120409081835.10576.22018.stgit@abhimanyu.in.ibm.com>
 <4F844ED5.6080608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F844ED5.6080608@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Apr 10, 2012 at 09:16:37AM -0600, David Ahern escreveu:
> On 4/9/12 2:22 AM, Nikunj A. Dadhania wrote:
> >Running 'perf kvm --host --guest --guestmount /tmp/guestmount record -a -g -- sleep 2'
> >
> >Was resulting in a segfault. For event type PERF_RECORD_MMAP,
> >event->ip.pid is being used in perf_session__find_machine_for_cpumode,
> >which is not correct.
> >
> >event->ip.pid happens to be 0 in this case and results in returning a
> >NULL machine object. Finally, access to self->pid in
> >machine__mmap_name, results in a segfault later.
> >
> >For PERF_RECORD_MMAP type, pass event->mmap.pid.
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>
> Tested-by: David Ahern <dsahern@gmail.com>

Thanks guys, applied this to my perf/urgent branch.

- Arnaldo
