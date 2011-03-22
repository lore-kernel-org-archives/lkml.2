Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1CVRGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:06:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1CVRGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x9ygAgYF5i6yo4m5pW6p92yAJpOd5kxTgp1IKGqtdxqoGhljOOanJ1+7Hh+F/bbyUi
         kKTdJmIas9+h4OHVpVkA==
MIME-Version: 1.0
In-Reply-To: <20110322073514.GB12940@tiehlicka.suse.cz>
References: <20110318152532.GB18450@tiehlicka.suse.cz>
	<20110321093419.GA26047@tiehlicka.suse.cz>
	<AANLkTimkcYcZVifaq4pH4exkWUVNXpwXA=9oyeAn_EqR@mail.gmail.com>
	<20110322073514.GB12940@tiehlicka.suse.cz>
Date: Tue, 22 Mar 2011 10:06:27 -0700
Message-ID: <AANLkTi=2t_tL=Vt4athAyQ1tDhLDGpqtmu-iAOjdbPBJ@mail.gmail.com>
Subject: Re: cgroup: real meaning of memory.usage_in_bytes
From: Ying Han <yinghan@google.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 12:35 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Mon 21-03-11 10:22:41, Ying Han wrote:
> [...]
>>
>> Michal,
>>
>> Can you help to post the test result after applying the patch?
>
> The result of the LTP test is:
> TEST 4: MEMORY CONTROLLER TESTING
> RUNNING SETUP.....
> WARN:/dev/memctl already exist..overwriting
> Cleanup called
> TEST STARTED: Please avoid using system while this test executes
> memory usage from memory.usage_in_bytes= 62955520
> memory usage from memory.stat= 62955520
> TINFO   Memory Resource Controller: stat check test passes first run
> Test continues to run the second step.
> memory usage from memory.usage_in_bytes= 78643200
> memory usage from memory.stat=78643200
> TPASS   Memory Resource Controller: stat check test PASSED
> Memory Resource Controller test executed successfully.
> Cleanup called
>
> The attached simple test case result is:
> # mkdir /dev/memctl; mount -t cgroup -omemory cgroup /dev/memctl; cd /dev/memctl
> # mkdir group_1; cd group_1; echo 100M > memory.limit_in_bytes
> # cat memory.{usage_in_bytes,stat}
> 0
> cache 0
> rss 0
> [start the test case, add its pid to the group and let it fault in]
>
> # cat memory.{usage_in_bytes,stat}
> 4096
> cache 0
> rss 4096
>
> [let it finish]
> # cat memory.{usage_in_bytes,stat}
> 0
> cache 0
> rss 0
>
> Thanks

Thanks Michal for fixing it up. Regardless of the performance
overhead, the change make sense to me.

--Ying

> --
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9
> Czech Republic
>
