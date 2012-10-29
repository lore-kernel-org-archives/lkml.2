Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab2J2KUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:20:04 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47964 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444Ab2J2KUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:20:01 -0400
X-AuditID: 9c930179-b7c8bae000003559-33-508e584f766a
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jolsa@redhat.com, eranian@google.com, mingo@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 10/33] perf, tools: Add abort,notx,intx branch filter options to perf report -j v2
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
	<1351283415-13170-11-git-send-email-andi@firstfloor.org>
Date: Mon, 29 Oct 2012 19:19:59 +0900
In-Reply-To: <1351283415-13170-11-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 26 Oct 2012 13:29:52 -0700")
Message-ID: <87zk357f74.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just minor nitpicks..


On Fri, 26 Oct 2012 13:29:52 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Make perf report -j aware of the new intx,notx,abort branch qualifiers.

s/report/record/

The same goes to the subject line too.

>
> v2: ABORT -> ABORTTX
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Documentation/perf-record.txt |    3 +++
>  tools/perf/builtin-record.c              |    3 +++
>  2 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index b38a1f9..4b9f477 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -172,6 +172,9 @@ following filters are defined:
>          - u:  only when the branch target is at the user level
>          - k: only when the branch target is in the kernel
>          - hv: only when the target is at the hypervisor level
> +	- intx: only when the target is in a hardware transaction
> +	- notx: only when the target is not in a hardware transaction
> +	- aborttx: only when the target is a hardware transaction abort

Mixed tabs and spaces for indentation.


>  
>  +
>  The option requires at least one branch type among any, any_call, any_ret, ind_call.
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index e9231659..88ecbbd 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -725,6 +725,9 @@ static const struct branch_mode branch_modes[] = {
>  	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
>  	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
>  	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
> +	BRANCH_OPT("aborttx", PERF_SAMPLE_BRANCH_ABORTTX),
> +	BRANCH_OPT("intx", PERF_SAMPLE_BRANCH_INTX),
> +	BRANCH_OPT("notx", PERF_SAMPLE_BRANCH_NOTX),

How about make them abort_tx, in_tx and no_tx?  I often read them like
int_x and not_x. ;)

Thanks,
Namhyung


>  	BRANCH_END
>  };
