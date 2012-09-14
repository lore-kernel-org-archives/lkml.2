Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2INVvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:51:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45651 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2INVva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:51:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120914192935.GO17747@google.com>
References: <20120913205827.GO7677@google.com> <20120914091032.GA6819@redhat.com>
 <20120914135830.GB6221@redhat.com> <20120914192935.GO17747@google.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 14 Sep 2012 23:51:06 +0200
Message-ID: <CAPXgP13oHLt8pMJSJvbB9Q10h8zTfvFVb99d=za3Bu0BmyCZtg@mail.gmail.com>
Subject: Re: [RFC] cgroup TODOs
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Michal Hocko <mhocko@suse.cz>, Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 9:29 PM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Sep 14, 2012 at 09:58:30AM -0400, Vivek Goyal wrote:
>> I am little concerned about above and wondering how systemd and libvirt
>> will interact and behave out of the box.
>>
>> Currently systemd does not create its own hierarchy under blkio and
>> libvirt does. So putting all together means there is no way to avoid
>> the overhead of systemd created hierarchy.
>>
>> \
>> |
>> +- system
>>      |
>>      +- libvirtd.service
>>               |
>>               +- virt-machine1
>>               +- virt-machine2
>>
>> So there is now way to avoid the overhead of two levels of hierarchy
>> created by systemd. I really wish that systemd gets rid of "system"
>> cgroup and puts services directly in top level group. Creating deeper
>> hieararchices is expensive.

The idea here is to split equally between the "system" and the "user"s
at that level.

That all can be re-considered and changed if really needed, but it's
not an unintentionally created directory.

Thanks,
Kay
