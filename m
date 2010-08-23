Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab0HWLgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:36:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:33825 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab0HWLgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:36:44 -0400
Message-ID: <4C725D4A.8040604@suse.cz>
Date: Mon, 23 Aug 2010 13:36:42 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tiago Maluta <tiago.maluta@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] fix compilation error with CROSS_COMPILE
References: <20100821062133.GA809@localhost> <20100821072454.GA25054@merkur.ravnborg.org> <20100821072955.GA4950@localhost> <20100821074021.GA25099@merkur.ravnborg.org> <20100821092652.GA9967@localhost> <20100821125853.GA25430@merkur.ravnborg.org>
In-Reply-To: <20100821125853.GA25430@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.8.2010 14:58, Sam Ravnborg wrote:
>> commit 7f48a0a8c15c41f382f2265088bc96007836e608
>> Author: Tiago Maluta<tiago.maluta@gmail.com>
>> Date:   Mon Jun 21 22:00:17 2010 +0200
>>
>>      Linux has an recent option to define CROSS_COMPILE in menuconfig.
[...]
>> diff --git a/Makefile b/Makefile
>> index 7431c28..13126ae 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>>   export KBUILD_BUILDHOST := $(SUBARCH)
>>   ARCH           ?= $(SUBARCH)
>>   CROSS_COMPILE  ?=
>> -CROSS_COMPILE  ?= $(CONFIG_CROSS_COMPILE:"%"=%)
>> +CROSS_COMPILE  := $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
>
> So this patch does two things:
> 1) It grep for CONFIG_CROSS_COMPILE because we may not have incldued .config
> 2) It no longer pick up CROSS_COMPILE from the environment.
>
> Traditionally we have picked up ARCH and CROSS_COMPILE from the environmnet,
> hence the use of "?=".
> "?=" says - perfrom this assignmnet unless lhs is already defined.
> And lhs may be already defined is we have the ysmbol defined in the
> environmnet.
>
> I think the original submitter chenged from ?= to := without
> realising this.
> So the patch should be adjusted to use ?= again as you suggest
> before it is applied.
> I assume Michal / Andrew will take care.

I would rather check if the patch is still needed at all. Tiago, can you 
try vanilla 2.6.36-rc1, which has the first
"CROSS_COMPILE  ?="
line removed (commit 235caa2) and check if your original problem still 
presists?

Thanks,
Michal
