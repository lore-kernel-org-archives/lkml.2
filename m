Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2ARBBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:01:03 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45469 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2ARBBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:01:02 -0500
MIME-Version: 1.0
In-Reply-To: <20120117220715.GB23527@redhat.com>
References: <20120117201823.GD19223@redhat.com>
	<20120117214834.GD26207@google.com>
	<20120117220715.GB23527@redhat.com>
Date: Wed, 18 Jan 2012 09:01:00 +0800
X-Google-Sender-Auth: 8xPeF0zQdlzK7qPoDBp65YKWTLg
Message-ID: <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
Subject: Re: Kernel crash in icq_free_icq_rcu
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/18 Vivek Goyal <vgoyal@redhat.com>:
> On Tue, Jan 17, 2012 at 01:48:34PM -0800, Tejun Heo wrote:
>> On Tue, Jan 17, 2012 at 03:18:23PM -0500, Vivek Goyal wrote:
>> > Hi Tejun,
>> >
>> > With latest linus kernel, I see following crash. I was running some
>> > scripts which create cgroups and launch fio jobs in those groups. In
>> > a separate window I wrote a script to change the IO scheduler on the
>> > device in a loop while IO was happening on the device. After few
>> > seconds I see following. So far I tried it twice and reproduced it
>> > both the times in first few seconds.
>>
>> Does the following patch make any difference?
>
> Nope. Still can reproduce the issue.
I had similar issue too. Looks ioc_create_icq finds an icq (in ioc_lookup_icq)
the icq is in rcu free (it has __rcu_icq_cache set)
