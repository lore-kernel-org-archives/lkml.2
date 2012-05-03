Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab2ECSuC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:50:02 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46351 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126Ab2ECSuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:50:00 -0400
Date: Thu, 03 May 2012 14:48:44 -0400 (EDT)
Message-Id: <20120503.144844.988487177633544388.davem@davemloft.net>
To: hpa@zytor.com
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, npiggin@gmail.com,
        jana@saout.de, jlbec@evilplan.org, linux-kernel@vger.kernel.org
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FA2CE5C.8000100@zytor.com>
References: <4FA2CAD9.6010808@zytor.com>
	<CA+55aFxrBghonjRvS=KK=5Oqw_Wj9PDh2wkDtVh7U9jw8=uTsA@mail.gmail.com>
	<4FA2CE5C.8000100@zytor.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 03 May 2012 11:48:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 03 May 2012 11:28:44 -0700

> +		"lea" __WORDSUFFIX " %2,%1\n\t"
> +		"and" __WORDSUFFIX " %4,%1\n\t"
> +		"shl" __WORDSUFFIX " $3,%1\n\t"
> +		"shr" __WORDSUFFIX " %b1,%0\n\t"
> 
> Also, for this sequence of instructions using %ecx unconditionally is
> actually better (avoids REX prefixes on 64 bits.)

If it doesn't exist already, someone should really add bits to
binutils so you guys don't have to string paste like this.

For example a bit a mnenomics that the assembler internally changes
into the 64-bit or 32-bit variant based upon what bitness it is
targetting.

We have these on sparc, for example "ldn" is transformed into "lduw"
for 32-bit and "ldx" for 64-bit.
