Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1DUP1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:27:36 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44184 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab1DUP1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TpdOR6bFe3gRyzfe6gtaETEozTBuGDKmLWW0m/AA6M/Nk5fscLJFaGDDx2lImto1P6
         BPBMJrFCx2xpevGFqY+Og9OjsE+iCOGQmwGSMl/II5xdpvMVmMziDU0hmGBCUfBpLUSO
         MHzgHnNrv/qa7qBb415XWLqRzdsH4drrU2Vq4=
Date: Thu, 21 Apr 2011 17:27:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC,PATCH 0/3] trace,perf: enabling ftrace/function tracepoint
Message-ID: <20110421152724.GB1772@nowhere>
References: <1303382458-11072-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303382458-11072-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 12:40:55PM +0200, Jiri Olsa wrote:
> hi,
> 
> this is just RFC patch with patche series showing the
> direction I'm taking.. _RFC_ ;)
> 
> I was discussing with Frederic the possibility to have function trace
> available for perf processing, and the possibility to have it used
> as starting/stopping events, and probably more.
> 
> The 1st 2 patches adding the registration function for the
> ftrace/function tracepoint to be usable by both trace and perf
> via tracepoint interface.
> 
> The 3rd patch is the biggest hack and is trying to add filtering
> support.  I'm currently looking on the filtering code to come up
> with some better idea of hooking this type of filtering in.
> 
> attached patches:
> 1/3 - add support for enabling ftrace/function tracepoint event
> 2/3 - add support for registering ftrace/function tracepoint event via perf
> 3/3 - add filter support for ftrace/function tracepoint event
> 
> I could read perf counts from ftrace/function tracepoint using
> attached program.
> 
> Any thoughts/ideas about this direction or projecting some other
> would be just great :)
> 
> 
> thanks a lot,
> jirka

So the direction is kinda good but the thing needs to be unglobalized
(if that word ever exists). Filters need to apply individually to
each users of the function tracer, that's the trickiest part.

We also need to catch up with set_ftrace_filter and set_ftrace_notrace
using filters and triggers, so that we can get rid of the global files
in the end and have only local effects (per perf_event/ftrace).

But that's a good start.

Thanks.
