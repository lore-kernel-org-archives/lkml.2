Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2LJVXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:23:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2LJVXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:23:42 -0500
References: <20121210145134.GA2097@hedwig.ini.cmu.edu> <20121210190905.GA24927@roeck-us.net> <20121210195414.GA642@polaris.bitmath.org> <4BC00520-E08A-43D0-AA2B-EA8154F3D160@suse.de> <4017A6C6-3074-44A5-AAAC-F4246946F151@exactcode.com>
In-Reply-To: <4017A6C6-3074-44A5-AAAC-F4246946F151@exactcode.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <28FE8A08-131B-4E20-BBC0-EEDDA129C1C8@suse.de>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Guenter Roeck <groeck-dsl@sbcglobal.net>,
        "Gabriel L. Somlo" <somlo@cmu.edu>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (9B206)
From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] applesmc: add sysfs file to report OSK
Date: Mon, 10 Dec 2012 22:24:55 +0100
To: Rene Rebe <rene@exactcode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10.12.2012, at 21:43, Rene Rebe <rene@exactcode.com> wrote:

> 
> On 10.12.2012, at 21:19, Alexander Graf <agraf@suse.de> wrote:
> 
>> 
>> On 10.12.2012, at 20:54, Henrik Rydberg wrote:
>> 
>>> Hi Guenter,
>>> 
>>>> On Mon, Dec 10, 2012 at 09:51:35AM -0500, Gabriel L. Somlo wrote:
>>>>> The AppleSMC contains two char[32] keys, OSK0 and OSK1, which are not
>>>>> reported in the key count and index by default. These keys are used by
>>>>> the OS X boot sequence, and normally don't matter when running Linux.
>>>>> 
>>>>> This patch creates a sysfs entry which reports the value of these keys
>>>>> as an ASCII string, to help emulators (such as QEMU) load OS X when
>>>>> running on genuine Apple hardware.
>>>>> 
>>>>> Signed-off-by: Gabriel L. Somlo <somlo@cmu.edu>
>>>>> ---
>>>>> 
>>>>> For extra context: To boot OS X as a guest, QEMU must (among others)
>>>>> emulate the AppleSMC. To boot successfully, OS X insists on querying
>>>>> the (emulated) SMC for the value of OSK0 and OSK1. Currently, these
>>>>> values must be supplied on the QEMU command line as
>>>>> 
>>>>> -device applesmc,osk="...concatenated values of OSK0 and OSK1..."
>>>>> 
>>>>> With the availability of /sys/devices/platform/applesmc.768/osk, the
>>>>> emulated QEMU AppleSMC could acquire this string directly from the
>>>>> (Apple-manufactured) host machine.
>>>> Hmm ... this is a non-hwmon attribute which doesn't really belong into hwmon
>>>> in the first place ... like several other attributes in the same driver.
>>>> 
>>>> So I'll leave it up to the maintainer to decide if we should accept it. Henrik ?
>>> 
>>> Indeed, the reaons against this patch are too many. I was just about
>>> to reply with the below:
>>> 
>>> Gabriel,
>>> 
>>> The OSK string seems constant accross machines, which renders the
>>> patch rather pointless, no? And even if the OSK differs between a
>>> couple of machines, the emulator could easily handle it gracefully.
>> 
>> The point is that the return value of the OSK is a copyrighted string, we can not include in any other layer. The only way to make this legally savvy is to read the key from the host.
>> 
>>> 
>>> There are also some technical issues with the patch below, to keep in
>>> mind for future submissions.
>> 
>> Sigh - most of the comments below go back to earlier review from me. He basically had a version almost exactly like what you're asking him to do :). Funny how code style taste differs.
> 
> And this is exactly the reason why I'm less and less motivated to waste my lifetime with upstream work ...

It's nit that bad really. Gabriel can just send his earlier version again with the ret variable name changed and then it shouldn't be an issue to get it in.

Reading the key really is an important bit in creating a legally safe and easy method to virtualize Mac OS X on Linux. Just believe us on this one :).


Alex

