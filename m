Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab2J0TdO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 15:33:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596Ab2J0TdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 15:33:13 -0400
Date: Sat, 27 Oct 2012 21:32:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        eranian@google.com, mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 25/33] perf, tools: Support events with - in the name
Message-ID: <20121027193258.GB1039@krava.redhat.com>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
 <1351283415-13170-26-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351283415-13170-26-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:30:07PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> - looks nicer than _, so allow - in the event names. Used for various
> of the arch perfmon and Haswell events.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/parse-events.l |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index c87efc1..ef602f0 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -80,7 +80,7 @@ event		[^,{}/]+
>  num_dec		[0-9]+
>  num_hex		0x[a-fA-F0-9]+
>  num_raw_hex	[a-fA-F0-9]+
> -name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
> +name		[a-zA-Z_*?][a-zA-Z0-9\-_*?]*

this breaks cache events parsing since they are '-' separated
and having '-' in 'name' patern will endup with PE_NAME
being matched instead of  PE_NAME_CACHE_* terms

I guess you want '-' being used within 'cpu/..t=v../' terms right?
That could be done via start conditions '%x'

jirka
