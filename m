Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab1FPNsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:48:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52379 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1FPNsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110616132441.GJ14846@anthem.async.com.br>
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
	<20110616132441.GJ14846@anthem.async.com.br>
Date: Thu, 16 Jun 2011 15:48:48 +0200
Message-ID: <BANLkTi=zZsArjjEUoB=w-_1JxyMEr-KK_Q@mail.gmail.com>
Subject: Re: [RFC] Add Arm cpu topology definition
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Christian Robottom Reis <kiko@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 15:24, Christian Robottom Reis <kiko@linaro.org> wrote:
> On Thu, Jun 16, 2011 at 10:49:13AM +0200, Vincent Guittot wrote:
>> @@ -219,6 +219,24 @@ source "kernel/Kconfig.freezer"
>>
>>  menu "System Type"
>>
>> +config SCHED_MC
>> +     bool "Multi-core scheduler support"
>> +     depends on SMP && ARM_CPU_TOPOLOGY
>> +     default n
>> +     help
>> +       Multi-core scheduler support improves the CPU scheduler's decision
>> +       making when dealing with multi-core CPU chips at a cost of slightly
>> +       increased overhead in some places. If unsure say N here.
>> +
>> +config SCHED_SMT
>> +     bool "SMT scheduler support"
>> +     depends on SMP && ARM_CPU_TOPOLOGY
>> +     default n
>> +     help
>> +       Improves the CPU scheduler's decision making when dealing with
>> +       MultiThreading at a cost of slightly increased overhead in some
>> +       places. If unsure say N here.
>> +
>
> Quick question: the patch doesn't actually seem to use the SCHED_MC and
> SCHED_SMT config bits; is that actually correct?

The default config of the patch is to disable sched_mc and sched_smt.
The 1st goal is to let each platform enable and test the feature.
According to feedback, we could then change the default state of the
configuration

> --
> Christian Robottom Reis   | [+55] 16 9112 6430 | http://launchpad.net/~kiko
> Linaro Engineering VP     | [ +1] 612 216 4935 | http://async.com.br/~kiko
>
