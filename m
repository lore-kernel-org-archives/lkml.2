Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2BXA3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:29:36 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35879 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2BXA3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:29:35 -0500
Message-ID: <1330043325.2340.290.camel@work-vm>
Subject: Re: [tip:timers/core] clocksource: scx200_hrt: Fix the build
From: John Stultz <john.stultz@linaro.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jim.cromie@gmail.com, tglx@linutronix.de, mingo@elte.hu
Date: Thu, 23 Feb 2012 16:28:45 -0800
In-Reply-To: <tip-jceb26fns5w7tv8edlivhxpa@git.kernel.org>
References: <tip-jceb26fns5w7tv8edlivhxpa@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022400-3270-0000-0000-0000044668BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 08:13 -0800, tip-bot for Ingo Molnar wrote:
> Commit-ID:  10ea9d6f5663c3ed51f91cd037b4b9b147273cbb
> Gitweb:     http://git.kernel.org/tip/10ea9d6f5663c3ed51f91cd037b4b9b147273cbb
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Wed, 22 Feb 2012 13:19:37 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 22 Feb 2012 13:25:16 +0100
> 
> clocksource: scx200_hrt: Fix the build
> 
> This commit:
> 
>   12d6d41276de: clocksource: scx200_hrt: Convert scx200 to use clocksource_register_hz
> 
> Breaks the build on x86-32:
> 
>   drivers/clocksource/scx200_hrt.c: In function ‘init_hrt_clocksource’:
>   drivers/clocksource/scx200_hrt.c:95:0: error: unterminated argument list invoking macro "pr_info"
>   drivers/clocksource/scx200_hrt.c:84:2: error: ‘pr_info’ undeclared (first use in this function)
> 
> It could not possibly have been build tested, because it had this mismerge:
> 
> 	pr_info("enabling scx200 high-res timer (%s MHz +%d ppm)\n",
> 	printk(KERN_INFO "enabling scx200 high-res timer (%s MHz +%d ppm)\n",
> 		mhz27 ? "27":"1", ppm);

Yea, looking in my git logs, that was me. Sorry about that.
Thanks for catching it and fixing it up. 
-john

