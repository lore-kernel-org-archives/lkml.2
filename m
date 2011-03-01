Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab1CAPLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:11:44 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37192 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab1CAPLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:11:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hes8IR7zlxt2jP3JY1WLeZU1f3JQQ1xiHdhZHmpEFLjBS5c4idyEpuet8Cemsl2V95
         9EfyOfuDx9/Xmrhq81gDiUPAEhgv4MsaIqhO4CKuUQUbjfLNDGP0gebLbEMrHJa5hV8f
         +CvyNtToN0ehgimo9CUdulEz+7PTDK05Emop4=
MIME-Version: 1.0
In-Reply-To: <4D6D004F.5010602@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
	<1298865151-23656-5-git-send-email-daahern@cisco.com>
	<AANLkTikwsuBGVfB6uu7=H0jbL+2YbbvX=ea6rLwNP8w-@mail.gmail.com>
	<4D6D004F.5010602@cisco.com>
Date: Tue, 1 Mar 2011 16:11:40 +0100
Message-ID: <AANLkTi=jmS80Rs13QiTmdA5iUXvNaSKxQ9Gpp2P2nqRU@mail.gmail.com>
Subject: Re: [PATCH 4/6] perf script: dump software events too
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/1 David Ahern <daahern@cisco.com>:
> I don't follow what you mean.
>
> This is the same place that tracepoints are dumped. In the
> PERF_TYPE_TRACEPOINT case process_event == print_event which dumps the
> lines to stdout.

No it's not. scripting_ops can be either default_scripting_ops,
perl_scripting_ops
or python_scripting_ops.

Hence process_sample_event() doesn't necessarily ends up pretty print events.
It can also invoke a script that may decide to do what it wants with events.

pretty printing must be an endpoint decision.

> I came in added a switch that invokes a different handler for software
> events. Software events will be processed differently than tracepoint.
> The print_event function and its pretty_print function are not designed
> to dump software events (and eventually hardware events).

Why shouldn't it be designed to dump software events? It's called print_event().
Its current version is rather something I would call "limited". But it
was not designed
to be limited.

Ideally, we should have print_tracepoint_event() in
trace-event-parse.c, print_software_event()
where you want, and have print_event() in builtin-script.c that wraps on those.
