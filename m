Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0L1VgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 16:36:10 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42825 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab0L1VgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 16:36:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sjNYQ7v0Z6aeDadB9tqlDsnFEJna1yOzuPpLSY8w3DgsKEUkhpKENqB9ClRQJwx2+D
         aqtAXPCawwA5Wtua9wXCjXGikqbRgZRAQa6L6EHCO/xMP5zo4XRkkPEfAFQ70PMSjh8Z
         hVnYHsl1fKwFLAsJYPvuCh5MCTnDDMk0B7zoc=
MIME-Version: 1.0
In-Reply-To: <4D1A46D2.1000702@zytor.com>
References: <4D0C072D.1040201@kernel.org>
	<4D1A46D2.1000702@zytor.com>
Date: Tue, 28 Dec 2010 13:36:07 -0800
X-Google-Sender-Auth: HMDpx6QRJgNsG_ecM3xIUCtAvZA
Message-ID: <AANLkTik7Zbc4KW0rS1h=qsLwm-NCxHNjLUZnLi1t0sr5@mail.gmail.com>
Subject: Re: [PATCH 0/3] memblock related top down
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 12:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/17/2010 04:58 PM, Yinghai Lu wrote:
>> Please check
>>
>> Those three patches to make memblock allocation more top to down.
>>
>
> Please explain what you mean with "more top to down".  Not what the code
> does, but what is the goal of the patchset.

for example first node with 16g ram, it is into two parts: [0, 2g),
and [4g, 18g).

alloc_bootmem will get allocation from [0, 2g) always until we have
can not find more.

with third patch, it will try to get from [4g, 18g) at first.

second patch is need to applied before third patch, because old way
happenly get under 4g for generic bootmem under 4g

First one is trying not to put page table for [0, 4g) under 512M.

Thanks

Yinghai
