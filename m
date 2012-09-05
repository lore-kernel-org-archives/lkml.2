Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab2IEWiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:38:55 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:39893 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab2IEWix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:38:53 -0400
Date: Wed, 5 Sep 2012 15:38:49 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 11/13] perf tools: replace mempcpy with memcpy
Message-ID: <20120905223849.GF8203@ghostprotocols.net>
References: <CANg8OWLDxZTrhJ-M2aeLdV-+y0VuGR+3iro179V=LLTeeQi_CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANg8OWLDxZTrhJ-M2aeLdV-+y0VuGR+3iro179V=LLTeeQi_CA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 29, 2012 at 01:06:04AM +0300, Irina Tirdea escreveu:
>    mempcpy is not supported by bionic in Android
>    and will lead to compilation errors.
> 
>    Replacing mempcpy with memcpy so it will work in Android.
> 
>    Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
>    ---
>     tools/perf/util/target.c |    4 ++--
>     1 file changed, 2 insertions(+), 2 deletions(-)
> 
>    diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
>    index 051eaa6..065528b 100644
>    --- a/tools/perf/util/target.c
>    +++ b/tools/perf/util/target.c
>    @@ -117,8 +117,8 @@ int perf_target__strerror(struct perf_target *target,
>    int errnum,
>     
>             if (err != buf) {
>                 size_t len = strlen(err);
>    -            char *c = mempcpy(buf, err, min(buflen - 1, len));
>    -            *c = '\0';
>    +            memcpy(buf, err, min(buflen - 1, len));
>    +            *(buf + min(buflen - 1, len)) = '\0';
>             }
>     

Can you resubmit this in txt form? I applied some other patches from you
but  you need to try to do it yourself, i.e. send just to you, then try
to save the patch and apply it...

- Arnaldo
