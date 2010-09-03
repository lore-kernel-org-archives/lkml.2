Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0ICVKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:10:24 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9365 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0ICVKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:10:24 -0400
Message-ID: <4C81643F.5070801@caviumnetworks.com>
Date: Fri, 03 Sep 2010 14:10:23 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Arthur Kepner <akepner@sgi.com>
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [RFC/PATCH] notify user-level IRQ balancer when kernel assigns
 IRQ	affinity
References: <20100903210554.GO2464@sgi.com>
In-Reply-To: <20100903210554.GO2464@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2010 21:10:23.0643 (UTC) FILETIME=[6C77A6B0:01CB4BAC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 02:05 PM, Arthur Kepner wrote:
>
> We've run into situations where a CPU runs out of interrupt
> vectors, because all the interrupts are getting the default
> affinity (and the interrupt balancer hasn't yet run).
>
> The following emits a netlink message whenever an interrupt
> is given a default CPU affinity. A user-level IRQ balancer
> can use those messages to decide if, and how to reassign
> affinities. This should allow us to avoid running out of
> vectors on any particular CPU (or at least make it far less
> likely).
>
> I know this needs work, but would like to get comments on
> the idea before doing more coding and testing.
>
>
> Signed-off-by: Arthur Kepner<akepner@sgi.com>
>
> ---
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 4877a8c..65c79c7 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -158,4 +158,15 @@ config HAVE_PERF_EVENTS_NMI
>   	  subsystem.  Also has support for calculating CPU cycle events
>   	  to determine how many clock cycles in a given period.
>
> +config NOTIFY_USER_IRQ_BALANCER
> +	bool "Notify user-level IRQ balancer (EXPERIMENTAL)"
> +	default n
> +	depends on NET&&  X86

Missing a space before that '&&', but more importantly, what part of the 
patch is x86 specific?


David Daney


