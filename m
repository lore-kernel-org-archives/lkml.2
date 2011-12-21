Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1LUBO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:14:59 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:33801
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252Ab1LUBO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:14:56 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzzz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4EF132EA.7000300@am.sony.com>
Date: Tue, 20 Dec 2011 17:14:18 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, <tbird20d@gmail.com>
Subject: Re: Android low memory killer vs. memory pressure notifications
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru> <20111219121255.GA2086@tiehlicka.suse.cz> <alpine.DEB.2.00.1112191110060.19949@chino.kir.corp.google.com> <20111220145654.GA26881@oksana.dev.rtsoft.ru> <alpine.DEB.2.00.1112201322170.22077@chino.kir.corp.google.com> <20111221002853.GA11504@oksana.dev.rtsoft.ru>
In-Reply-To: <20111221002853.GA11504@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/11 16:28, Anton Vorontsov wrote:
> On Tue, Dec 20, 2011 at 01:36:00PM -0800, David Rientjes wrote:
>> On Tue, 20 Dec 2011, Anton Vorontsov wrote:
>>
>>> Hm, assuming that metadata is no longer an issue, why do you think avoiding
>>> cgroups would be a good idea?
>>>
>>
>> It's helpful for certain end users, particularly those in the embedded 
>> world, to be able to disable as many config options as possible to reduce 
>> the size of kernel image as much as possible, so they'll want a minimal 
>> amount of kernel functionality that allows such notifications.  Keep in 
>> mind that CONFIG_CGROUP_MEM_RES_CTLR is not enabled by default because of 
>> this (enabling it, CONFIG_RESOURCE_COUNTERS, and CONFIG_CGROUPS increases 
>> the size of the kernel text by ~1%),
> 
> So for 2MB kernel that's about 20KB of an additional text... This seems
> affordable, especially as a trade-off for the things that cgroups may
> provide.

A comment from http://lkml.indiana.edu/hypermail/linux/kernel/1102.1/00412.html:

"I care about 5K. (But honestly, I don't actively hunt stuff less than
10K in size, because there's too many of them to chase, currently)."

> 
> The fact is, for desktop and server Linux, cgroups slowly becomes a
> mandatory thing. And the reason for this is that cgroups mechanism
> provides some very useful features (in an extensible way, like plugins),
> i.e. a way to manage and track processes and its resources -- which is the
> main purpose of cgroups.

And for embedded and for real-time, some of us do not want cgroups to be
a mandatory thing.  We want it to remain configurable.  My personal
interest is in keeping the latency of certain critical paths (especially
in the scheduler) short and consistent.

-Frank

