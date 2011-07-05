Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab1GEXGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 19:06:20 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54901 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab1GEXGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 19:06:19 -0400
Message-ID: <4E1398E1.60306@canonical.com>
Date: Tue, 05 Jul 2011 16:06:09 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 02/12] Input: synaptics - do not invert y if 0
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org> <1309324042-22943-3-git-send-email-djkurtz@chromium.org> <4E134D0C.7060500@canonical.com> <CAGS+omA0=wperMBA+kXVtJW1HJg=1CuW+HnS5kN_cDCBSphT=A@mail.gmail.com>
In-Reply-To: <CAGS+omA0=wperMBA+kXVtJW1HJg=1CuW+HnS5kN_cDCBSphT=A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2011 03:50 PM, Daniel Kurtz wrote:
> On Wed, Jul 6, 2011 at 1:42 AM, Chase Douglas
> <chase.douglas@canonical.com> wrote:
>>
>> On 06/28/2011 10:07 PM, djkurtz@chromium.org wrote:
>>> From: Daniel Kurtz <djkurtz@chromium.org>
>>>
>>> Synaptics touchpads report increasing y from bottom to top.
>>> This is inverted from normal userspace "top of screen is 0" coordinates.
>>> Thus, the kernel driver reports inverted y coordinates to userspace.
>>>
>>> In some cases, however, y = 0 is sent by the touchpad.
>>> In these cases, the kernel driver should not invert, and just report 0.
>>
>> Under what cases is y sent as 0, and why do we want to report it as 0 to
>> userspace?
> 
> I know of two such cases for the image sensor:
>   (1) When all fingers, save the first finger are removed, an AGM
> packet with (x=0, y=0, z=0) is sent.
>   (2) When all fingers are removed, an SGM packet with (x=0, y=0, z=0) is sent.
> 
> After uploading this patch set, I played with the profile sensor
> again, and I also saw it sometimes sends y=1 packets.  I don't know
> what those are.
> 
> This is mostly useful for debugging the kernel driver.
> When observing the raw position values, the special 0 (and 1?) cases
> are more obvious when not inverted.
> I think I am misleading in my commit message.  I don't believe these
> are actually ever passed through to userspace.

If they are set, then they are passed through evdev, unless I'm missing
something... Given the cases listed above, it seems like we should be
special casing these scenarios. Maybe that means dropping the event or
handling finger count transitions or something else.

I'm happy with the patch as a cleanup of y inversion, but I don't see
the utility of passing y = 0 through. With all the debugging techniques
we have (printk, systemtap, perf, ftrace, etc.), I don't think we need
this functionality, and it might lead a code reviewer to scratch their
head wondering what the point was :).

Thanks!

-- Chase
