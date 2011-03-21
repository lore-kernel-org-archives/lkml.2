Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1CURF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:05:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61896 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1CURF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=umsArokvEhsRE+X224iDLpK4biHv8P7OTi83FkV3YWXe5bJmmYDfIXZaZRg1vl+5mG
         3iJFKSkLg+st0ZNzIIs41iOXDaSUC7B9roKjziR43TodNaGOPb21YnDNjP7Wmrqn2zrd
         RV9DudALxhgJdvLSTVdgsn9Iq/RbshfpjJjrM=
Message-ID: <4D878445.6090709@gmail.com>
Date: Mon, 21 Mar 2011 20:00:53 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Jack Steiner <steiner@sgi.com>
CC: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com> <4D878042.9080708@gmail.com>
In-Reply-To: <4D878042.9080708@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 07:43 PM, Cyrill Gorcunov wrote:
...
> 
> I think Jack might need to setup priority for his notifier, like
> 
> static struct notifier_block uv_dump_stack_nmi_nb = {
> 	.notifier_call	= uv_handle_nmi,
> 	.priority	= NMI_LOCAL_HIGH_PRIOR+1,
> };
> 
> so it would be called before perf nmi. Don, am I right?
> 
> Since for perf nmis we do have
> 
> static __read_mostly struct notifier_block perf_event_nmi_notifier = {
> 	.notifier_call		= perf_event_nmi_handler,
> 	.next			= NULL,
> 	.priority		= NMI_LOCAL_LOW_PRIOR,
> };
> 

  I must admit I've missed the fact that Jack has tried NMIs priorities, right?
x86_platform_ops seems to be a cleaner indeed (btw I think p4 pmu kgdb issue
is exactly the same problem) but same time this might end up in over-swelled
ideas behind this small code snippet. Dunno. Probably we need some per-cpu
system status for nmi reasons other than unknown nmis...

-- 
    Cyrill
