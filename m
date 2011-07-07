Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab1GGM3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:29:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46237 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab1GGM3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:29:15 -0400
MIME-Version: 1.0
In-Reply-To: <4E15A308.7080502@ladisch.de>
References: <CACTFLANCYMXH=z+NxEF0aqpMGZp21Q16_uB=J3rndM3pW74qeA@mail.gmail.com>
	<4E15A308.7080502@ladisch.de>
Date: Thu, 7 Jul 2011 14:29:15 +0200
Message-ID: <CACTFLAPN=mye5fhyPwv4QPU3d_inLNrT4poTeZoGm1NqoW0CmQ@mail.gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
From: Daniel Mack <zonque@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-usb@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, florian@mickler.org, pedrib@gmail.com,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 2:14 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Daniel Mack wrote:
>> I have to revisit an issue we've discussed in length around a year ago
>> and which still remains unsolved. I've been getting feedback from more
>> users of my driver snd-usb-caiaq who report the issue found in bug
>> #15580 in the kernel bugzilla:
>> https://bugzilla.kernel.org/show_bug.cgi?id=15580
>>
>> Let me quickly summarize the current state of this issue as I see it.
>>
>> The problem seems to be that certain 64bit chipsets can't deal with
>> the fact that an URB's transfer_buffer is allocated with
>> kmalloc(GFP_KERNEL). The effect is that kmalloc() is very likely to
>> hand out memory which is not addressable by devices that are connected
>> via 32bit PCI busses, such as EHCI controllers. In theory, DMA bounce
>> buffers should be installed in such cases, or the IOMMU would be in
>> charge to re-map these buffers to suitable locations, but for at least
>> two people who have reported the issue, this obviously fails.
>
> The problem is that snd-usb-caiaq modifies the URB buffer after
> submission.

Hmm, no, it doesn't. I know I stated that once, but I confused the
implementation of the Linux driver with the approach I chose for the
Mac OS X driver code. Sorry about that.

The driver simply copies audio material to its output URB and calls
usb_submit_urb(). The URB buffer is not touched after that call.


Daniel
