Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1IGF4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 01:56:38 -0400
Received: from mx2.parallels.com ([64.131.90.16]:33820 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab1IGF4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 01:56:31 -0400
Message-ID: <4E670764.1040805@parallels.com>
Date: Wed, 7 Sep 2011 02:55:48 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Paul Menage <paul@paulmenage.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <containers@lists.osdl.org>, <netdev@vger.kernel.org>,
        <xemul@parallels.com>, "David S. Miller" <davem@davemloft.net>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v2 2/9] Kernel Memory cgroup
References: <1315369399-3073-1-git-send-email-glommer@parallels.com> <1315369399-3073-3-git-send-email-glommer@parallels.com> <CALdu-PCosvJ-SfVROLLM29RoMfxxRyW9E-_Za9A7LTAZwmkPeg@mail.gmail.com>
In-Reply-To: <CALdu-PCosvJ-SfVROLLM29RoMfxxRyW9E-_Za9A7LTAZwmkPeg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.132.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 02:24 AM, Paul Menage wrote:
> On Tue, Sep 6, 2011 at 9:23 PM, Glauber Costa<glommer@parallels.com>  wrote:
>> +
>> +struct kmem_cgroup {
>> +       struct cgroup_subsys_state css;
>> +       struct kmem_cgroup *parent;
>> +};
>
> There's a parent pointer in css.cgroup, so you shouldn't need a
> separate one here.

Ok, I missed that. Thanks

> Most cgroup subsystems define this structure (and the below accessor
> functions) in their .c file rather than exposing it to the world? Does
> this subsystem particularly need it exposed?

Originally I was using it in sock.c and friends. Now, from the last 
submission to this one, most of those uses were substituted. The 
acessors, however, are in kmem_cgroup.h. Reason being I want most of 
them to be inline.

>> +
>> +static struct cgroup_subsys_state *kmem_create(
>> +       struct cgroup_subsys *ss, struct cgroup *cgrp)
>> +{
>> +       struct kmem_cgroup *sk = kzalloc(sizeof(*sk), GFP_KERNEL);
>
> kcg or just cg would be a better name?

I'll go with kcg.
