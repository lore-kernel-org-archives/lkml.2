Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab1K1I3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 03:29:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63801 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1K1I3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 03:29:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM31RLcUUzCXqfrALgAc0g_A0uOq-Htaz50vcpqoo83Nc0tpA@mail.gmail.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	<1320182360-20043-15-git-send-email-glommer@parallels.com>
	<4EBD94A0.9070703@google.com>
	<4EBE4A80.6090607@parallels.com>
	<CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
	<CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>
	<20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>
	<4EC47632.2000904@parallels.com>
	<CAKTCnznzpqUbMJEMwaewwjvMW1fG0J3=a8JxqKiHKNuffO7azg@mail.gmail.com>
	<4EC52F32.2040708@parallels.com>
	<20111121105957.9c85db16.kamezawa.hiroyu@jp.fujitsu.com>
	<1322141073.2921.51.camel@twins>
	<4ECE6BC4.7090600@parallels.com>
	<1322152152.2921.64.camel@twins>
	<4ECE731E.6030508@parallels.com>
	<CAKTCnznU1jA9ME2F12pPSLosi3=sbiHPikPd3UDon3arBK6XLQ@mail.gmail.com>
	<1322216360.2921.86.camel@twins>
	<CAPM31RLcUUzCXqfrALgAc0g_A0uOq-Htaz50vcpqoo83Nc0tpA@mail.gmail.com>
Date: Mon, 28 Nov 2011 13:59:29 +0530
Message-ID: <CAKTCnz=Xk7fsvF6asN4v6m5ma4-B38a5+FGRNOmhr+ftGpxPmA@mail.gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
From: Balbir Singh <bsingharora@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 6:48 PM, Paul Turner <pjt@google.com> wrote:
> On Fri, Nov 25, 2011 at 2:19 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> On Fri, 2011-11-25 at 11:08 +0530, Balbir Singh wrote:
>>> It is not about $customer. I am OK with a design that allows
>>> accounting independent of control. Put it another way when I look at
>>> cgroups, I see the following functionality
>>>
>>> 1. Accounting and feedback
>>> 2. Control
>>>
>>> Why do 1 and 2 have to co-exist. A good case would be that we might
>>> need just stats and might want to implement control based on 1.
>>
>> I would say that 2 always requires 1 (provided they are of course on the
>> same subject), for the very simple reason that you need to know the
>> current state (as provided by 1) to control it (2).
>>
>> Therefore separating them leads to useless duplication.
>
> Almost all of the stats that are coming in here are completely useless
> for control and don't belong in the cpu controller.
>
> While it's not as pure we really have 2 tiers of statistic:
>
> 1) Accounting needed for control
> 2) Everything else
>
> What causes so much over-head for cpuacct currently is that it tries
> to maintain a separate accounting of usage.  If this were removed from
> the controller then it would be *much* cheaper, even with all extra
> stats added here.
>

Sure, if we can integrate the stats without control, I am all for it :)

Balbir Singh
