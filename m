Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1JXA3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 20:29:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:57741 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1JXA3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 20:29:45 -0400
Message-ID: <4EA4B164.4000009@oracle.com>
Date: Sun, 23 Oct 2011 17:29:24 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J.Wysocki" <rjw@sisk.pl>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix S4 regression
References: <s5hwrbvv227.wl%tiwai@suse.de>
In-Reply-To: <s5hwrbvv227.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4EA4B170.000B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2011 02:19 PM, Takashi Iwai wrote:

> The commit 4b239f458: [x86-64, mm: Put early page table high] causes
> a S4 regression since 2.6.39, namely the machine reboots occasionally
> at S4 resume.  It doesn't happen always, overall rate is about 1/20.
> But, like other bugs, once when this happens, it continues to happen.
> 
> This patch fixes the problem by essentially reverting the memory
> assignment in the older way.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
> I resend this as a "fix" patch now before it's forgotten and rotten.
> It's just papering again over the mystery, but IMO better than the
> hard-reset behavior as of now.  Unfortunately, bisection is pretty 
> much difficult because the bug itself is fairly unstable...



Did you try to check several commit that Rafael pointed out:


On Wed, Sep 28, 2011 at 12:30 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, September 28, 2011, Takashi Iwai wrote:
>>
>> If my previous test -- 2.6.37+Yinghai's patches didn't show the
>> problem -- is correct, it means that some change in 2.6.38 reacted
>> badly with Yinghai's patches, not about 2.6.39.  I'll check tomorrow
>> again whether this observation is really correct.
>
> Yes, that would be good to know, thanks for doing this!
>
> If that turns out to be the case, there are the following commits
> looking like worth checking:
>
> d344e38 x86, nx: Mark the ACPI resume trampoline code as +x
> 884b821 ACPI: Fix acpi_os_read_memory() and acpi_os_write_memory() (v2)
> d551d81 ACPI / PM: Call suspend_nvs_free() earlier during resume
> 2d6d9fd ACPI: Introduce acpi_os_ioremap()

Thanks

Yinghai Lu
