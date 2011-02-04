Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1BDD2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 22:28:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39499 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab1BDD2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 22:28:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=InSsH28wpXFKomVJH0pBtv09xB2ohEZeXUOQ0WEjVwHiGyCRZLhV4yMMR439Od/QTw
         9rAKict+B4oQzOtwXGyy22HC5zFZ+Rxjglughqp+CFWUgSQeAHcSaZccMoaRWIebIttC
         /WWWk3yjNl5z9DMVcc6oQjeQSoRVbiuC2gCuk=
Date: Fri, 4 Feb 2011 11:28:36 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Message-ID: <20110204032836.GB13902@cr0.redhat.com>
References: <20110131225939.GH11974@redhat.com>
 <20110203094715.939C.A69D9226@jp.fujitsu.com>
 <20110203020528.GA21603@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C147F4346@USINDEVS01.corp.hds.com>
 <m14o8klt3w.fsf@fess.ebiederm.org>
 <5C4C569E8A4B9B42A84A977CF070A35B2C147F43B7@USINDEVS01.corp.hds.com>
 <20110204022427.GA13902@cr0.redhat.com>
 <20110204025041.GB30087@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110204025041.GB30087@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 09:50:42PM -0500, Vivek Goyal wrote:
>On Fri, Feb 04, 2011 at 10:24:27AM +0800, Américo Wang wrote:
>> On Thu, Feb 03, 2011 at 05:08:01PM -0500, Seiji Aguchi wrote:
>> >Hi Eric,
>> >
>> >Thank you for your prompt reply.
>> >
>> >I would like to consider "Needs in enterprise area" and "Implementation of kmsg_dump()" separately.
>> >
>> >(1) Needs in enterprise area
>> >  In case of kdump failure, we would like to store kernel buffer to NVRAM/flush memory
>> >  for detecting root cause of kernel crash.
>> >
>> >(2) Implementation of kmsg_dump 
>> >  You suggest to review/test cording of kmsg_dump() more.
>> >
>> >What do you think about (1)?
>> >Is it acceptable for you?
>> >
>> 
>> For "in case of kdump fails", we can move
>> KMSG_DUMP_OOPS/KMSG_DUMP_PANIC before calling crash_kexec(),
>> so you can capture the log before kdump happens.
>
>True. If the idea is to capture the logs before kdump starts saving
>core, then kdump_msg() call, can be put before crash_kexec() call and
>there is no need to hook into crash_kexec().
>

Totally agreed.

>Secondly now the question of whether kdump_msg() call should be before
>crash_kexec() or not because modules might want to do lots of unreliable
>things, I am now split on that. Especially because of the fact that if
>somebody wants it probably can use kprobe to hook into crash_kexec()
>or panic() or something like that to execute its code before everything
>else.

If kprobe is the reason, then probably we can remove lots of other
kernel API's like kmsg dumper.


>
>The other reason I am little split on this because in the past I have seen
>kdump fail many a times either because of chipset issues or because of driver
>issues etc. So though I don't like it and I want drivers to be fixed
>to take care of booting in kdump environment, things not necessarily
>worked as well as we expected them to and it is not hard to meet a kdump
>failure.
>
>Hence though I do not prefer it but I will not stand in the way of kdump_msg()
>being called before crash_kexec() gets the control.
>

The point is that we don't have to choose one of them (kmsg dumper or
kdump), we can choose to have them both. Like Seiji said, they always
want the kernel messages to be saved. Duplicates are much better than
nothing.

