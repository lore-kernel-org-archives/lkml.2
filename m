Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2ARBF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:05:28 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61440 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2ARBF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:05:27 -0500
MIME-Version: 1.0
In-Reply-To: <20120118010323.GA32160@htj.dyndns.org>
References: <20120117201823.GD19223@redhat.com>
	<20120117214834.GD26207@google.com>
	<20120117220715.GB23527@redhat.com>
	<CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
	<20120118010323.GA32160@htj.dyndns.org>
Date: Wed, 18 Jan 2012 09:05:26 +0800
X-Google-Sender-Auth: Uvjs84Y5eN3w-veY9HqenXvod3s
Message-ID: <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
Subject: Re: Kernel crash in icq_free_icq_rcu
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/18 Tejun Heo <tj@kernel.org>:
> Hello,
>
> On Wed, Jan 18, 2012 at 09:01:00AM +0800, Shaohua Li wrote:
>> 2012/1/18 Vivek Goyal <vgoyal@redhat.com>:
>> >> Does the following patch make any difference?
>> >
>> > Nope. Still can reproduce the issue.
>>
>> I had similar issue too. Looks ioc_create_icq finds an icq (in ioc_lookup_icq)
>> the icq is in rcu free (it has __rcu_icq_cache set)
>
> Vivek is seeing the problem while switching elevators.  Are you too?
> Or is it during normal operation?
same here. I had some problems when I debug my ioscheduler, but
eventually found even switching cfq and noop can trigger oops.
