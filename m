Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab2ECVYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:24:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56687 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220Ab2ECVYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:24:15 -0400
Message-ID: <4FA2F769.40903@zytor.com>
Date: Thu, 03 May 2012 14:23:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, npiggin@gmail.com,
        jana@saout.de, jlbec@evilplan.org, linux-kernel@vger.kernel.org
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
References: <4FA2CAD9.6010808@zytor.com> <CA+55aFxrBghonjRvS=KK=5Oqw_Wj9PDh2wkDtVh7U9jw8=uTsA@mail.gmail.com> <4FA2CE5C.8000100@zytor.com> <20120503.144844.988487177633544388.davem@davemloft.net>
In-Reply-To: <20120503.144844.988487177633544388.davem@davemloft.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 11:48 AM, David Miller wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Thu, 03 May 2012 11:28:44 -0700
> 
>> +		"lea" __WORDSUFFIX " %2,%1\n\t"
>> +		"and" __WORDSUFFIX " %4,%1\n\t"
>> +		"shl" __WORDSUFFIX " $3,%1\n\t"
>> +		"shr" __WORDSUFFIX " %b1,%0\n\t"
>>
>> Also, for this sequence of instructions using %ecx unconditionally is
>> actually better (avoids REX prefixes on 64 bits.)
> 
> If it doesn't exist already, someone should really add bits to
> binutils so you guys don't have to string paste like this.
> 
> For example a bit a mnenomics that the assembler internally changes
> into the 64-bit or 32-bit variant based upon what bitness it is
> targetting.
> 
> We have these on sparc, for example "ldn" is transformed into "lduw"
> for 32-bit and "ldx" for 64-bit.

I don't think we really need it.  For the vast majority of all
instructions the size is given by the operands, and for the balance we
can generally use %z and/or <asm/asm.h>.  %z would be more useful if
there wasn't for the fact that some now quite old versions of gcc
incorrectly produce "ll" instead of "q".

	-hpa

