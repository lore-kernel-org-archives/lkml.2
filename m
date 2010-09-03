Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab0ICGcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:32:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41066 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0ICGcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 02:32:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: How can OOM killer detect process consuming much kernel memory?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, spender@grsecurity.net, eric.dumazet@gmail.com
In-Reply-To: <201009020633.DHJ01355.OQFMLtHSVOOJFF@I-love.SAKURA.ne.jp>
References: <201008302227.DJH30258.OQFMFtFJOOVSHL@I-love.SAKURA.ne.jp> <201009020633.DHJ01355.OQFMLtHSVOOJFF@I-love.SAKURA.ne.jp>
Message-Id: <20100903122536.3FC8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  3 Sep 2010 15:32:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is it possible to make OOM killer to kill processes consuming kernel memory
> rather than userspace memory?
> 
> I'm happy if OOM killer can select victim process based on both kernel memory
> usage and userspace memory usage. For example, opening a file requires kernel
> memory allocation (e.g. /sys/kernel/security/tomoyo/self_domain allocates 8KB
> of kernel memory). Therefore, I refuse allowing everybody to open that file
> even if the content is public (because an attacker would open
> /sys/kernel/security/tomoyo/self_domain as many as possible using
> fork() and open() in order to exhaust kernel memory).

Unfortunatelly, It's impossible. We have zero information which kernel
memory should be bound caller task. Almost all kernel memory are task
unrelated, so we can't bind them with caller task blindly.

Thanks.




