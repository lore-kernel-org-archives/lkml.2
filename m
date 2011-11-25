Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1KYKTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:19:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34241 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1KYKT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:19:29 -0500
Message-ID: <1322216360.2921.86.camel@twins>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Balbir Singh <bsingharora@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        jbottomley@parallels.com, fweisbec@gmail.com
Date: Fri, 25 Nov 2011 11:19:20 +0100
In-Reply-To: <CAKTCnznU1jA9ME2F12pPSLosi3=sbiHPikPd3UDon3arBK6XLQ@mail.gmail.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	 <1320182360-20043-15-git-send-email-glommer@parallels.com>
	 <4EBD94A0.9070703@google.com> <4EBE4A80.6090607@parallels.com>
	 <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
	 <CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>
	 <20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>
	 <4EC47632.2000904@parallels.com>
	 <CAKTCnznzpqUbMJEMwaewwjvMW1fG0J3=a8JxqKiHKNuffO7azg@mail.gmail.com>
	 <4EC52F32.2040708@parallels.com>
	 <20111121105957.9c85db16.kamezawa.hiroyu@jp.fujitsu.com>
	 <1322141073.2921.51.camel@twins> <4ECE6BC4.7090600@parallels.com>
	 <1322152152.2921.64.camel@twins> <4ECE731E.6030508@parallels.com>
	 <CAKTCnznU1jA9ME2F12pPSLosi3=sbiHPikPd3UDon3arBK6XLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-25 at 11:08 +0530, Balbir Singh wrote:
> It is not about $customer. I am OK with a design that allows
> accounting independent of control. Put it another way when I look at
> cgroups, I see the following functionality
> 
> 1. Accounting and feedback
> 2. Control
> 
> Why do 1 and 2 have to co-exist. A good case would be that we might
> need just stats and might want to implement control based on 1.

I would say that 2 always requires 1 (provided they are of course on the
same subject), for the very simple reason that you need to know the
current state (as provided by 1) to control it (2).

Therefore separating them leads to useless duplication.

> But if
> I have to do both 1 and 2 together, how do we decide on control
> values? 

Uh, what?

What was not answered is, is there a sane reason to have both on
different hierarchies? I think the whole different hierarchy per
controller thing is one of the biggest trainwrecks of cgroups.

It allows for great confusion, but I haven't yet seen an up-side to it.
