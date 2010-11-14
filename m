Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab0KNBPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 20:15:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64653 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab0KNBPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 20:15:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YNkDAknR3xCql2HZCaKnJD+Z5Clzq0hfJoGacoXX19ERq4CWkYk3cPCRkGUuHSYJtu
         MW8Vqh0+EBh5LwsNhntXkO8mbEfoWau5MG2G4hxzTQkTigTbls9lXd5d/9HndZbZ+q7Z
         cWhHVkgFp3mHnVD452xoXO/rmV9qNV/uqOuqc=
MIME-Version: 1.0
In-Reply-To: <1289500084.2698.12.camel@zim>
References: <20101104041236.GA9389@helgaas.com>
	<1288847992.2718.37.camel@edumazet-laptop>
	<20101104142853.GA11656@helgaas.com>
	<1288881474.2659.123.camel@edumazet-laptop>
	<20101105020013.GA13484@helgaas.com>
	<1288937844.3234.1.camel@edumazet-laptop>
	<1289500084.2698.12.camel@zim>
Date: Sat, 13 Nov 2010 17:15:10 -0800
X-Google-Sender-Auth: o0eNSTVYAPUFgZCYD4vOawsGdbc
Message-ID: <AANLkTinP9dCUpfqKASULkbAHTfy1egX-7ESoR35MXt-n@mail.gmail.com>
Subject: Re: divide error in select_task_rq_fair()
From: Yinghai Lu <yinghai@kernel.org>
To: Myron Stowe <myron.stowe@hp.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org, knikanth@suse.de, rjenties@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 10:28 AM, Myron Stowe <myron.stowe@hp.com> wrote:
> On Fri, 2010-11-05 at 07:17 +0100, Eric Dumazet wrote:
>> Le jeudi 04 novembre 2010 à 20:00 -0600, Bjorn Helgaas a écrit :
>>
>> > Is that going to help you debug the problem?  The solution is not going
>> > to be something like "set NR_CPUS=x".  If NR_CPUS is too small, the
>> > machine should still *boot*, even if we can't use all the CPUs in the
>> > box.
>> >
>>
>> Yes, it will help to understand the layout of cpu / domains and make
>> appropriate changes.
>>
>> Alternative is you send me such a machine :=)
>
> I opened a BZ on this issue as it seems to be a regression -
> https://bugzilla.kernel.org/show_bug.cgi?id=22662
>
> I also, as indicated in the BZ, bisected the kernel which gave the
> following results and reverting 50f2d7f682f9c0ed58191d0982fe77888d59d162
> did re-enable booting on the box in question (an HP dl980g7).  Let me
> know what further info you need or patches to test for debugging this.
>
> Thanks,
>
> commit 50f2d7f682f9c0ed58191d0982fe77888d59d162
> Author: Nikanth Karthikesan <knikanth@suse.de>
> Date:   Thu Sep 30 17:34:10 2010 +0530
>
>    x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA
>
>    commit d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9 "x86, numa: Use near(er)
>    online node instead of roundrobin for NUMA" changed NUMA initialization on
>    Intel to choose the nearest online node or first node.  Fake NUMA would be
>    better of with round-robin initialization, instead of the all CPUS on
>    first node.  Change the choice of first node, back to round-robin.
>
>    For testing NUMA kernel behaviour without cpusets and NUMA aware
>    applications, it would be better to have cpus in different nodes, rather
>    than all in a single node.  With cpusets migration of tasks scenarios
>    cannot not be tested.
>
>    I guess having it round-robin shouldn't affect the use cases for all cpus
>    on the first node.
>
>    The code comments in arch/x86/mm/numa_64.c:759 indicate that this used to
>    be the case, which was changed by commit d9c2d5ac6.  It changed from
>    roundrobin to nearer or first node.  And I couldn't find any reason for
>    this change in its changelog.
>
>    Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
>    Cc: David Rientjes <rientjes@google.com>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


please check

http://lkml.org/lkml/2010/11/13/176

Yinghai
