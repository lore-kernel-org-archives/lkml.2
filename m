Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2APVWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:22:18 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42935 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab2APVWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:22:17 -0500
Message-ID: <4F149360.70604@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 16:15:12 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [Regression] Commit "tpm: Introduce function to poll for result
 of self test" breaks suspend
References: <201201160022.07176.rjw@sisk.pl> <4F138AFB.8040601@linux.vnet.ibm.com> <201201162142.34096.rjw@sisk.pl>
In-Reply-To: <201201162142.34096.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011621-7182-0000-0000-0000008DB1C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 03:42 PM, Rafael J. Wysocki wrote:
> On Monday, January 16, 2012, Stefan Berger wrote:
>> On 01/15/2012 06:22 PM, Rafael J. Wysocki wrote:
>>> Hi Stefan,
>>>
>> Hi Rafael,
>>
> That doesn't show anything too.
>
> However, after reverting the above commit I get:
>
> $ find /sys/devices -name caps | xargs cat
> Manufacturer: 0x49465800
> TCG version: 1.2
> Firmware version: 1.2
>
> and system suspend works, although "find /sys/devices -name pcrs | xargs cat"
> still doesn't show anything.

My guess is your TPM is disabled and/or deactivated and it that mode 
doesn't like the sequence of commands we are sending to it. Well, I 
guess the best is to revert the patch for now. I'll send a patch for this.

What does

find /sys/devices -name active | xargs cat

currently show? If it shows a '0', can you try one other thing? Go into 
your machine's BIOS and find the TPM menu and enable/activate the device 
and try again the 'find's and suspend/resume again?

Thanks.

    Stefan

