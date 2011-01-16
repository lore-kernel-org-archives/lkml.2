Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1APPEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 10:04:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:46120 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab1APPEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 10:04:39 -0500
Message-ID: <4D332507.4090204@infradead.org>
Date: Sun, 16 Jan 2011 15:04:07 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ben Gamari <bgamari.foss@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, aospan@netup.ru
Subject: Re: [PATCH 01/18] Altera FPGA firmware download module.
References: <201012310726.31851.liplianin@netup.ru> <201012311212.19715.laurent.pinchart@ideasonboard.com> <4D1DBE2A.5080003@infradead.org> <201012311230.51903.laurent.pinchart@ideasonboard.com> <4D1DC2DD.6050400@infradead.org> <8739p45x3v.fsf@gmail.com>
In-Reply-To: <8739p45x3v.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 07-01-2011 17:31, Ben Gamari escreveu:
> Hi Mauro,
> 
> On Fri, 31 Dec 2010 09:47:41 -0200, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
>> Em 31-12-2010 09:30, Laurent Pinchart escreveu:
>>> Hi Mauro,
>>>
>>> [snip]
>>>
>>> I understand this. However, a complete JTAG state machine in the kernel, plus 
>>> an Altera firmware parser, seems to be a lot of code that could live in 
>>> userspace.
>>
>> Moving it to userspace would mean a kernel driver that would depend on an
>> userspace daemon^Wfirmware loader to work. I would NAK such designs.
>>
>> The way it is is fine from my POV.
> 
> Any furthur comment on this? As I noted, I strongly disagree and would
> point out that there is no shortage of precedent for the use of
> userspace callbacks for loading of firmware, especially when the process
> is as tricky as this.
> 
> I also work with Altera FPGAs and have a strong interest in making this
> work yet from my perspective it seems pretty clear that the best way
> forward both for both maintainability and useability is to keep
> this code in user-space. There is absolutely no reason why this code
> _must_ be in the kernel and punting it out to userspace only requires
> a udev rule.
> 
> Placing this functionality in userspace results in a massive duplication
> of code, as there are already a number of functional user-space JTAG
> implementations.

On all V4L/DVB drivers I'm ware of, firmwares are loaded via request_firmware, when
userspace tries to use the device, or when the driver is loaded (eventually, it might
have some v4l/dvb legacy drivers with some weird implementation, but this is a bad
practice).

There's currently no V4L/DVB load firmware daemon or V4L/DVB udev rules for loading
firmware that I'm ware of, and I don't like the idea of adding an extra complexity
for userspace to use this device.

So, I'll be adding this driver as proposed. Yet, as some points are risen, I'll
be moving those drivers to staging for 2.6.38. This will give you some time for
propose patches and to better discuss this question.
> 
>>> If I understand it correctly the driver assumes the firmware is in an Altera 
>>> proprietary format. If we really want JTAG code in the kernel we should at 
>>> least split the file parser and the TAP access code.
>>>
>>
>> Agreed, but I don't think this would be a good reason to block the code merge
>> for .38.
>>
> Sure, but there should be agreement that a kernel-mode JTAG state
> machine really is the best way forward (i.e. necessary for effective
> firmware upload) before we commit to carry this code around forever.
> 
> - Ben
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

