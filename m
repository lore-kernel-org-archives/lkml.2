Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab0FKJSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:18:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43627 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757726Ab0FKJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:18:33 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [PATCH -mm] only drop root anon_vma if not self
References: <AANLkTin1OS3LohKBvWyS81BoAk15Y-riCiEdcevSA7ye@mail.gmail.com>
	<1275929000.3021.56.camel@e102109-lin.cambridge.arm.com>
	<AANLkTilsCkBiGtfEKkNXYclsRKhfuq4yI_1mrxMa8yJG@mail.gmail.com>
	<AANLkTik-cwrabXH_bQRPFtTo3C9r30B83jMf4IwJKCms@mail.gmail.com>
	<20100609211617.3e7e41bd@annuminas.surriel.com>
	<AANLkTin9UTy3qSWJ8u3b1hwhnsX5NHCZNzkFbH9_-vIZ@mail.gmail.com>
	<1276168866.24535.25.camel@e102109-lin.cambridge.arm.com>
	<AANLkTikl2Lp6dhDIN2NpyZHJne_vhOYJrwwBGebkslCf@mail.gmail.com>
Date: Fri, 11 Jun 2010 10:17:36 +0100
In-Reply-To: <AANLkTikl2Lp6dhDIN2NpyZHJne_vhOYJrwwBGebkslCf@mail.gmail.com>
	(Dave Young's message of "Fri, 11 Jun 2010 16:08:08 +0800")
Message-ID: <tnxaar2c4i7.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Jun 2010 09:17:41.0322 (UTC) FILETIME=[F1704AA0:01CB0946]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young <hidave.darkstar@gmail.com> wrote:
> On Thu, Jun 10, 2010 at 7:21 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
>> On Thu, 2010-06-10 at 02:30 +0100, Dave Young wrote:
>>> On Thu, Jun 10, 2010 at 9:16 AM, Rik van Riel <riel@redhat.com> wrote:
>>> > On Wed, 9 Jun 2010 17:19:02 +0800
>>> > Dave Young <hidave.darkstar@gmail.com> wrote:
>>> >
>>> >> > Manually bisected mm patches, the memleak caused by following patch:
>>> >> >
>>> >> > mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
>>> >>
>>> >>
>>> >> So I guess the refcount break, either drop-without-get or over-drop
>>> >
>>> > I'm guessing I did not run the kernel with enough debug options enabled
>>> > when I tested my patches...
>>> >
>>> > Dave & Catalin, thank you for tracking this down.
>>> >
>>> > Dave, does the below patch fix your issue?
>>>
>>> Yes, it fixed the issue. Thanks.
>>
>> Thanks for investigating this issue.
>>
>> BTW, without my kmemleak nobootmem patch (and CONFIG_NOBOOTMEM enabled),
>> do you get other leaks (false positives).
>
> I didn't see difference before/after apply your patch, how to test
> specific to bootmem?

With Rik's patch applied and CONFIG_NOBOOTMEM enabled, do you get any
false postives if my kmemleak patch isn't applied?

Thanks.

-- 
Catalin
