Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2LKTda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:33:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:50007 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab2LKTd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:33:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,260,1355126400"; 
   d="scan'208";a="232395861"
Message-ID: <50C78A79.6010306@linux.intel.com>
Date: Tue, 11 Dec 2012 11:33:13 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com> <CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com> <50C6AB63.9070008@zytor.com> <CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com> <50C6D3DF.3030209@zytor.com> <CAE9FiQUiEx=p6wTC5wu_E=ih1CSBaTmw90zsc2=+xu6rMO5usg@mail.gmail.com> <20121211145716.GB8873@liondog.tnic> <CAE9FiQVByBTHwPrtYvVxv4u9QrtN1iN6GH9YaDn3dvmwv5Sg7g@mail.gmail.com> <50C763C2.5020603@zytor.com> <CAE9FiQUzHBb5SiEhfrOg7hFbuD1H1-7aXa0aTjhZ9tNqdrwGqw@mail.gmail.com> <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com> <50C7752C.2000709@zytor.com> <50C7795D.3000404@zytor.com> <CAE9FiQV03xToOaR3NcMtWDv=2MCMYwtY7p97BY3sAC1suYAhNA@mail.gmail.com> <50C77F86.5010207@zytor.com> <CAE9FiQV8Qu551rHDx49Na2sQeqCyXtuhC7Ea=stunNzjfUR34A@mail.gmail.com>
In-Reply-To: <CAE9FiQV8Qu551rHDx49Na2sQeqCyXtuhC7Ea=stunNzjfUR34A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 11:18 AM, Yinghai Lu wrote:
> 
> that will be bunch of asm code again, and need to parse the setup_header in that
> asm to get range value for those regions...
> 

It's an index into an array, it's not "parsing".

>>
>>> but if the user memmap to exclude some page, we will still need to
>>> relocate the ramdisk.
>>
>> -ENOPARSE
> 
> .. I mean pointer for saved ucode will be updated then again.
> and relocated_initrd wil still need to use ioremap because init_memory_mapping
> will clean mapping the range range that is excluded by memmap=XX$YY
> 
>>
>> I really need to look at this in more detail.  I'm starting to think
>> this is done completely backwards.
> 
> really should not put asm code if it could be done in C in not complicated way.
> 

Uhm... that's not what I'm talking about.

	-hpa

