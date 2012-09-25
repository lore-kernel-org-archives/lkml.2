Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2IYCPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 22:15:44 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62647 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2IYCPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 22:15:43 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-08-506113cabce3
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: acme@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] perf header: Add check_perf_magic() func
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
	<1348500251-9937-8-git-send-email-feng.tang@intel.com>
Date: Tue, 25 Sep 2012 11:07:15 +0900
In-Reply-To: <1348500251-9937-8-git-send-email-feng.tang@intel.com> (Feng
	Tang's message of "Mon, 24 Sep 2012 23:24:09 +0800")
Message-ID: <87haqmyhws.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2012 23:24:09 +0800, Feng Tang wrote:
[snip]
> +/* Return 0 if matched */
> +int check_perf_magic(u64 magic)
> +{
> +	if (!memcmp(&magic, __perf_magic1, sizeof(magic))
> +		|| magic == __perf_magic2
> +		|| magic == __perf_magic2_sw)
> +		return 0;
> +
> +	return -1;
> +}

Just an idea.  How about returning version number instead of 0 so that
it can be used elsewhere those check is needed and possibly wants to
know the version number also?

Thanks,
Namhyung
