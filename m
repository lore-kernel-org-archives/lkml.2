Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab1BDGkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 01:40:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33463 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab1BDGkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 01:40:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Americo Wang <xiyou.wangcong@gmail.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Cc: kosaki.motohiro@jp.fujitsu.com, Vivek Goyal <vgoyal@redhat.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <20110204032836.GB13902@cr0.redhat.com>
References: <20110204025041.GB30087@redhat.com> <20110204032836.GB13902@cr0.redhat.com>
Message-Id: <20110204153948.17D9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  4 Feb 2011 15:40:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Secondly now the question of whether kdump_msg() call should be before
> >crash_kexec() or not because modules might want to do lots of unreliable
> >things, I am now split on that. Especially because of the fact that if
> >somebody wants it probably can use kprobe to hook into crash_kexec()
> >or panic() or something like that to execute its code before everything
> >else.
> 
> If kprobe is the reason, then probably we can remove lots of other
> kernel API's like kmsg dumper.

Really?

On enterprise, distro kernel has CONFIG_KPROBE=y. It has both pros and cons, 
pros) kprobe can provide alternative hooking way therefore kmsg dump is not 
must.  cons) even if we remove kmsg dump, we can't get full kernel control. 
kprobe can inject unrealiable code. It's two sides of the same coin. But, 
many embedded don't have kprobe feature, therefore kprobe can't be 
alternative of kmsg dumper.



