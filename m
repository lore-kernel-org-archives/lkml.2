Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab0G2Le7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:34:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39746 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab0G2Le6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=X8yCfPUOnjfm92nzuw2n7dmswrC4ZlAUIeXv/40DzmynO2Y5UH76OLsZ+thlmZqsip
         mFBuD5VCx16ad6n7ghqztuyuZSpKFwEObz+bR+nnMUzY6CVYZu5UzYCZ+MaixfUaHel4
         voAlqMpV/cWJVS40p4aaAU7rpEoV/QEMkx0wk=
MIME-Version: 1.0
In-Reply-To: <4C505F86.7050509@cs.helsinki.fi>
References: <AANLkTin-9jtHP1xmhUp4uUQNZD64pN3Ee5Kn2cqH64Go@mail.gmail.com>
	<4C505F86.7050509@cs.helsinki.fi>
Date: Thu, 29 Jul 2010 12:34:56 +0100
Message-ID: <AANLkTintAmpBcxbZUmMd7B7yHpVKs77xHgkjSxMY_O6J@mail.gmail.com>
Subject: Re: [2.6.35-rc6 patch] increase kmemleak robustness at boot
From: Catalin Marinas <catalin.marinas@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 July 2010 17:49, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Daniel J Blueman wrote:
>>
>> I've consistently been experiencing kmemleak exhaust it's 400-entry
>> early-boot buffer and disabling itself; there have been reports of
>> this also, and I'm finding this on x86-64 with various debug options
>> enabled.
>>
>> If we issue a warning and allow the buffer to wrap, we don't need to
>> hit the kill-switch. While we lose track of some early potential
>> leaks, it's better than no functionality.
>>
>> Let me know if it's acceptable, and many thanks for such an excellent
>> tool,
>
> Is it just potential leaks that we lose or can this cause false positives?

I wouldn't go this route, it's a great source of false positives.
Given that it's not always easy to investigate a memory leak, adding
more false positives would just make people turn the tool off. There
are several things in place like crc checking and maybe that's why
Daniel doesn't get false positives but that's not always the case.

I would rather change the static early alloc buffer with something
like bootmem allocation (the recursiveness should be bound, kmemleak
tracks bootmem allocations as well). But I'm on holiday until middle
of August and not able to do any tests in this area.

-- 
Catalin
