Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2LKSCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:02:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59946 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab2LKSCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:02:51 -0500
Message-ID: <50C7752C.2000709@zytor.com>
Date: Tue, 11 Dec 2012 10:02:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com> <CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com> <50C6AB63.9070008@zytor.com> <CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com> <50C6D3DF.3030209@zytor.com> <CAE9FiQUiEx=p6wTC5wu_E=ih1CSBaTmw90zsc2=+xu6rMO5usg@mail.gmail.com> <20121211145716.GB8873@liondog.tnic> <CAE9FiQVByBTHwPrtYvVxv4u9QrtN1iN6GH9YaDn3dvmwv5Sg7g@mail.gmail.com> <50C763C2.5020603@zytor.com> <CAE9FiQUzHBb5SiEhfrOg7hFbuD1H1-7aXa0aTjhZ9tNqdrwGqw@mail.gmail.com> <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
In-Reply-To: <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 09:15 AM, Yinghai Lu wrote:
> On Tue, Dec 11, 2012 at 9:06 AM, Borislav Petkov <bp@alien8.de> wrote:
>> On Tue, Dec 11, 2012 at 09:00:55AM -0800, Yinghai Lu wrote:
>>> ok, then next question is how early it should be.
>>>
>>> before early_cpu_init/early_identify_cpu
>>>
>>> or just before check_bugs/identify_cpu
>>
>> Read the code. It's in x86_64_start_kernel on 64-bit.
>>
>
> No, that is not right place. initrd could be loaded anywhere like way
> high by bootloader.
>

The more I think about it, the more I think the right answer is the one 
we have pretty stated all along: if using the 64-bit entry point it is 
the responsibility of the boot loader to make sure the kernel, the setup 
data, and the initramfs are all mapped on entry.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

