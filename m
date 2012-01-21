Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab2AUVZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 16:25:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53204 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2AUVZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 16:25:54 -0500
Message-ID: <4F1B2D64.7020705@gmail.com>
Date: Sat, 21 Jan 2012 21:25:56 +0000
From: Chris Diamand <chris.diamand@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: linux-kernel@vger.kernel.org, tiwai@suse.de, melchior.franz@gmail.com
Subject: Re: i915/kms/backlight-combo mode problem
References: <4F1AF145.2090407@gmail.com> <86k44kkity.fsf@sumi.keithp.com>
In-Reply-To: <86k44kkity.fsf@sumi.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/12 18:32, Keith Packard wrote:
> On Sat, 21 Jan 2012 17:09:25 +0000, Chris Diamand<chris.diamand@gmail.com>  wrote:
>> Hi,
>>
>> I have the problem described in the thread here
>> (https://lkml.org/lkml/2011/4/29/217) where the backlight
>> values are reversed so although stuff is displayed on the screen, the
>> backlight is off. This occurs with kernels from about 2.6.39 onwards.
>>
>> After booting a "broken" kernel (>~2.6.39), the backlight can be lit
>> temporarily with:
>> setpci -s 00:02.0 F4.B=0
>> and then turned off with:
>> setpci -s 00:02.0 F4.B=FF
> Can you experiment with other values? I'd like to know if it's
> completely reversed, or if there's some other interaction here.
>
> Testing 0x80, 0x7f, 0x01, 0xfe would all be interesting to me.
>
0x00 is the brightest. It gets very gradually dimmer up to about 0xB0, 
when the gaps between
brightness levels are slightly bigger.
0xFE is very low but still works.
Barely any difference between 0x80 and 0x7f, same with 0x00 and 0x01, etc.

> I suspect that writes to the LPBC value are being trapped by SMI and
> 'doing things' underneath.
>
>> Yesterday I tried this patch, https://lkml.org/lkml/2011/4/30/37 by
>> manually applying it to the 3.2.1
>> kernel source - this fixes the problem.
> Can you still turn the backlight off with this patch in place?
Yes, with Fn-F6. It turns back on again when the mouse is moved or a key 
is pressed.
>> ** Unfortunately the LKML thread stops after this patch and given that
>> the problem is still present in the latest source, this code wasn't
>> pushed into the kernel. Is there a reason for this or was it just
>> forgotten about? What can I do about this? I am happy to make a git
>> patch with the latest source if this will help.
> The patch would completely bypass LPBC-based brightness controls if the
> backlight happened to be off when the driver started, which isn't
> exactly what you want.
>


