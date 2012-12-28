Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2L1A5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 19:57:22 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:37201 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab2L1A5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 19:57:18 -0500
MIME-Version: 1.0
In-Reply-To: <50DCE160.2040707@zytor.com>
References: <20121227182232.GA10054@x1.alien8.de>
	<CAE9FiQXpAB_AFtHF_NN7yr2iP2OOLgMir8MNvYUUc15k83_3zg@mail.gmail.com>
	<50DCE160.2040707@zytor.com>
Date: Thu, 27 Dec 2012 16:57:17 -0800
X-Google-Sender-Auth: dQ0H8X_bSkWklJXl5Y-x4N6jwDc
Message-ID: <CAE9FiQV2+AaGjyQBD=f8kKWDucbcnrk_UNHPi3Y=HtQCuYcYAQ@mail.gmail.com>
Subject: Re: [PATCH] x86, realmode: set real_mode permissions early
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 4:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/27/2012 03:56 PM, Yinghai Lu wrote:
>>>
>>>
>>> I'm looking at this patch in the -v8 branch: you need to update the
>>> comment above that function to say that trampoline code needs to be
>>> marked X now earlier.
>>
>>
>> Not sure if we really need to add such comment in the code.
>>
>> Peter, what is your idea about this?
>>
>
> It would be good to note why the early_initcall is the right phase.
>

How about:

---
Trampoline will be executed by APs with SMP,
So we need to set it EXEC in do_pre_smp_initcalls and it is early_initcall.
---
