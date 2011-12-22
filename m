Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab1LVBRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:17:23 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52688 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1LVBRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:17:19 -0500
MIME-Version: 1.0
In-Reply-To: <4EF132EA.7000300@am.sony.com>
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru> <20111219121255.GA2086@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1112191110060.19949@chino.kir.corp.google.com>
 <20111220145654.GA26881@oksana.dev.rtsoft.ru> <alpine.DEB.2.00.1112201322170.22077@chino.kir.corp.google.com>
 <20111221002853.GA11504@oksana.dev.rtsoft.ru> <4EF132EA.7000300@am.sony.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 21 Dec 2011 20:16:58 -0500
X-Google-Sender-Auth: BN-wAZsYXZcI94FoPy_bl1Z7hhk
Message-ID: <CAHGf_=r8=aG=BZLTjmZtkW6gcdkK=GU8g=5L57Fspx_DaA7Czw@mail.gmail.com>
Subject: Re: Android low memory killer vs. memory pressure notifications
To: frank.rowand@am.sony.com
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, tbird20d@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> So for 2MB kernel that's about 20KB of an additional text... This seems
>> affordable, especially as a trade-off for the things that cgroups may
>> provide.
>
> A comment from http://lkml.indiana.edu/hypermail/linux/kernel/1102.1/00412.html:
>
> "I care about 5K. (But honestly, I don't actively hunt stuff less than
> 10K in size, because there's too many of them to chase, currently)."

Hm, interesting. Because of, current memory cgroup notification was
made by a request from Sony and CELinux. AFAIK, at least, Sony
are already using cgroups.


>> The fact is, for desktop and server Linux, cgroups slowly becomes a
>> mandatory thing. And the reason for this is that cgroups mechanism
>> provides some very useful features (in an extensible way, like plugins),
>> i.e. a way to manage and track processes and its resources -- which is the
>> main purpose of cgroups.
>
> And for embedded and for real-time, some of us do not want cgroups to be
> a mandatory thing.  We want it to remain configurable.  My personal
> interest is in keeping the latency of certain critical paths (especially
> in the scheduler) short and consistent.

As far as I observed, modern embedded system have both RT and no RT process.
Java VM or user downloadable programs may need memory notification
because users may download bad programs. in the other hand, rt
processes are not downloadable and much tested by hardware vendor. So,
I think you only need
split process between under cgroups and not under cgroups.

cgroups have zero or much likely zero overhead if the processes don't use it.
Of course, feedback are welcome. I'm interesting your embedded usecase.
