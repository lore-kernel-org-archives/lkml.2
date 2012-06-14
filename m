Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab2FNWXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 18:23:03 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:51464 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab2FNWXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 18:23:01 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Stephen Warren <swarren@wwwdotorg.org>, Andrew Lunn <andrew@lunn.ch>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org, haojian.zhuang@gmail.com,
        linux-arm-kernel@lists.infradead.org, jic23@cam.ac.uk, kay@vrfy.org
Subject: Re: Follow-up to remaining issue with alignment of __log_buf in printk.c
References: <87aa05vgzg.fsf@free.fr> <4FDA3BB4.9040607@wwwdotorg.org>
X-URL: http://belgarath.falguerolles.org/
Date: Fri, 15 Jun 2012 00:22:43 +0200
Message-ID: <87y5np1qks.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> writes:

> Isn't that a bug in the toolchain; isn't the alignment of a struct
> required to be the greatest alignment of any of its members? Otherwise,
> this problem could arise with any usage of that struct.

I'm not a compiler expert, but I think EABI requires 64-bit data types to be
8-bytes aligned. If that assertion is true, then clearly my eabi compiler is a
little liar with its __alignof__(struct log) result.
And I think also that ISO C standard requires a structure to be aligned by
default to the <quote>least perfect multiple of the lowest common multiple of
the alignments of all the members of the struct</quote>. Which here means 8
bytes ...

> I suppose this could be worked around with something like:
> #define LOG_ALIGN max(__alignof__(struct log), __alignof__(u64))

Well, I wonder what is the correct approach here. In the end, the compiler
should be fixed ... But meanwhile, your proposition would solve the PXA
problem. The real deal is to know whether we want a compiler work-around in
printk.c ... and that's rather a policy issue than a technical one.

I wonder what others think about it ... let's wait for another pair of point of
views.

Cheers.

-- 
Robert

PS: For Andrew, I saw your patch. It won't solve my problem as my compiler
believes __alignof__(struct log) == 4 ... bad luck for me.

PPS: My toolchain is arm-2011.09
