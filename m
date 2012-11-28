Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2K1Pk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:40:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab2K1Pk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:40:57 -0500
Date: Wed, 28 Nov 2012 16:40:38 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 25/32] tools, perf: Add a precise event qualifier
Message-ID: <20121128154038.GE1038@krava.brq.redhat.com>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
 <1352510868-7911-26-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352510868-7911-26-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 05:27:41PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a precise qualifier, like cpu/event=0x3c,precise=1/
> 
> This is needed so that the kernel can request enabling PEBS
> for TSX events. The parser bails out on any sysfs parse errors,
> so this is needed in any case to handle any event on the TSX
> perf kernel.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/parse-events.c |    6 ++++++
>  tools/perf/util/parse-events.h |    1 +
>  tools/perf/util/parse-events.l |    1 +
>  3 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index c0b785b..5b97a2b 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -526,6 +526,12 @@ do {								\
>  	case PARSE_EVENTS__TERM_TYPE_NAME:
>  		CHECK_TYPE_VAL(STR);
>  		break;
> +	case PARSE_EVENTS__TERM_TYPE_PRECISE:
> +		CHECK_TYPE_VAL(NUM);
> +		if ((unsigned)term->val.num > 2)
> +			return -EINVAL;

Should we test for >3?

	* precise_ip:
	*
	*  0 - SAMPLE_IP can have arbitrary skid
	*  1 - SAMPLE_IP must have constant skid
	*  2 - SAMPLE_IP requested to have 0 skid
	*  3 - SAMPLE_IP must have 0 skid

Maybe it's not implemented in hw yet, but in general it's allowed.

thanks,
jirka
