Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1FITdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:33:05 -0400
Received: from outmail004.snc4.facebook.com ([66.220.144.136]:62122 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754696Ab1FITdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:33:02 -0400
Date: Thu, 9 Jun 2011 12:33:00 -0700
From: Arun Sharma <asharma@fb.com>
To: Sam Liao <phyomh@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [perf] Add inverted call graph report support.
Message-ID: <20110609193300.GA16858@dev1756.snc6.facebook.com>
References: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 02:44:19PM +0800, Sam Liao wrote:
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -247,9 +247,14 @@ int perf_session__resolve_callchain(struct
> perf_session *self,
>  	callchain_cursor_reset(&self->callchain_cursor);
> 
>  	for (i = 0; i < chain->nr; i++) {
> -		u64 ip = chain->ips[i];
> +		u64 ip;
>  		struct addr_location al;
> 
> +		if (callchain_param.order == ORDER_CALLEE)
> +			ip = chain->ips[i];
> +		else
> +			ip = chain->ips[chain->nr - i - 1];

This can dereference a bad pointer if chain->nr == 0.

 -Arun
