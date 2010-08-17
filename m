Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0HQCho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:37:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46250 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab0HQChn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:37:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causes hibernationto hang
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4C677A49.4030904@superonline.com>
References: <4C677A49.4030904@superonline.com>
Message-Id: <20100817113401.5F77.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Aug 2010 11:37:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello all,
> 
> I am using Debian Sid on a Toshiba Satellite A100 laptop. After testing
> 2.6.35 for a while, I noticed that sometimes my hibernation attempts
> would fail. I should say that I never had such a problem before 2.6.35.
> The hibernation process hangs with 2.6.35 after printing the following:
> 
> === 8< ===
> ...
> Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> PM: Preallocating image memory...
> === >8 ===
> 
> After a short investigation, I found out that this only happens when my
> tmpfs filesystem on /tmp had a lot of data in it. When my tmpfs is empty,
> I have no problems.
> 
> So I wrote a short script which fills up the tmpfs on /tmp and tries to
> hibernate, and I bisected the kernel using this script.
> 
> The end result is that the following commit causes this regression:
> 
> === 8< ===
> commit bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
> Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date:   Fri Jun 4 14:15:05 2010 -0700
> 
>     vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure
> 
>     ...
> === >8 ===
> 
> I have run 2.6.35-rc6, 2.6.35 and 2.6.35.1 with this commit reverted,
> and I am happy to say that I haven't experienced any problems for at
> least 17 days.
> 
> It looks like this change was included with 2.6.35-rc1. I am sorry
> for not testing earlier.
> 
> I am willing to do testing in case anyone would like me to try patches.

Wow.

I'm very surprised this report because 1) the above commit changed
do_try_to_free_pages() return value 2) but current hibernation code is
ignoring this return value. Hmm... I have to investigate this very
interesting issue.

Thanks this report, and please give me a bit time.



