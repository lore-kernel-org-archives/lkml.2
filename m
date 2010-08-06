Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935199Ab0HFB6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:58:13 -0400
Received: from mail.perches.com ([173.55.12.10]:2298 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934560Ab0HFB6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:58:11 -0400
Subject: Re: [PATCH 05/10] perf hists: Fixup addr snprintf width on 32 bit
 arches
From: Joe Perches <joe@perches.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <1281059177-18747-6-git-send-email-acme@infradead.org>
References: <1281059177-18747-1-git-send-email-acme@infradead.org>
	 <1281059177-18747-6-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 18:58:07 -0700
Message-ID: <1281059887.19943.23.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 22:46 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> By using BITS_PER_LONG/4 as the width specifier.
[]
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 1c61a4f..b62a553 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
[]
> -		ret += repsep_snprintf(bf, size, "%#018llx %c ", self->ip, o);
> +		ret += repsep_snprintf(bf, size, "%*Lx %c ",
> +				       BITS_PER_LONG / 4, self->ip, o);
[]
> -		ret += repsep_snprintf(bf + ret, size - ret, "%#016llx", self->ip);
> +		ret += repsep_snprintf(bf + ret, size - ret, "%*Lx",
> +				       BITS_PER_LONG / 4, self->ip);

This drops leading 0's.


