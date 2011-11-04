Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1KDDCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 23:02:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63787 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab1KDDCC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 23:02:02 -0400
Message-ID: <4EB3560D.7000002@cn.fujitsu.com>
Date: Fri, 04 Nov 2011 11:03:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: "Brian K. White" <brian@aljex.com>, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] new cgroup controller "fork"
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>	<4EB2C4A5.6000406@parallels.com>	<20111103165903.GA4755@Debian-60-squeeze-64-minimal>	<20111103182101.5037c1e5@lxorguk.ukuu.org.uk>	<20111103185108.GA5153@Debian-60-squeeze-64-minimal>	<20111103190330.02590426@lxorguk.ukuu.org.uk>	<20111103192039.GA5300@Debian-60-squeeze-64-minimal>	<4EB2EA93.2050206@parallels.com> <4EB2F5CF.5010604@aljex.com> <4EB30DAF.4090704@parallels.com>
In-Reply-To: <4EB30DAF.4090704@parallels.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-04 11:02:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-04 11:02:05
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月04日 05:54, Glauber Costa 写道:
> On 11/03/2011 06:13 PM, Brian K. White wrote:
>> On 11/3/2011 3:25 PM, Glauber Costa wrote:
>>> On 11/03/2011 05:20 PM, Max Kellermann wrote:
>>>> On 2011/11/03 20:03, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
>>>>> Sure - I'm just not seeing that a whole separate cgroup for it is
>>>>> appropriate or a good plan. Anyone doing real resource management needs
>>>>> the rest of the stuff anyway.
>>>>
>>>> Right. When I saw Frederic's controller today, my first thought was
>>>> that one could move the fork limit code over into that controller. If
>>>> we reach a consensus that this would be a good idea, and would have
>>>> chances to get merged, I could probably take some time to refactor my
>>>> code.
>>>>
>>>> Max
>>> I'd advise you to take a step back and think if this is really needed.
>>> As Alan pointed out, the really expensive resource here is already being
>>> constrained by Frederic's controller.
>>
>> I think this really is a different knob that is nice to have as long as
>> it doesn't cost much. It's a way to set a max lifespan in a way that
>> isn't really addressed by the other controls. (I could absolutely be
>> missing something.)
>>
>> I think Max explained the issue clearly enough.
> 
> He did, indeed.
> 
>> It doesn't matter that the fork itself is supposedly so cheap.
>>
>> It's still nice to have a way to say, you may not fork/die/fork/die/fork
>> in a race.
>>
>> What's so unimaginable about having a process that you know needs a lot
>> of cpu and ram or other resources to do it's job, and you expressly want
>> to allow it to take as much of those resources as it can, but you know
>> it has no need to fork, so if it forks, _that_ is the only indication of
>> a problem, so you may only want to block it based on that.
>>
>> Sure many other processes would legitimately fork/die/fork/die a lot
>> while never exceeding a few total concurrent tasks, and for them you
>> would not want to set any such fork limit. So what?
>>
> As I said previously, he knows his use cases better than anyone else.
> If a use case can be found in which the summation of cpu+task controllers is not enough, and if this is implemented as an option to the task controller, and does not make it:
> 1) confusing,
> 2) more expensive,
> 
> then I don't see why not we shouldn't take it.

Quoted from Lennart's reply in another mail thread:

"Given that shutting down some services might involve forking off a few
things (think: a shell script handling shutdown which forks off a couple
of shell utilities) we'd want something that is between "from now on no
forking at all" and "unlimited forking". This could be done in many
different ways: we'd be happy if we could do time-based rate limiting,
but we'd also be fine with defining a certain budget of additional forks
a cgroup can do (i.e. "from now on you can do 50 more forks, then you'll
get EPERM)."

(http://lkml.org/lkml/2011/10/19/468)

The last sentence suggests he might like this fork controller.

