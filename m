Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0KIN5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:57:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab0KIN5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:57:22 -0500
From: Andreas Schwab <schwab@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Michael Matz <matz@suse.de>, Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>
	<m2hbfsu57i.fsf@igel.home> <87k4kospnd.fsf@basil.nowhere.org>
	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
	<877hgorrj1.fsf@basil.nowhere.org> <4CD843DC.10106@gmail.com>
	<Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
	<20101109134816.GB29433@basil.fritz.box>
X-Yow: Mary Tyler Moore's SEVENTH HUSBAND is wearing my DACRON TANK TOP
 in a cheap hotel in HONOLULU!
Date: Tue, 09 Nov 2010 14:57:01 +0100
In-Reply-To: <20101109134816.GB29433@basil.fritz.box> (Andi Kleen's message of
	"Tue, 9 Nov 2010 14:48:16 +0100")
Message-ID: <m3lj52txaq.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> @@ -142,7 +142,7 @@ static int i8k_smm(struct smm_regs *regs)
>  		"lahf\n\t"
>  		"shrl $8,%%eax\n\t"
>  		"andl $1,%%eax\n"
> -		:"=a"(rc)
> +		:"=a"(rc), "=m" (*regs)

I think this should be "+m".

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
