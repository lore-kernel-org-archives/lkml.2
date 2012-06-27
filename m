Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab2F0QQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:16:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45826 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab2F0QQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:16:06 -0400
Date: Wed, 27 Jun 2012 13:15:57 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Jovi Zhang <bookjovi@gmail.com>,
        mingo@redhat.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: fix wrong hw_breakpoint documentation
Message-ID: <20120627161557.GA3878@infradead.org>
References: <CACV3sbKFcHgai6AzKGrf=LEb67VjZXjMUqMQuXAOUmby7CeiJg@mail.gmail.com>
 <87fw9hyvt5.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw9hyvt5.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jun 27, 2012 at 05:59:34PM +0900, Namhyung Kim escreveu:
> Hi, Jovi
> 
> On Wed, 27 Jun 2012 16:39:19 +0800, Jovi Zhang wrote:
> > From f5f9c3a064482cf3d0fb7ed788c66630bddbfc79 Mon Sep 17 00:00:00 2001
> > From: Jovi Zhang <bookjovi@gmail.com>
> > Date: Wed, 27 Jun 2012 16:09:21 +0800
> > Subject: [PATCH] perf: fix wrong hw_breakpoint documentation
> >
> > read-write access hw_breakpoint event is passed as 'mem:addr',
> > 'mem:0x1000:rw' is parsed as invalid argument currently.
> >
> 
> It should be a bug in event parser. I guess the patch below will fix it:

Jiri,

	Ack? If so, Namhyung, can you send a patch with his Ack?

- Arnaldo
 
> 
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index 488362e14133..aafca33a8a09 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -76,7 +76,7 @@ num_hex               0x[a-fA-F0-9]+
>  num_raw_hex    [a-fA-F0-9]+
>  name           [a-zA-Z_*?][a-zA-Z0-9_*?]*
>  modifier_event [ukhpGH]{1,8}
> -modifier_bp    [rwx]
> +modifier_bp    [rwx]+
>  
>  %%
>  
