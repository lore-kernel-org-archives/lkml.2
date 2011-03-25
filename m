Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959Ab1CYEFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 00:05:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47981 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1CYEFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 00:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mFY/gBM4cjecOjKRYN8HFqxQsD5w8Jbdt0VQyJJbJMmDtXCXs2QWfOLkI5qdsw26Yu
         TukQyF+htugsMtGSswCyrlRSdn3TeUS0ptnXVkRSeLAOsxbAziHNBaCpY+DqwUokurae
         Du8U8gv/kRgKoNVzbGCxH8KnWv3T/GC/MZ/8o=
MIME-Version: 1.0
In-Reply-To: <20110325115453.82a9736d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110324105222.GA2625@barrios-desktop>
	<20110325090411.56c5e5b2.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=f3gu7-8uNiT4qz6s=BOhto5s=7g@mail.gmail.com>
	<20110325115453.82a9736d.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 25 Mar 2011 13:05:50 +0900
Message-ID: <BANLkTim3fFe3VzvaWRwzaCT6aRd-yeyfiQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] forkbomb killer
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 11:54 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 25 Mar 2011 11:38:19 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Fri, Mar 25, 2011 at 9:04 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Thu, 24 Mar 2011 19:52:22 +0900
>> > Minchan Kim <minchan.kim@gmail.com> wrote:
>> > To me, the fact "the system _can_ be broken by a normal user program" is the most
>> > terrible thing. With Andrey's case or make -j, a user doesn't need to be an admin.
>> > I believe it's worth to pay costs.
>> > (and I made this function configurable and can be turned off by sysfs.)
>> >
>> > And while testing Andrey's case, I used KVM finaly becasue cost of rebooting was small.
>> > My development server is on other building and I need to push server's button
>> > to reboot it when forkbomb happens ;)
>> > In some environement, cost of rebooting is not small even if it's a development system.
>> >
>>
>> Forkbomb is very rare case in normal situation but if it happens, the
>> cost like reboot would be big. So we need the such facility. I agree.
>> (But I don't know why others don't have a interest if it is important
>> task. Maybe they are so busy due to rc1)
>> Just a concern is cost.
>
> me, too.
>
>> The approach is we can enhance your approach to minimize the cost but
>> apparently it would have a limitation.
>>
> agreed. "tracking" always costs.
>
>> Other approach is we can provide new rescue facility.
>> What I have thought is new sysrq about killing fork-bomb.
>>
> Mine works fine with Sysrq+f. But, I need to go to other building
> for pushing Sysrq.....
>
>> If we execute the new sysrq, the kernel freezes all tasks so forkbomb
>> can't execute any more and kernel ready to receive the command to show
>> the system state. Admin can investigate which is fork-bomb and then he
>> kill the tasks. At last, admin restarts all processes with new sysrq
>> and processes which received SIGKILL start to die.
>>
>> This approach offloads kernel's heuristic forkbomb detection to admin
>> and avoid runtime cost in normal situation.
>> I don't have any code to implement above the concept so it might be ridiculous.
>>
>> What do you think about it?
>>
> For usual user, forkbmob killer works better, rather than special console for
> fatal system.
>
> I can think of 2 similar works. One is Windows's TaskManager. You can kill tasks
> with it (and I guess TaskManager is always on memory...) Another one is
> "guarantee" or "preserve XXXX for special apps." which clustering guys wants for
> quick server failover.
>
> If trouble happens,
>  - freeze all apps other than HA apps.
>  - open the gate for hidden preserved resources (of memory / disks)
>  - do safe failover to other server.
>  - do necessary jobs and reboot.
>
> So, you need to preserve some resources for recover...IOW, have to pay costs.
>
> BTW, Sysrq/TaskManager/Failover doesn't help me, using development system via network.

Okay. Each approach has a pros and cons and at least, now anyone
doesn't provide any method and comments but I agree it is needed(ex,
careless and lazy admin could need it strongly). Let us wait a little
bit more. Maybe google guys or redhat/suse guys would have a opinion.

Regardless of them, I will review series when I have rest time.
Thanks, Kame.

-- 
Kind regards,
Minchan Kim
