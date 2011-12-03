Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1LCW7I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 17:59:08 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37136 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab1LCW7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 17:59:04 -0500
Message-ID: <4EDAA9B3.3010904@suse.cz>
Date: Sat, 03 Dec 2011 23:58:59 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111123 Thunderbird/9.0
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Jiri Slaby <jirislaby@gmail.com>, Keith Packard <keithp@keithp.com>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: g33: GPU hangs
References: <4ED7735A.1020903@suse.cz> <d08817$2d9rsk@azsmga001.ch.intel.com>
In-Reply-To: <d08817$2d9rsk@azsmga001.ch.intel.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 01:47 PM, Chris Wilson wrote:
> On Thu, 01 Dec 2011 13:30:18 +0100, Jiri Slaby <jslaby@suse.cz> wrote:
>> Hi,
>>
>> both yesterday and today, my GPU hung. Both happened when I opened
>> google front page in firefox.
>>
>> I'm running 3.2.0-rc3-next-20111130. Given it happened twice in the past
>> 24 hours, it looks like a regression from next-20111124. Or is this a
>> userspace issue (I might updated some packages)?
>>
>> i915_error_state dumps from the two hangs are here:
>> http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state_0
>> http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state_second
> 
> Both error states contain the same bug: a fence register in conflict
> with the command stream. The batch is using the buffer at 0x03d0000 
> as an untiled 40x40 rgba buffer with pitch 192. However, a fence
> register is programmed to
>   fence[3] = 03d00001
>     valid, x-tiled, pitch: 512, start: 0x03d00000, size: 1048576
> 
> Also note that buffer is also not listed as currently active, so
> presumably we reused the buffer as tiled (and so reprogrammed the
> fence registered) before the GPU retired the batch. That sounds eerily
> similar to this bug:

Hi, it seems like it's fixed by the patch. Thanks.

> From 2b76187d2f5fc2352e391914b1828f91f93bb356 Mon Sep 17 00:00:00 2001
> From: Chris Wilson <chris@chris-wilson.co.uk>
> Date: Tue, 29 Nov 2011 15:12:16 +0000
> Subject: [PATCH] drm/i915: Only clear the GPU domains upon a successful
>  finish

-- 
js
suse labs
