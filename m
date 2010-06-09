Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab0FIQ2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:28:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43655 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0FIQ2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nR7HKUioOHMOI1E1ESzkK3kioDMYiYULwmURnkiicjkqu34lGPfz+NpDKJo4ECqooH
         RdsB/xHFZbq7Ngt3kb5rmguA4ATuWWzSTzp9TjUCbfsH0tjkfyzIh7+lKUoogwHiX2+m
         DUqbiWZ6GbIci/D0NPc1Q54++64sD8sfFG8sM=
MIME-Version: 1.0
In-Reply-To: <1276097068.1745.13.camel@laptop>
References: <AANLkTin2pPqOUx--9fIX3BH3e-cU6oCRufijcx_4ozx5@mail.gmail.com>
	<20100608001929.GF2387@linux.vnet.ibm.com>
	<AANLkTikl13cJNuU32JzRarrUnoh5DYHr-Tbnv9B-UjsG@mail.gmail.com>
	<1275986441.5408.111.camel@twins>
	<AANLkTimXVlgzHivCQberLdrFP8BH_nJzt8_ozUNHG_aI@mail.gmail.com>
	<1276004075.2987.208.camel@twins>
	<AANLkTil6ucLZ0A6tWx-OQt_2EeKnx8nSx6rIg2t1L2t5@mail.gmail.com>
	<1276097068.1745.13.camel@laptop>
Date: Wed, 9 Jun 2010 11:29:14 -0400
Message-ID: <AANLkTinl2JKUX6859Ioa1y0DqHWXH5TrkissQ8BAF4cP@mail.gmail.com>
Subject: Re: 2.6.35-rc2-git1 - include/linux/cgroup.h:534 invoked 
	rcu_dereference_check() without protection!
From: Miles Lane <miles.lane@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Vivek Goyal <vgoyal@redhat.com>,
       Eric Paris <eparis@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       nauman@google.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 11:24 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-06-09 at 11:11 -0400, Miles Lane wrote:
>>
>> Sorry.  I misunderstood this message when I first read it.  I didn't
>> realize this message include a new version of the patch.
>> Anyhow, I just tried to apply the patch to 2.6.35-rc2-git3 and got this:
>>
>> # patch -p1 -l -F 20 --dry-run < ../5.patch
>> patching file include/linux/cgroup.h
>> patching file kernel/sched.c
>> Hunk #1 succeeded at 306 with fuzz 1.
>> Hunk #3 FAILED at 4462.
>> Hunk #4 succeeded at 4487 with fuzz 3.
>> 1 out of 4 hunks FAILED -- saving rejects to file kernel/sched.c.rej
>
> Weird.. it seems to apply without trouble to Linus' git tree.
>
> root@twins:/usr/src/linux-2.6# git checkout -f origin/master
> HEAD is now at 84f7586... Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6
> root@twins:/usr/src/linux-2.6# quilt push
> Applying patch patches/sched-rcu-validation.patch
> patching file include/linux/cgroup.h
> patching file kernel/sched.c
>
> Now at patch patches/sched-rcu-validation.patch
> root@twins:/usr/src/linux-2.6# git describe
> v2.6.35-rc2-54-g84f7586

Oh.  Duh. I know what is going on.  I had received another patch to
sched.c.  They must conflict.  I will test with just your patch now.
