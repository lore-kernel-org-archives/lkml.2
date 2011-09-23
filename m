Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab1IWPrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:47:32 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54649 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab1IWPra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:47:30 -0400
Message-ID: <4E7CA9B1.9070903@parallels.com>
Date: Fri, 23 Sep 2011 12:45:53 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Balbir Singh <bsingharora@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <mingo@elte.hu>, <jbottomley@parallels.com>
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
References: <1316030695-19826-1-git-send-email-glommer@parallels.com> <1316030695-19826-2-git-send-email-glommer@parallels.com> <1316448186.1511.19.camel@twins> <4E776937.1070108@parallels.com> <1316449160.6091.5.camel@twins> <4E776E36.6040906@parallels.com> <1316450385.6091.9.camel@twins> <4E7770BD.6050902@parallels.com> <1316457653.6091.16.camel@twins> <20110920172930.GA5318@linux.vnet.ibm.com> <CAKTCnzk=i1a3DHrforcaOCBdhjv1xi=5W=eiJiZoK4BNb3wqVw@mail.gmail.com> <1316704637.31429.25.camel@twins> <CAKTCnzk_NoBxQypJBsX9O56=F6z_7HdPY1HW=G=2AkM9tpkbaw@mail.gmail.com>
In-Reply-To: <CAKTCnzk_NoBxQypJBsX9O56=F6z_7HdPY1HW=G=2AkM9tpkbaw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.134.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 05:09 AM, Balbir Singh wrote:
>>> Android makes heavy use of cpuacct as well. We invented it to do cpu
>>> accounting independent of control
>>
>> But its a massive waste of time to have to iterate a double hierarchy,
>> cache-miss heaven.
>>
>
> By double hierarchy you mean both cpu and cpuacct? What if they are
> not mounted together?
>
>> Or so people really have independent cgroups as well? I thought people
>> just co-mount all this crap.
>>
>
> Please see
> http://code.google.com/p/cgroupmgr/wiki/cgroupsForAndroid
> http://stackoverflow.com/questions/6814207/android-cpuacct-usage-file
>
> AFAIK, some versions mount cpuacct at /acct and independent of cpu cgroups
>
> Balbir
But then, are they using both cpuacct and cpu cgroup for an independent 
group of tasks?

The problem here is that we're gathering the same statistics 3 times 
just because we need/want to present then in a different way. This is 
really bad design.


