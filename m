Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2DXQx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:53:56 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:50440
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755504Ab2DXQxz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:53:55 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zzc89bh1432N98dK4015Izz1202hzz8275bhz2dh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2ZTLI-02-CYU-02
X-M-MSG: 
Date: Tue, 24 Apr 2012 18:53:44 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] perf tools: Fix include header files in
 util/parse-events.h
Message-ID: <20120424165344.GH9747@erda.amd.com>
References: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
 <1333643188-26895-2-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1333643188-26895-2-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.04.12 18:26:25, Robert Richter wrote:
> Include header fixes for
> 
> ... bool:
> 
>  util/parse-events.h:31: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘have_tracepoints’
> 
> ... and types.h:
> 
>  util/parse-events.h:28: error: expected ‘)’ before ‘config’
>  util/parse-events.h:34: error: expected declaration specifiers or ‘...’ before ‘u64’
>  util/parse-events.h:45: error: expected ‘)’ before ‘type’
> 
> This happens if now other include files are included before
> util/parse-events.h.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>

Arnaldo,

is it your intention that you didn't apply this patch?

Thanks,

-Robert

> ---
>  tools/perf/util/parse-events.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index 6d7c74b..ab6ebe0 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -4,7 +4,9 @@
>   * Parse symbolic events/counts passed in as options:
>   */
>  
> +#include <stdbool.h>
>  #include "../../../include/linux/perf_event.h"
> +#include "types.h"
>  
>  struct list_head;
>  struct perf_evsel;
> -- 
> 1.7.8.4
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

