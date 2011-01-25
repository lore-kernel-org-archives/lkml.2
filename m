Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1AYO22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:28:28 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:27659 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753677Ab1AYO21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:28:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAMJsPk1Ld/sX/2dsb2JhbAAMhAbNV5BlgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,374,1291611600"; 
   d="scan'208";a="89156242"
Message-ID: <4D3EDE07.1080200@teksavvy.com>
Date: Tue, 25 Jan 2011 09:28:23 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        mchehab@redhat.com
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3C5F73.2050408@teksavvy.com> <20110124175456.GA17855@core.coreip.homeip.net> <4D3E1A08.5060303@teksavvy.com> <20110125005555.GA18338@core.coreip.homeip.net> <4D3E4DD1.60705@teksavvy.com> <20110125042016.GA7850@core.coreip.homeip.net> <4D3E5372.9010305@teksavvy.com> <20110125045559.GB7850@core.coreip.homeip.net> <4D3E59CA.6070107@teksavvy.com> <20110125052902.GC7850@core.coreip.homeip.net>
In-Reply-To: <20110125052902.GC7850@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-25 12:29 AM, Dmitry Torokhov wrote:
> On Tue, Jan 25, 2011 at 12:04:10AM -0500, Mark Lord wrote:
>> On 11-01-24 11:55 PM, Dmitry Torokhov wrote:
>>> On Mon, Jan 24, 2011 at 11:37:06PM -0500, Mark Lord wrote:
..
>>> The options are:
>>>
>>> 1. Convert to EVIOCGKEYCODE2
>>> 2. Ignore errors from EVIOCGKEYCODE and go through all 65536 iterations.
>>
>> or 3. Revert/fix the in-kernel regression.
>>
>> The EVIOCGKEYCODE ioctl is supposed to return KEY_RESERVED for unmapped
>> (but value) keycodes, and only return -EINVAL when the keycode itself
>> is out of range.
> 
> You are inventing rules.  You are requesting a scancode->keycode
> mapping. If scancode is unknown/invalid for the device ioctl returns
> -EINVAL.

-EINVAL signals bad/invalid parameters.
That's NOT what is happening here.

> For unmapped - yes, either KEY_RESERVED or KEY_UNKNOWN should be
> returned. For invalid scancodes -EINVAL shoudl be returned. 

Exactly my point.  The scancode in question is 100% valid and mapable,
yet the kernel is rejecting it as -EINVAL.  Incorrect.

BUG. Regression. Breaks userspace. Must get fixed.

Cheers
