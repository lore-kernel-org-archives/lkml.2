Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab2GPBtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 21:49:13 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62686 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GPBtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 21:49:10 -0400
MIME-Version: 1.0
In-Reply-To: <87629qkvgp.fsf@octavius.laptop.org>
References: <1338576911-17089-1-git-send-email-merez@codeaurora.org>
	<1338576911-17089-2-git-send-email-merez@codeaurora.org>
	<CAFR8uefCD_WXDM6m+-XwG10+W0UXqOtK7_sxWD3uVckh3pnR-Q@mail.gmail.com>
	<CAFR8uee7hWLC-h_abZOCEuqeUeuhDuJp74x3R-3n+c61xyfaPQ@mail.gmail.com>
	<fb2303ea3a3a5470e76d1faa2abd471b.squirrel@www.codeaurora.org>
	<CAFR8ueecGqw=JzAGVHV61-SqOnn_C-ryT54KCQCbKkJpXUGY9w@mail.gmail.com>
	<87629qkvgp.fsf@octavius.laptop.org>
Date: Sun, 15 Jul 2012 18:49:09 -0700
Message-ID: <CAFR8uedwb1_gB-j6=riUuiJcEPY13rNJCLv1bxXc6aebnhonYw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mmc: block: Add write packing control
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: merez@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        DOCUMENTATION <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Sat, Jul 14, 2012 at 12:12 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> On Wed, Jun 13 2012, Muthu Kumar wrote:
>> On Wed, Jun 13, 2012 at 12:52 PM,  <merez@codeaurora.org> wrote:
>>>
>>> On Mon, June 11, 2012 5:28 pm, Muthu Kumar wrote:
>>>> On Mon, Jun 11, 2012 at 2:19 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
>>>>> On Fri, Jun 1, 2012 at 11:55 AM, Maya Erez <merez@codeaurora.org> wrote:
>>>>>> trigger
>>>>>> the packing can be configured via sysfs by writing the required value
>>>>>> to:
>>>>>> /sys/block/<block_dev_name>/num_wr_reqs_to_start_packing.
>>>>>> The trigger for disabling the write packing is fetching a read request.
>>>>>>
>>>>>
>>>>> If it is applicable only to MMC why do we have this sysfs attr for all
>>>>> block devices?
>>>>
>>>> Just to be clear, please create a directory, say mmc, under
>>>> /sys/block/<dev>/ and create the attr inside that.
>>>>
>>>> You can refer to dm (dm-sysfs.c) for sample implementation.
>>> I understand why you think it would be best to distinguish the MMC
>>> specific attribute from the general block devices attributes.
>>> However, since this attribute is created only for the MMC block device,
>>> other block devices won't be aware of it.
>>
>> I understand its created by the MMC code so will not be there for
>> other block devices. But having the device specific attributes inside
>> one <device> directory is better/cleaner. And since we are already
>> following that model for other devices, why not follow that for MMC
>> also?
>
> I've already replied to a later version of the patch, but just to get
> this comment in at the appropriate point of the discussion as well:
>
> Even though it would result in a cleaner sysfs, I don't want to do
> this now because it will break userspace scripts that are depending
> on the current locations of these attributes.
>

Maya is adding a new sysfs attribute with that patch. So, there should
not be any user space stuff that depends on it.

Regards,
Muthu


> Thanks,
>
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
