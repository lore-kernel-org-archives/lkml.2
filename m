Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab0JSO4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:56:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44304 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab0JSO4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:56:43 -0400
X-User-Agent: K-9 Mail for Android
References: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com> <4CBAE8E2.1060704@redhat.com> <AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com> <4CBBF3C8.9070104@web.de> <4CBC1047.6010501@redhat.com> <20101018125803.GA2497@darkstar> <4CBC4B06.3030300@redhat.com> <20101018134508.GA11885@darkstar> <4CBC4FA9.90406@redhat.com> <4CBC5097.1020105@redhat.com> <20101018135813.GA20316@darkstar> <4CBC547A.8080700@redhat.com> <4CBC964B.6000605@zytor.com> <AANLkTimLKjo+5BRFpOOb72qLrUnxfLXJQ6cwPwNsHHeB@mail.gmail.com> <4CBD099D.2060500@zytor.com> <AANLkTi=bYezfR6Gxy6_gXrAmsFTVOLJCex36BGmnEc28@mail.gmail.com> <4CBD5D8F.6020505@redhat.com>
In-Reply-To: <4CBD5D8F.6020505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 19 Oct 2010 07:56:07 -0700
To: Avi Kivity <avi@redhat.com>, Dave Young <hidave.darkstar@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <a4d1e098-7b9b-43f8-b341-2e0dbf1db780@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right... note in particular that the BIOS sets them up inconsistently.  The kernel is doing the rufht thing: since NX isn't available on all processors it is considered unavailable.

"Avi Kivity" <avi@redhat.com> wrote:

>  On 10/19/2010 08:55 AM, Dave Young wrote:
>> >  OK.  Please install msr-tools on your system, and give us the outputs of:
>> >
>> >  rdmsr -p 0 -xc 0x1a0
>> 0x1764952489
>>
>> >  rdmsr -p 1 -xc 0x1a0
>> 0x1364952489
>>
>
>That's MSR_IA32_MISC_ENABLE_XD_DISABLE.  Looks like the kernel never 
>plays with it.
>
>Suggest:
>- updating your BIOS
>- playing with the NX feature in your BIOS setup screens
>
>
>-- 
>error compiling committee.c: too many arguments to function
>

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
