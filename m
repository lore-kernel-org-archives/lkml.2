Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab1EaOYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:24:51 -0400
Received: from fnarfbargle.com ([93.93.131.224]:50300 "EHLO fnarfbargle.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751426Ab1EaOYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:24:49 -0400
Message-ID: <4DE4FA2B.2050504@fnarfbargle.com>
Date: Tue, 31 May 2011 22:24:43 +0800
From: Brad Campbell <lists2009@fnarfbargle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
References: <4DE44333.9000903@fnarfbargle.com> <20110531054729.GA16852@liondog.tnic> <4DE4B432.1090203@fnarfbargle.com> <20110531103808.GA6915@eferding.osrc.amd.com>
In-Reply-To: <20110531103808.GA6915@eferding.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/11 18:38, Borislav Petkov wrote:
> On Tue, May 31, 2011 at 05:26:10PM +0800, Brad Campbell wrote:
>> On 31/05/11 13:47, Borislav Petkov wrote:
>>> Looks like a KSM issue. Disabling CONFIG_KSM should at least stop your
>>> machine from oopsing.
>>>
>>> Adding linux-mm.
>>>
>>
>> I initially thought that, so the second panic was produced with KSM
>> disabled from boot.
>>
>> echo 0>  /sys/kernel/mm/ksm/run
>>
>> If you still think that compiling ksm out of the kernel will prevent
>> it then I'm willing to give it a go.
>
> Ok, from looking at the code, when KSM inits, it starts the ksm kernel
> thread and it looks like your oops comes from the function that is run
> in the kernel thread - ksm_scan_thread.
>
> So even if you disable it from sysfs, it runs at least once.
>

Just to confirm, I recompiled 2.6.38.7 without KSM enabled and I've been 
unable to reproduce the bug, so it looks like you were on the money.

I've moved back to 2.6.38.7 as 2.6.39 has a painful SCSI bug that panics 
about 75% of boots, and the reboot cycle required to get luck my way 
into a working kernel is just too much hassle.

It would appear that XP zero's its memory space on bootup, so there 
would be lots of pages to merge with a couple of relatively freshly 
booted XP machines running.

Regards,
Brad.
