Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1JZSKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 14:10:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2329 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab1JZSKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 14:10:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=dclnCo0nk/UYHnfYSaI8O7t93Mjvo/8ALlySQlG3xGG2jDlDxnKEOtKoDJplqB0cH
	s7W08lprOPPJHS83rbskQ==
MIME-Version: 1.0
In-Reply-To: <4EA83F5D.20001@ntlworld.com>
References: <4EA549C3.4080206@ntlworld.com> <CAErSpo4EtfhnhWGpahk-NfMUVEizZSk3igZ+Vy7x=+hY5b0bcw@mail.gmail.com>
 <CAJvTdKmeEGVz8fXhaoFUOCtMM4bufTraTvztrf93880a1sVqKw@mail.gmail.com>
 <CAErSpo79nWTdqvmLACMfJp3WW00k7cD_zkGtkE1BunOxkNowxw@mail.gmail.com>
 <4EA82832.2070201@ntlworld.com> <CAErSpo6-KdbaaF1ZX8yL+aKO9ERr9xv7Dquvwo5_7yH_e7mSyw@mail.gmail.com>
 <4EA83F5D.20001@ntlworld.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Oct 2011 12:10:07 -0600
Message-ID: <CAErSpo4_epbHEAH3Ah=07NZFjqQedUcMXh+cxTSJ4Mp9KhvfPw@mail.gmail.com>
Subject: Re: kernel panic
To: nick bray <nick.bray1@ntlworld.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        Zhao Yakui <yakui.zhao@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 11:11 AM, nick bray <nick.bray1@ntlworld.com> wrote:
> On 26/10/11 17:18, Bjorn Helgaas wrote:
>>
>> On Wed, Oct 26, 2011 at 9:33 AM, nick bray<nick.bray1@ntlworld.com>
>>  wrote:
>>>
>>> On 26/10/11 15:53, Bjorn Helgaas wrote:
>>>>
>>>> On Wed, Oct 26, 2011 at 4:00 AM, Len Brown<lenb417@gmail.com>    wrote:
>>>>>>>
>>>>>>>  after upgrading to linux kernel 3.xx I get kernel panic on boot
>>>>>>> unless
>>>>>>> I
>>>>>>> use ACPI=off in the boot parameters this happens with both Ubuntu
>>>>>>> 11.10
>>>>>>> and
>>>>>>> Fedora 16. The mainboard is an Intel S875WP1-E running a Pentuim 4
>>>>>>> 3ghz
>>>>>>> with
>>>>>>> 3gig RAM in single-channel mode. I have performed a Bios upgrade just
>>>>>>> in
>>>>>>> case tha ACPI tables were corrupt but it makes no difference.
>>>>>>> Currently
>>>>>>> running 2.6.38-11-generic #50-Ubuntu SMP (Linux Mint) with no issues.
>>>>>
>>>>> Is this problem new in 3.1, or is it also present in 2.6.39 or 3.0?
>>>>>
>>>>> Also, do any other cmdline parmaters besides acpi=off work-around it?
>>>>> pci=noacpi
>>>>> maxcpus=1
>>>>>
>>>>> etc.
>>>>
>>>> Please keep all the cc's when responding.  Saves you work, saves us work
>>>> :)
>>>>
>>>> Summary of what I think you're seeing (please correct if wrong):
>>>>
>>>> 2.6.38 (Ubuntu/Mint): works fine, even with no boot args
>>>> 2.6.38 (Fedora 15): works fine, even with no boot args
>>>> 2.6.40? (Fedora 15 with upgraded kernel): requires "acpi=off" to boot
>>>> 3.0.0-12 (Ubuntu/Mint): requires "acpi=off" or "maxcpus=1" to boot.
>>>> "pci=noacpi" makes no difference.  with no arguments, panics as in
>>>> attached screenshot.
>>>> 3.1.0-0.rc6 (Fedora 16 live CD): can't find root device, drops to
>>>> debug shell, even with "maxcpus=1"
>>>>
>>>> Let's focus on Ubuntu and forget Fedora for now.
>>>>
>>>> The screenshot you sent (attached) has a clue ("EIP: [<00000000>] 0x0
>>>> SS:ESP 007b:00000046 CR2: 00000000ffffffff, Fatal exception in
>>>> interrupt") but doesn't really have enough context.  I should have
>>>> suggested booting with "vga=0xf07".  That will use a smaller font, so
>>>> the photo can capture more information.  Can you try that?  You might
>>>> have to use a lower jpg quality setting or resave with gimp at a low
>>>> quality setting to make the size 100K or less for the mailing lists.
>>>>
>>>> If you can boot 3.0.0-12 with "maxcpus=1", collect the dmesg log and
>>>> maybe we can compare it with the new "vga=0xf07" screenshot.
>>>
>>>            your summary is correct. Please see new screenshot taken with
>>> a
>>> better camera with the light off! Also I have resized it to>100k  Though
>>> I
>>> can't see a difference in the txt size even though I used vga=0xf07. also
>>> attached dmesg from Ubuntu 11.10 with maxcpus=1. Thank you for the time
>>> and
>>> interest. :)
>>
>> Please use reply-all... it saves work for everybody!
>>
>> Dunno why vga= doesn't do anything.  But this panic is different from
>> the first (and probably more useful).  Looks like this problem might
>> be in the acpi_processor_add() path, which might explain why
>> "maxcpus=1" makes a difference.
>>
>> I added cc: to a few people who have recently changed the ACPI processor
>> driver.
>>
>> Are you able to build test kernels yourself?  If so, you could
>> sprinkle printks() in acpi_processor_add(), maybe with some
>> mdelay(100) calls to slow things down.
>>
>> There's also a "boot_delay=" parameter that supposedly slows down boot
>> printks.  I haven't had much luck with it myself, but "boot_delay=100"
>> or so might allow you to get more snapshots of the beginning of the
>> stacktrace.
>>
>> Bjorn
>
> ok reply all it is, I'm sorry I've never needed to report something like
> this before. I've been using Linux now for around 10 years and consider
> myself reasonably competent at configuration and suchlike but never
> successfully built a kernel (I'm not a coder/programmer), something tells me
> that now is probably not a good time to try. ;)
>
> anyway here is a whole bunch of jpegs taken with boot_delay=100 I'm afraid
> they're not contiguous as some of they were too blurred to bother sending. I
> hope the info is useful.

Perfect, thanks!  Manual transcription of the interesting parts:

...
Brought up 2 CPUs
...
ACPI: Power Button [PWRF]
BUG: unable to handle kernel paging request at 00010282
IP: [<00010282>] 0x10281
*pde = 00000000
Oops: 0000 [#1] SMP
...
Pid: 1, comm: swapper Not tainted 3.0.0-12-generic #20-Ubuntu
EIP: 0060:[<00010282>] EFLAGS: 00010282 CPU: 1
...
  ? resched_task+0x22/0x70
  ? __kmalloc+0x189/0x1e0
  acpi_ns_evaluate+0x3a/0x18d
  acpi_evaluate_object+0xd6/0x1c5
  ? try_to_wake_up+0x140/0x190
  acpi_processor_get_power_info_cst+0x53/0x297
  ? wait_for_completion+0x17/0x20
  ? default_spin_lock_flags+0x8/0x10
  ? _raw_spin_lock+0xd/0x10
  ? task_rq_lock+0x49/0x80
  ? set_cpus_allowed_ptr+0x53/0x110
  ? acpi_processor_get_throttling_fadt+0x72/0x7a
  acpi_processor_get_power_info+0x24/0x10c
  acpi_processor_power_init+0xdc/0x10c
  acpi_processor_add+0x131/0x1d2
  acpi_device_probe+0x41/0xf5

I found a report with a serial console log showing a very similar
backtrace here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/807164

Seems pretty clearly related to acpi_processor_get_power_info();
hopefully an expert in that area will jump in and help out.

Bjorn
