Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1DZLxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:53:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab1DZLxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:53:54 -0400
Message-ID: <4DB6B28D.5090607@redhat.com>
Date: Tue, 26 Apr 2011 13:54:53 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110422 Fedora/3.1.9-7.fc15 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
        Joerg Heckenbach <joerg@heckenbach-aw.de>,
        Dwaine Garden <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbvision: remove (broken) image format conversion
References: <201104252323.20420.linux@rainbow-software.org> <201104260832.11150.hverkuil@xs4all.nl> <201104261030.21681.linux@rainbow-software.org>
In-Reply-To: <201104261030.21681.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/26/2011 10:30 AM, Ondrej Zary wrote:
> On Tuesday 26 April 2011, you wrote:
>> On Monday, April 25, 2011 23:23:17 Ondrej Zary wrote:
>>> The YVU420 and YUV422P formats are broken and cause kernel panic on use.
>>> (YVU420 does not work and sometimes causes "unable to handle paging
>>> request" panic, YUV422P always causes "NULL pointer dereference").
>>>
>>> As V4L2 spec says that drivers shouldn't do any in-kernel image format
>>> conversion, remove it completely (except YUYV).
>>
>> What really should happen is that the conversion is moved to libv4lconvert.
>> I've never had the time to tackle that, but it would improve this driver a
>> lot.
>
> Depending on isoc_mode module parameter, the device uses different image
> formats: YUV 4:2:2 interleaved, YUV 4:2:0 planar or compressed format.
>
> Maybe the parameter should go away and these three formats exposed to
> userspace?

That sounds right,

> Hopefully the non-compressed formats could be used directly
> without any conversion. But the compressed format (with new V4L2_PIX_FMT_
> assigned?) should be preferred (as it provides much higher frame rates). The
> code moved into libv4lconvert would decompress the format and convert into
> something standard (YUV420?).

Correct.

>
>> Would you perhaps be interested in doing that work?
>
> I can try it. But the hardware isn't mine so my time is limited.
>

If you could give it a shot that would be great. I've some hardware to
test this with (although I've never actually tested that hardware), so
I can hopefully pick things up if you cannot finish things before you
need to return the hardware.

Thanks & Regards,

Hans
