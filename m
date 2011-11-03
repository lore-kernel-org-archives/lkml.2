Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1KCVzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:55:32 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40915 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab1KCVza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:55:30 -0400
Message-ID: <4EB30DAF.4090704@parallels.com>
Date: Thu, 3 Nov 2011 19:54:55 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Brian K. White" <brian@aljex.com>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] new cgroup controller "fork"
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag> <4EB2C4A5.6000406@parallels.com> <20111103165903.GA4755@Debian-60-squeeze-64-minimal> <20111103182101.5037c1e5@lxorguk.ukuu.org.uk> <20111103185108.GA5153@Debian-60-squeeze-64-minimal> <20111103190330.02590426@lxorguk.ukuu.org.uk> <20111103192039.GA5300@Debian-60-squeeze-64-minimal> <4EB2EA93.2050206@parallels.com> <4EB2F5CF.5010604@aljex.com>
In-Reply-To: <4EB2F5CF.5010604@aljex.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 06:13 PM, Brian K. White wrote:
> On 11/3/2011 3:25 PM, Glauber Costa wrote:
>> On 11/03/2011 05:20 PM, Max Kellermann wrote:
>>> On 2011/11/03 20:03, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
>>>> Sure - I'm just not seeing that a whole separate cgroup for it is
>>>> appropriate or a good plan. Anyone doing real resource management needs
>>>> the rest of the stuff anyway.
>>>
>>> Right. When I saw Frederic's controller today, my first thought was
>>> that one could move the fork limit code over into that controller. If
>>> we reach a consensus that this would be a good idea, and would have
>>> chances to get merged, I could probably take some time to refactor my
>>> code.
>>>
>>> Max
>> I'd advise you to take a step back and think if this is really needed.
>> As Alan pointed out, the really expensive resource here is already being
>> constrained by Frederic's controller.
>
> I think this really is a different knob that is nice to have as long as
> it doesn't cost much. It's a way to set a max lifespan in a way that
> isn't really addressed by the other controls. (I could absolutely be
> missing something.)
>
> I think Max explained the issue clearly enough.

He did, indeed.

> It doesn't matter that the fork itself is supposedly so cheap.
>
> It's still nice to have a way to say, you may not fork/die/fork/die/fork
> in a race.
>
> What's so unimaginable about having a process that you know needs a lot
> of cpu and ram or other resources to do it's job, and you expressly want
> to allow it to take as much of those resources as it can, but you know
> it has no need to fork, so if it forks, _that_ is the only indication of
> a problem, so you may only want to block it based on that.
>
> Sure many other processes would legitimately fork/die/fork/die a lot
> while never exceeding a few total concurrent tasks, and for them you
> would not want to set any such fork limit. So what?
>
As I said previously, he knows his use cases better than anyone else.
If a use case can be found in which the summation of cpu+task 
controllers is not enough, and if this is implemented as an option to 
the task controller, and does not make it:
1) confusing,
2) more expensive,

then I don't see why not we shouldn't take it.
