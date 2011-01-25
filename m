Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1AYFQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:16:05 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:51779 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751257Ab1AYFQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:16:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAJvrPU1Ld/sX/2dsb2JhbAAMhAfMbJBjgSSDOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,372,1291611600"; 
   d="scan'208";a="89131902"
Message-ID: <4D3E5C8F.1080709@teksavvy.com>
Date: Tue, 25 Jan 2011 00:15:59 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3C5F73.2050408@teksavvy.com> <20110124175456.GA17855@core.coreip.homeip.net> <4D3E1A08.5060303@teksavvy.com> <20110125005555.GA18338@core.coreip.homeip.net> <4D3E4DD1.60705@teksavvy.com> <20110125042016.GA7850@core.coreip.homeip.net> <4D3E5372.9010305@teksavvy.com> <20110125045559.GB7850@core.coreip.homeip.net> <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com>
In-Reply-To: <4D3E5A91.30207@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-25 12:07 AM, Mark Lord wrote:
> On 11-01-25 12:04 AM, Mark Lord wrote:
..
>> The EVIOCGKEYCODE ioctl is supposed to return KEY_RESERVED for unmapped
>> (but value) keycodes, and only return -EINVAL when the keycode itself
>> is out of range.
>>
>> That's how it worked in all kernels prior to 2.6.36,
>> and now it is broken.  It now returns -EINVAL for any unmapped keycode,
>> even though keycodes higher than that still have mappings.

Actually, what changed could be something different:
it's possible that this bug was always there,
and older kernels had a more complete default keymap
for the remote than that in 2.6.36+, thereby never
triggering the bug.  But I don't know that, and my best
efforts to-date to locate any of this in the kernel
have been futile.  Oh well.  :)

>> This is a bug, a regression, and breaks userspace.
>> I haven't identified *where* in the kernel the breakage happened,
>> though.. that code confuses me.  :)
> 
> Note that this device DOES have "flat scancode space",
> and the kernel is now incorrectly signalling an error (-EINVAL)
> in response to a perfectly valid query of a VALID (and mappable)
> keycode on the remote control
> 
> The code really is a valid button, it just doesn't have a default mapping
> set by the kernel (I can set a mapping for that code from userspace and it works).
> 
> This is a BUG.  Returning -EINVAL here is entirely wrong.

