Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0LJLM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:12:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:38776 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0LJLMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:12:25 -0500
Message-ID: <4D020B22.1030701@kernel.org>
Date: Fri, 10 Dec 2010 12:12:34 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org
Subject: Re: [PATCH 07/16] x86: Remove custom apic->cpu_to_logical_apicid()
 implementations
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-8-git-send-email-tj@kernel.org> <alpine.LFD.2.00.1012092217000.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012092217000.2653@localhost6.localdomain6>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Dec 2010 11:11:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On 12/09/2010 10:28 PM, Thomas Gleixner wrote:
>> After the previous patch, apic->cpu_to_logical_apicid() is no longer
>> used.  The callback will be repurposed.  Remove all the custom
> 
> That's a very bad idea. You remove the callbacks from the esoteric
> platforms, but you keep the other implementation in the tree.
>
> It's not longer used now, so remove all incarnations and get rid of
> all those useless = NULL initializations at the same time. Then
> implement a new callback with a different name.

Yeah, that would be cleaner.  I wasn't very sure about clearing
unimplemented apic ops.  Currently the rule seems to be always setting
them to NULL and I didn't want to re-do that with a new callback.

> It's slightly more work and code churn, but it makes the change
> entirely clear. It'd be also nice to annotate in the function name
> that this is 32bit only or even make it 32bit dependent if it's not
> too much ifdeffery

Yeah, sure, if the silly NULL assignments aren't necessary, I don't
think it would be much more churn anyway.

Thanks.

-- 
tejun
