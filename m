Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab1FPSQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:16:20 -0400
Received: from smtp.infotech.no ([82.134.31.41]:57396 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab1FPSQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:16:19 -0400
Message-ID: <4DFA485C.4090300@interlog.com>
Date: Thu, 16 Jun 2011 14:15:56 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave> <BANLkTi=qHhzwGfp4v8B1CAmT+gtA=sOgvw@mail.gmail.com> <BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com> <4DFA44D4.2010602@interlog.com> <BANLkTimHMM6gNcFFP62eU-SUfaCPyhWE_A@mail.gmail.com>
In-Reply-To: <BANLkTimHMM6gNcFFP62eU-SUfaCPyhWE_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-16 02:05 PM, Kay Sievers wrote:
> On Thu, Jun 16, 2011 at 20:00, Douglas Gilbert<dgilbert@interlog.com>  wrote:
>> On 11-06-16 01:20 PM, Kay Sievers wrote:
>>> On Thu, Jun 16, 2011 at 19:09, Kay Sievers<kay.sievers@vrfy.org>    wrote:
>>>> On Thu, Jun 16, 2011 at 18:25, James Bottomley
>>>> <James.Bottomley@hansenpartnership.com>    wrote:
>>>>>
>>>>> On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:
>>>>>>
>>>>>> All userspace naming will be taken care of by the usual udev rules, so
>>>>>>>
>>>>>>> for disks, something like /dev/disk/by-preferred/<fred>    which would
>>>>>>> be
>>>>>>> the usual symbolic link.
>>>>>>
>>>>>> No, udev can not create such a link after the preferred name is set, as
>>>>>> it has no way of knowing that the name was set.
>>>>>
>>>>> It can if we trigger a uevent.  Note: I'm not advocating this ... I'd be
>>>>> equally happy having whatever sets the kernel name create the link (or
>>>>> tickle udev to create it).  We definitely require device links, though,
>>>>> to get this to work.
>>>
>>> Guess all that would work now, including mount(8) not canonicalizing.
>>> What would happen if we mount:
>>>    /dev/disk/by-pretty/foo
>>> and some tool later thinks the pretty name should better be 'bar', it
>>> writes the name to /sys, we get a uevent, the old link disappears, we
>>> get a new link, mount has no device node anymore for the mounted
>>> device ...
>>>
>>> So we basically get a one-shot additional pretty name? Guess, the
>>> _single_ name changed anytime later just asks for serious problems. We
>>> need to set it very early to be really useful, but how, where is it
>>> coming from?
>>
>> One obvious candidate for a preferred block device name
>> is:
>>   - a SATA disk's WWN (NAA 5 64 bit), or
>>   - a SCSI disk's logical unit name (e.g. SAS: NAA 5)
>>
>> These names (actually numbers) are meant to be world wide
>> unique.
>>
>> The kernel's device naming (following from how devices are
>> discovered) is topological. However at higher levels
>> the user is interested in the device identity. So if
>> unique device names were used as preferred names and
>> preferred names were unique (in a Linux system at any
>> given time) then any subsequent path to an existing device
>> would be highlighted. [That is because subsequent attempts
>> to create its preferred name would fail because it is
>> already there.]
>>
>> You don't need thousands of dollars of equipment to
>> demonstrate this point. An external single disk
>> SATA enclosure with a USB and eSATA interface will do.
>
> Udev does that already since quite a while. This is my cheap laptop:
>    # find /dev/disk/ -name "wwn*"
>    /dev/disk/by-id/wwn-0x50015179593f3038-part1
>    /dev/disk/by-id/wwn-0x50015179593f3038-part4
>    /dev/disk/by-id/wwn-0x50015179593f3038-part3
>    /dev/disk/by-id/wwn-0x50015179593f3038-part2
>    /dev/disk/by-id/wwn-0x50015179593f3038

That is my point, if that disk is eSATA and USB connected
which transport is that link pointing to? I would
prefer eSATA over USB any day but is udev that smart? Or
are we just seeing a symlink to the first (or perhaps last)
path discovered?

Doug Gilbert


