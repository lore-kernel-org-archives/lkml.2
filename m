Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab1FEM5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 08:57:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62212 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab1FEM5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 08:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SN9s2bBUGhWJoHeiGFXhtXTYxCYii8DBIggLB5OmARAvcU/lwXDmsYpDMnfjB8KSxT
         SNMdgevWZnZLhQOzL+jNeVXg8ylbx1QnadMG1oIWeW3PYJ7LQtYGzg8vUBR9QvA/p1TZ
         9byhMQ2wYN+ruqdOF+RnEDZ8IdGUtDfMngb64=
MIME-Version: 1.0
In-Reply-To: <4DEB5D24.8050405@xs4all.nl>
References: <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>
	<4CE17C4B.1070305@xs4all.nl>
	<20101115185848.GI2583@sunsite.ms.mff.cuni.cz>
	<20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>
	<AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com>
	<20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com>
	<4CE1968D.3050706@xs4all.nl>
	<4DE8DC16.6030308@xs4all.nl>
	<20110603133351.GA25130@srcf.ucam.org>
	<4DE8EF13.9030609@xs4all.nl>
	<20110603144644.GA26782@srcf.ucam.org>
	<4DEB5D24.8050405@xs4all.nl>
Date: Sun, 5 Jun 2011 14:57:45 +0200
Message-ID: <BANLkTiksinSDd9aQP4vSeV-+uV2CtuWTrw@mail.gmail.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: Jim Bos <jim876@xs4all.nl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/6/5 Jim Bos <jim876@xs4all.nl>:
> On 06/03/2011 04:46 PM, Matthew Garrett wrote:
>> On Fri, Jun 03, 2011 at 04:26:27PM +0200, Jim Bos wrote:
>>> On 06/03/2011 03:33 PM, Matthew Garrett wrote:
>>>> ? You've got 143 boot services/code regions, which is more than I'd
>>>> tested against, so I'm unsure whether we're overflowing something here.
>>>>
>>>
>>> That's seems to be the only EFI patch in 2.6.39.1 and I effectively
>>> removed by =not= applying (skipping) the parts of the 2.6.39.1 patch to
>>> above 3 files.
>>> So yes removing "x86, efi: Retain boot service code until after
>>> switching to virtual mode" indeed fixes the problem for me.
>>
>> Ok, thanks. I'll look into that. Might be best to drop it from stable
>> for the moment until I've made sure it works on machines with excessive
>> maps.
>>
>
> Matthew,
>
> Another datapoint, just tried a 3.0.0-rc1 kernel, good news is that it
> boots.  Maybe the "x86, efi: Merge contiguous memory regions of the same
> type" helps with these large number of maps?
>
> However, there seems to be something else wrong as I get several "BUG:
> Bad page state in process swapper  pfn:00000" which have efi functions
> on the stack, see dmesg output.
For what it's worth, I have noticed the exact same problems here when
booting 2.6.39.1 on an asrock P67 chipset. The reboot on 2.6.39.1 and
the bag page states. I also noticed some instability with 3.0 with it
freezing up, but that's probably related to broken binary nvidia
drivers.

~Maarten
