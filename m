Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1HJQrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:47:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55994 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab1HJQrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:47:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=yen8An6YoU//5Q6uG0vgxgCD3ICP0IpVchuFdNdYycil6z5LNMOU+xClTbD/xNPLI
	cq7sVr/lLG0heW1U/+stg==
MIME-Version: 1.0
In-Reply-To: <CAAJw_ZvxQQ9-QrSiv9-Y4yCun4W0xvAD3OcdL8gS_hN9FE1rkQ@mail.gmail.com>
References: <CAAJw_ZvnUPs5wD6hU059GcKRkyeNn7Y36fk9nNjNFJ6kNmL0uw@mail.gmail.com>
 <20110804105657.GA27681@centrinvest.ru> <CAErSpo5aE=cUPXf-bcrk8sNAWFCEAC2wQAvXZy7P9q5_A6=qMA@mail.gmail.com>
 <CAAJw_ZvZEn0qVG3JVfEWFQbOSjVUCJhBwQ2Dw5KQyDx2kY4xbA@mail.gmail.com>
 <CAErSpo4uUsfKyON_5gxLikH2F0R7q-fBJ0+04vj2CrCH0r1q4g@mail.gmail.com> <CAAJw_ZvxQQ9-QrSiv9-Y4yCun4W0xvAD3OcdL8gS_hN9FE1rkQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 10 Aug 2011 10:46:57 -0600
Message-ID: <CAErSpo6UheNeaW=KaVocmwAiNjJh-7OS390AZgwpkRtPJk8=Jw@mail.gmail.com>
Subject: Re: How to access serial port that is set in BIOS as OS Controlled
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Andrey Panin <pazke@centrinvest.ru>, lkml <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 7:02 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
>
> On Fri, Aug 5, 2011 at 11:20 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>> On Fri, Aug 5, 2011 at 7:59 AM, Jeff Chua <jeff.chua.linux@gmail.com>
>> wrote:
>> >
>> > echo "auto" > /sys/bus/pnp/devices/00:0a/resources
>> >
>> > This seems to work.
>>
>> OK.  That's a good clue, and maybe a good enough workaround for your
>> immediate need.
>>
>> But I think the fact that it doesn't "just work" is a Linux bug, and
>> it'd be nice to fix it.  My guess is that running _SRS is what makes
>> the port work, and that Windows does this automatically but Linux does
>> not.  If we can figure out exactly what the difference is, there's a
>> good chance that we can fix several Linux issues by just doing things
>> the way Windows does.
>>
>> Would you mind building with CONFIG_PNP_DEBUG_MESSAGES=y, booting with
>> "pnp.debug", issuing the "auto" command, and attaching the dmesg log
>> to this bug report?
>>
>>  https://bugzilla.kernel.org/show_bug.cgi?id=40612
>>
>> Thanks!
>
> I'll do that next Monday when I get into the office to configure the CV60.

Ping, just a reminder :)

The ACPI spec (v4.0a, sec 6.2) says:

  When OSPM enumerates a device, it calls _PRS to determine the resource
  requirements of the device. It may also call _CRS to find the current resource
  settings for the device. Using this information, the Plug and Play system
  determines what resources the device should consume and sets those
  resources by calling the device’s _SRS control method.

I'm pretty sure Linux only runs _SRS when we actually *change* something, which
doesn't seem to follow the intent of the spec.  So if we can get a
little more evidence
here, I think it'd be worth changing Linux to call _SRS for every device when it
enumerates it.

Bjorn
