Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2GNTNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 15:13:08 -0400
Received: from void.printf.net ([89.145.121.20]:55839 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab2GNTNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 15:13:00 -0400
From: Chris Ball <cjb@laptop.org>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: merez@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        DOCUMENTATION <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] mmc: block: Add write packing control
References: <1338576911-17089-1-git-send-email-merez@codeaurora.org>
	<1338576911-17089-2-git-send-email-merez@codeaurora.org>
	<CAFR8uefCD_WXDM6m+-XwG10+W0UXqOtK7_sxWD3uVckh3pnR-Q@mail.gmail.com>
	<CAFR8uee7hWLC-h_abZOCEuqeUeuhDuJp74x3R-3n+c61xyfaPQ@mail.gmail.com>
	<fb2303ea3a3a5470e76d1faa2abd471b.squirrel@www.codeaurora.org>
	<CAFR8ueecGqw=JzAGVHV61-SqOnn_C-ryT54KCQCbKkJpXUGY9w@mail.gmail.com>
Date: Sat, 14 Jul 2012 15:12:54 -0400
In-Reply-To: <CAFR8ueecGqw=JzAGVHV61-SqOnn_C-ryT54KCQCbKkJpXUGY9w@mail.gmail.com>
	(Muthu Kumar's message of "Wed, 13 Jun 2012 15:21:49 -0700")
Message-ID: <87629qkvgp.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 13 2012, Muthu Kumar wrote:
> On Wed, Jun 13, 2012 at 12:52 PM,  <merez@codeaurora.org> wrote:
>>
>> On Mon, June 11, 2012 5:28 pm, Muthu Kumar wrote:
>>> On Mon, Jun 11, 2012 at 2:19 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
>>>> On Fri, Jun 1, 2012 at 11:55 AM, Maya Erez <merez@codeaurora.org> wrote:
>>>>> trigger
>>>>> the packing can be configured via sysfs by writing the required value
>>>>> to:
>>>>> /sys/block/<block_dev_name>/num_wr_reqs_to_start_packing.
>>>>> The trigger for disabling the write packing is fetching a read request.
>>>>>
>>>>
>>>> If it is applicable only to MMC why do we have this sysfs attr for all
>>>> block devices?
>>>
>>> Just to be clear, please create a directory, say mmc, under
>>> /sys/block/<dev>/ and create the attr inside that.
>>>
>>> You can refer to dm (dm-sysfs.c) for sample implementation.
>> I understand why you think it would be best to distinguish the MMC
>> specific attribute from the general block devices attributes.
>> However, since this attribute is created only for the MMC block device,
>> other block devices won't be aware of it.
>
> I understand its created by the MMC code so will not be there for
> other block devices. But having the device specific attributes inside
> one <device> directory is better/cleaner. And since we are already
> following that model for other devices, why not follow that for MMC
> also?

I've already replied to a later version of the patch, but just to get
this comment in at the appropriate point of the discussion as well:

Even though it would result in a cleaner sysfs, I don't want to do
this now because it will break userspace scripts that are depending
on the current locations of these attributes.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
