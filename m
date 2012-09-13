Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2IMCpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 22:45:00 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50417 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2IMCo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 22:44:58 -0400
X-AuditID: 9c93016f-b7b16ae000007205-7d-505148a70686
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Ingo Molnar <mingo@kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 2/3] perf: require exclude_guest to use PEBS - kernel side enforcement
References: <1347462990-29481-1-git-send-email-dsahern@gmail.com>
	<1347462990-29481-3-git-send-email-dsahern@gmail.com>
Date: Thu, 13 Sep 2012 11:38:08 +0900
In-Reply-To: <1347462990-29481-3-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Wed, 12 Sep 2012 09:16:29 -0600")
Message-ID: <87392mabqn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 12 Sep 2012 09:16:29 -0600, David Ahern wrote:
> From: Peter Zijlstra <peterz@infradead.org>
>
> Per Peter:
>   "Intel PEBS in VT-x context uses the DS address as a guest linear address,
>   even though its programmed by the host as a host linear address. This
>   either results in guest memory corruption and or the hardware faulting and
>   'crashing' the virtual machine.  Therefore we have to disable PEBS on VT-x
>   enter and re-enable on VT-x exit, enforcing a strict exclude_guest.
>
> This patch enforces exclude_guest kernel side.
>
[snip]
> @@ -380,6 +383,9 @@ int x86_pmu_hw_config(struct perf_event *event)
>  	if (event->attr.precise_ip) {
>  		int precise = 0;
>  
> +		if (!event->attr.exclude_guest)
> +				return -EOPNOTSUPP;

I see a whitespace problem here. :)

Thanks,
Namhyung


> +
>  		/* Support for constant skid */
>  		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
>  			precise++;
