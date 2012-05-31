Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2EaHKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:10:11 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:32871 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab2EaHKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:10:08 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205302351510.25774@chino.kir.corp.google.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com>
 <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com>
 <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com>
 <4FC6BC3E.5010807@jp.fujitsu.com> <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com>
 <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com>
 <4FC6D881.4090706@jp.fujitsu.com> <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com>
 <4FC70355.70805@jp.fujitsu.com> <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com>
 <4FC70E5E.1010003@gmail.com> <alpine.DEB.2.00.1205302325500.25774@chino.kir.corp.google.com>
 <4FC711A5.4090003@gmail.com> <alpine.DEB.2.00.1205302351510.25774@chino.kir.corp.google.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 31 May 2012 03:09:45 -0400
Message-ID: <CAHGf_=qVDVT6VW2j9gE3bQKwizW24iivrDryiCKoxVu4m_fWKw@mail.gmail.com>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
To: David Rientjes <rientjes@google.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 2:56 AM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 31 May 2012, KOSAKI Motohiro wrote:
>
>> > This is tangent to the discussion, we need to revisit why an application
>> > other than a daemon managing a set of memcgs would ever need to know the
>> > information in /proc/meminfo.  No use-case was ever presented in the
>> > changelog and its not clear how this is at all relevant.  So before
>> > changing the kernel, please describe how this actually matters in a real-
>> > world scenario.
>>
>> Huh? Don't you know a meanings of a namespace ISOLATION? isolation mean,
>> isolated container shouldn't be able to access global information. If you
>> want to lean container/namespace concept, tasting openvz or solaris container
>> is a good start.
>
> As I said, LXC and namespace isolation is a tangent to the discussion of
> faking the /proc/meminfo for the memcg context of a thread.

Because of, /proc/meminfo affect a lot of libraries behavior. So, it's not only
application issue. If you can't rewrite _all_ of userland assets, fake meminfo
can't be escaped. Again see alternative container implementation.


>
>> But anyway, I dislike current implementaion. So, I NAK this patch too.
>>
>
> I'm glad you reached that conclusion, but I think you did so for a much
> different (although unspecified) reason.
>
> Thanks.
