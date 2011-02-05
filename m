Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab1BEG05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 01:26:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40315 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab1BEG04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 01:26:56 -0500
Message-ID: <4D4CED97.7060302@zytor.com>
Date: Fri, 04 Feb 2011 22:26:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
        tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [tip:x86/urgent] x86-32: Make sure the stack is set up before
 we use it
References: <4D41E86D.8060205@free.fr> <tip-43d79a250bdb10e30b08a79e906befc691c3f5ce@git.kernel.org> <20110205021922.GP5503@outflux.net> <4D4CD411.6070800@zytor.com> <20110205053716.GR5503@outflux.net>
In-Reply-To: <20110205053716.GR5503@outflux.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 09:37 PM, Kees Cook wrote:
> On Fri, Feb 04, 2011 at 08:37:37PM -0800, H. Peter Anvin wrote:
>> On 02/04/2011 06:19 PM, Kees Cook wrote:
>>> This works for me doing CPU hotplugging on ia32, but on x86_64 it hangs.
>>> (Both boot, though.)
>>
>> I can't reproduce the failure here, and it's hard to see how this patch
>> would make a significant change on 64 bits.  Could you try reverting
>> *only* the head_64.S hunk and try it on your platform again?
> 
> With the head_64.S hunk dropped, it runs fine. My highly fine-tuned
> test-case is:
> 
>   while :; do ls -la / -R >/dev/null 2>/dev/null; done &
>   while :; do echo 0 > /sys/devices/system/cpu/cpu1/online ; echo 1 > /sys/devices/system/cpu/cpu1/online ; done &
> 
> Looks good from this end. Thanks!
> 

OK, that bothers me, because it would seem that something is accessing
data it shouldn't, but ok, it fixes it for now.  I'll update it in -tip.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

