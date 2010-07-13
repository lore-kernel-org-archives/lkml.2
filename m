Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab0GMTEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 15:04:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:41288 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab0GMTEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 15:04:54 -0400
Message-ID: <4C3CB8D1.4030904@windriver.com>
Date: Tue, 13 Jul 2010 14:04:49 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdb: ll command won't terminate
References: <E1OYkaV-0006KK-2k@eag09.americas.sgi.com>
In-Reply-To: <E1OYkaV-0006KK-2k@eag09.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2010 19:04:50.0544 (UTC) FILETIME=[44E8F700:01CB22BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This particular patch is already in the queue and will be in a pull
request very soon.

There are several 1-3 line regression fixes that have been found since
the kdb merge in 2.6.35.

Jason.

On 07/13/2010 01:52 PM, Cliff Wickman wrote:
>
> Hi Jason,
>
> A question, please, about a patch similar to the below that Martin Hicks
> sent, around 5/26/2010.
>
> Martin is on vacation, and suse is wondering whether the below change
> is queued for 2.6.35.  I can't find anything about it.  Could you tell me
> its status?
>
> Thanks.
>
> -Cliff
>
>
> Signed-off-by: Martin Hicks <mort@sgi.com>
> ---
>  kernel/debug/kdb/kdb_main.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> Index: linux-2.6/kernel/debug/kdb/kdb_main.c
> ===================================================================
> --- linux-2.6.orig/kernel/debug/kdb/kdb_main.c
> +++ linux-2.6/kernel/debug/kdb/kdb_main.c
> @@ -2291,6 +2291,9 @@ static int kdb_ll(int argc, const char *
>  	while (va) {
>  		char buf[80];
>  
> +		if (KDB_FLAG(CMD_INTERRUPT))
> +			return 0;
> +
>  		sprintf(buf, "%s " kdb_machreg_fmt "\n", command, va);
>  		diag = kdb_parse(buf);
>  		if (diag)
>   

