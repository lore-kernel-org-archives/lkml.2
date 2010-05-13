Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab0EMO6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:58:34 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:44659 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0EMO6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=itiof+6sznLRZtx8krXJHNLL7q1BXoFAikd0WO6UoXx7L24zPIsTcdZZgj5QCoDQoy
         ZjloeVfCA+fhr3C8ZFapxnBrh+9OJg1zbY81s0nIfF3wfIcFsh6+PzrOGDFgMPWyR+V2
         XM0UruIs5CQoILjQH8sa2KddVDAvAozguTZxw=
Date: Thu, 13 May 2010 11:58:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: perf: relative path to source for perf probe?
Message-ID: <20100513145826.GJ30926@ghostprotocols.net>
References: <AANLkTins2yCK-rvmdaaSQoBum4haHLhPx34EeJDg21Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTins2yCK-rvmdaaSQoBum4haHLhPx34EeJDg21Gg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 13, 2010 at 04:13:41PM +0200, Chase Douglas escreveu:
> I'm trying to play with perf probe to insert trace events into a
> running kernel, but I haven't found a way to specify relative
> pathnames. For example, our build machines for Ubuntu build the kernel
> inside /build/buildd/linux-2.6.34. If I want to use perf probe, it
> seems I need to ensure the source exists in exactly the same location
> on my machine.
> 
> Compare this to gdb, where I can put the source at
> /home/cndougla/perf/build/buildd/linux-2.6.34 and specify a relative
> path for sources of /home/cndougla/perf using the dir command. I have
> read the perf code and I have not found any way to do this. I would be
> interested in adding support for this as a cmd line option, but I'm
> not very familiar with the rest of perf. Is this functionality
> specific to perf-probe? Should this be in some logic in util/ or in
> builtin-probe.c?

Look in tools/perf/util/symbol.c, these variables are the ones tools use
to govern how the symbol system work wrt finding vmlinux:

symbol_conf.use_vmlinux_path
symbol_conf.vmlinux_name

In addition to this it will use what is in ~/.debug/ if it has a
build-id in the perf.data header.

The changes for support kvm also touched this and allow for some
prefixing to look for guest symbols, generalizing that to make guest
kernel vmlinux + modules relative location be reused to look for
relative location for host kernel vmlinux + modules seems the way to go.

Probably you won't find this if you look at the old 2.6.34 codebase
(yay, for tools/perf it is already hundreds of patches behind :-)), so
I recomend you look at what we have in linux-2.6-tip, branch
tip/perf/core, what is in 2.6.34 is in tip/perf/urgent and right now,
IIRC, just a one patch that is not in 2.6.34 proper, a cherry-pick from
tip/perf/core, no less :-)

- Arnaldo
