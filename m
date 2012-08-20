Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2HTUrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:47:37 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:34724 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab2HTUrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:47:35 -0400
From: Jim Meyering <jim@meyering.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: a few strncpy-related patches
In-Reply-To: <m24nnx8ggt.fsf@firstfloor.org> (Andi Kleen's message of "Mon, 20
	Aug 2012 13:18:42 -0700")
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
	<m24nnx8ggt.fsf@firstfloor.org>
Date: Mon, 20 Aug 2012 22:47:27 +0200
Message-ID: <87393hl28w.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jim Meyering <jim@meyering.net> writes:
>
>> I've seen a few too many cases of strncpy misuse.
>> Looking through linux sources, I spotted/fixed these:
>>
>> [PATCH] ACPI: remove unwarranted use of strncpy
>> [PATCH] fs/9p: avoid debug OOPS when reading a long symlink
>> [PATCH] kmemleak: avoid buffer overrun: NUL-terminate strncpy-copied
>> [PATCH] bfa: avoid buffer overrun for 12-byte model name
>> [PATCH] cifs: remove misleading strncpy: each name has length < 16
>
> Better to convert tham all to strlcpy?
>
> The kernel has it.

Anything is better than strncpy.
Is there consensus here that strlcpy is preferred?
Would the integrator(s) even require consensus?

    $ git grep -w strncpy|wc -l
    987
    $ git grep -w strlcpy|wc -l
    1345

In any case, shouldn't fixing bugs and obvious misuse be separate
from any global NSC conversion?
