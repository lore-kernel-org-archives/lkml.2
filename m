Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3AGOjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:39:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:41803 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3AGOjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:39:15 -0500
Message-ID: <50EADE11.1040704@windriver.com>
Date: Mon, 7 Jan 2013 09:39:13 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: delete super ancient PC-XT driver for 1980's hardware
References: <1357349252-32346-1-git-send-email-paul.gortmaker@windriver.com> <50EA4F49.5000801@gmail.com>
In-Reply-To: <50EA4F49.5000801@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-01-06 11:30 PM, Robert Hancock wrote:
> On 01/04/2013 07:27 PM, Paul Gortmaker wrote:
>> This driver was for the 8 bit ISA cards that were installed in
>> the PC-XT machines of 1980 vintage.  They supported the dual
>> ribbon cable MFM drives of 10-20MB capacity, and ran at a 3:1
>> interleave, giving performance on the order of 128kB/s.
>>
>> By the introduction of the PC-AT (286) these controllers were
>> already scrapped in favour of 16 bit controllers with some onboard
>> RAM that could support a 1:1 interleave.
>>
>> The git history doesn't show any evidence of runtime fixes that
>> would reflect active usage; instead just the usual tree-wide API
>> type changes/cleanups.  Going back to in-source changelogs, the
>> last "runtime" fix that is evident is something I did over a
>> dozen years ago[1] -- and even back then, the hardware was long
>> since unavailable, so that ancient fix was also not runtime tested.
>>
>> The time is long overdue for this to get flushed, so lets get
>> rid of it before anyone wastes more time doing builds and sparse
>> checks etc. on long since dead code.
> 
> Although this hardware is obviously long obsolete, it's conceivable that 
> someone could still drag out an old MFM/RLL controller and run it on a 
> non-completely-ancient PC with ISA slots in order to recover data from 
> an old drive or something. Given that the code doesn't have wide-ranging 
> effects beyond a couple of files, I'd lean towards keeping it unless 
> there's some reason to believe it's hopelessly broken.

No - there is a different driver for that,  see block/hd.c

In any case, if someone was faced with such a data recovery mission,
they would be best to boot up an old kernel as part of their quest,
since expecting drivers that have been bitrotting for decades to
still work reliably is not wise.

P.
--

> 
