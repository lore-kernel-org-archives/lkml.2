Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1H2Ca1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 22:30:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab1H2CaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 22:30:22 -0400
Message-ID: <4E5AF989.106@redhat.com>
Date: Mon, 29 Aug 2011 10:29:29 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110817 Fedora/3.1.12-1.fc14 Thunderbird/3.1.12
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [Patch] numa: introduce CONFIG_NUMA_SYSFS for drivers/base/node.c
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au> <20110804152211.ea10e3e7.rdunlap@xenotime.net> <20110823143912.0691d442.akpm@linux-foundation.org> <4E547155.8090709@redhat.com> <20110824191430.8a908e70.rdunlap@xenotime.net> <4E55C221.8080100@redhat.com> <20110824205044.7ff45b6c.rdunlap@xenotime.net> <alpine.DEB.2.00.1108242202050.576@chino.kir.corp.google.com> <4E562248.2090102@redhat.com> <alpine.DEB.2.00.1108251356220.18747@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1108251356220.18747@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年08月26日 04:57, David Rientjes 写道:
> On Thu, 25 Aug 2011, Cong Wang wrote:
>
>>> No, it doesn't work, CONFIG_HUGETLBFS can be enabled with CONFIG_NUMA=y
>>> and CONFIG_SYSFS=n and that uses data structures from drivers/base/node.c
>>> which doesn't get compiled with this patch.
>>
>> So, you mean with CONFIG_NUMA=y&&  CONFIG_SYSFS=n&&  CONFIG_HUGETLBFS=y
>> we still get compile error?
>>
>> Which data structures are used by hugetlbfs?
>>
>
> node_states[], which is revealed at link time if you tried to compile your
> patch.  It's obvious that we don't want to add per-node hugetlbfs
> attributes to sysfs directories if sysfs is disabled, so you need to
> modify the hugetlbfs code as well.

Makes sense. Thanks!
