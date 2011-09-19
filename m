Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1ISRrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:47:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab1ISRrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <20110919173905.GA3804@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com>
	<20110630075716.GB3377@albatros>
	<BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
	<BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
	<BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com>
	<CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
	<20110919173905.GA3804@albatros>
Date: Mon, 19 Sep 2011 23:17:16 +0530
Message-ID: <CAKTCnznSPoYvjzH_GekABBZ4HkyoQPVjTjBsOjwpVMSxQRxBSA@mail.gmail.com>
Subject: Re: [Security] [PATCH 2/2] taskstats: restrict access to user
From: Balbir Singh <bsingharora@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, Eric Paris <eparis@redhat.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 11:09 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> On Mon, Sep 19, 2011 at 09:40 -0700, Linus Torvalds wrote:
>> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
>> index e19ce1454ee1..5874d4866b3c 100644
>> --- a/kernel/taskstats.c
>> +++ b/kernel/taskstats.c
>> @@ -457,6 +457,8 @@ static int cmd_attr_register_cpumask(struct genl_info *info)
>>       cpumask_var_t mask;
>>       int rc;
>>
>> +     if (!capable(CAP_SYS_ADMIN))
>> +             return -EPERM;
>
> Shouldn't it simply protect taskstats_user_cmd()?  You may still poll
> the counters with TASKSTATS_CMD_ATTR_PID/TASKSTATS_CMD_ATTR_TGID.
>

Yep, it should if we want to move it all to root access.

Balbir
