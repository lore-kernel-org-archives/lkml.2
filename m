Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2L1Wzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 17:55:53 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48539 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163Ab2L1Wzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 17:55:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: viresh kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix problem with cpufreq_pndemand or cpufreq_conservative
Date: Sat, 29 Dec 2012 00:01:16 +0100
Message-ID: <3226192.H2BxHSuKio@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <50DE1A74.4040607@lwfinger.net>
References: <50DE1A74.4040607@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 28, 2012 04:17:24 PM Larry Finger wrote:
> Since commit 2aacdff entitled "cpufreq: Move common part from governors to 
> separate file", whenever the drivers that depend on this new file 
> (cpufreq_ondemand or cpufreq_conservative) are built as modules, a new module 
> named cpufreq_governor is created. It seems that kmake is smart enough to create 
> a separate module whenever more than one module includes the same object file. 
> As drivers/cpufreq/cpufreq_governor.c contains no MODULE directives, the 
> resulting module has no license specified, which results in logging of a "module 
> license 'unspecified' taints kernel". In addition, a number of globals are 
> exported GPL only, and are therefore not available.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> This particular patch is the simplest possible; however, it hides the intent. I 
> have prepared the longer version that makes the reason clearer by adding a new 
> configuration variable that is dependent on the other two, and rearranges 
> drivers/cpufreq/Makefile. That version could be submitted if that is what is 
> desired.

Yes, please.

> The changes to cpufreq_governor.c are the same as in this version.

I wonder if that's avoidable?  The intention is not to create an additional
module, clearly.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
