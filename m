Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0KHSPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:15:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46772 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0KHSPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:15:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=i2wbhnYN6F21r0yHQ7nn+K3tQY4KC+PNQPbfYz2Eo5F3780cbLsEiMxT4NSgMC2Af2
         9lneZgl/t4Z4le1B4XEil2BlfS5Jj6aLdYuZqFSitPKeIV8B7tXKpcsvgD2pCOPfAE8t
         tkZdJ+c0ffSKpaCmN7EzvVA0JXpeAocm7fBTI=
Message-ID: <4CD843DC.10106@gmail.com>
Date: Mon, 08 Nov 2010 18:39:24 +0000
From: Dave Korn <dave.korn.cygwin@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Richard Guenther <richard.guenther@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>, Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>	<m2hbfsu57i.fsf@igel.home> <87k4kospnd.fsf@basil.nowhere.org>	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com> <877hgorrj1.fsf@basil.nowhere.org>
In-Reply-To: <877hgorrj1.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 11:20, Andi Kleen wrote:

> An asm with live inputs and outputs should never be optimized
> way. If 4.5.1 started doing that it's seriously broken.

  I don't see that.  Consider:

void foo (void)
{
  int x, y, z;
  x = 23;
  y = x + 1;
  z = y + 1;
}

  So far, you'd agree the compiler may optimise the entire function away?  So
why not this:

void foo (void)
{
  int x, y, z;
  x = 23;
  asm ("do something" : "=r" (y) : "r" (x) );
  z = y + 1;
}

  ?

    cheers,
      DaveK
