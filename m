Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779Ab2ILOyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:54:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52592 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443Ab2ILOyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:54:23 -0400
Message-ID: <5050A21A.3030102@gmail.com>
Date: Wed, 12 Sep 2012 08:54:18 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Stop perf stat -p when profiled process
 exits v2
References: <1347460832-32118-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1347460832-32118-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/12 8:40 AM, Andi Kleen wrote:
> -		while(!done) sleep(1);
> +		char piddir[40];
> +		if (target.pid && access("/proc", X_OK) == 0)
> +			snprintf(piddir, sizeof piddir, "/proc/%d", atoi(target.pid));

else path has piddir not set. Also as Namyhung pointed out target.pid 
can have multiple pids in it, so this fails if a user specified -p 
pid1,pid2 -- it will only check if the first process died.

Perhaps a more generic perf_target__is_alive function is needed that can 
check if the given tid(s) or pid(s) have terminated.

David
