Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab1GRJmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 05:42:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37116 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1GRJmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 05:42:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpW_NGMB0dCNRLS_OaWwL=A974jEdhW0++tiiJCK24+Wfg@mail.gmail.com>
References: <1310951766-3840-1-git-send-email-akinobu.mita@gmail.com>
	<1310951766-3840-3-git-send-email-akinobu.mita@gmail.com>
	<CAM_iQpW_NGMB0dCNRLS_OaWwL=A974jEdhW0++tiiJCK24+Wfg@mail.gmail.com>
Date: Mon, 18 Jul 2011 18:42:53 +0900
Message-ID: <CAC5umyjqfQpaZVq3USA61idH3--koaeKy+1zkn109t6ecR8xgQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] cpu: CPU notifier error injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/18 Américo Wang <xiyou.wangcong@gmail.com>:
> On Mon, Jul 18, 2011 at 9:16 AM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> ...
>> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
>> index 72e2384..cf0b4b7 100644
>> --- a/Documentation/feature-removal-schedule.txt
>> +++ b/Documentation/feature-removal-schedule.txt
>> @@ -583,3 +583,11 @@ Why:       Superseded by the UVCIOC_CTRL_QUERY ioctl.
>>  Who:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>
>>  ----------------------------
>> +
>> +What:  Support for CPU_NOTIFIER_ERROR_INJECT (cpu-notifier-error-inject.ko)
>> +When:  3.3
>> +Why:   Replaced with more generic debugfs interface in
>> +       /sys/kernel/debug/cpu-notifier-error-inject/
>> +Who:   Akinobu Mita <akinobu.mita@gmail.com>
>
> Hi, Akinobu,
>
> I think it is okay to just remove it by this patchset, no need to defer it.

The only drawback is that new machanism has no way to specify notifier
priority and the priority is hard-coded to be -1.  So it can only inject
error at the tail of notifier chain.

My plan to fix that was the kernel parameters.  But it's not flexible
as it needs to reboot for changing the priority.

So I'm now considering keeping this kernel module style instead of
initializing in late_initcall().
