Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0G1SjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:39:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55590 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0G1SjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TusbGR9ne18duR3mhIuZFkr5yhv9mkjUL0pwz5vA+KrQ3cTHLHq335Ex0CI6dK+gvu
         0wna8MVoh1vtSXt3eNrYpcXdrHKy1V/Qdo2vxn3+bn+Xn0C41ls3VEgXW5dzfuQsxe/V
         Xh2ocBdqf7xYpqp2k9fJsizGwYG1JnEBz7x2A=
MIME-Version: 1.0
In-Reply-To: <4C505F86.7050509@cs.helsinki.fi>
References: <AANLkTin-9jtHP1xmhUp4uUQNZD64pN3Ee5Kn2cqH64Go@mail.gmail.com>
	<4C505F86.7050509@cs.helsinki.fi>
Date: Wed, 28 Jul 2010 19:39:02 +0100
Message-ID: <AANLkTimQTwSXQXLzoHvmQ-L++O53w0S6jFRmpQ76-Qp3@mail.gmail.com>
Subject: Re: [2.6.35-rc6 patch] increase kmemleak robustness at boot
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@gmail.com>,
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

I don't get any false positives having had the buffer wrap a number of
times at early-boot; not to say this can't cause any.

It seems that some kernel debug options are doing heavy early-boot
allocations, so getting any false-positives would likely be a triple
edge case.

Thanks,
  Daniel
-- 
Daniel J Blueman
