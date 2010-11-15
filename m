Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800Ab0KOWHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:07:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57998 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758614Ab0KOWHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:07:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b1NpbWLlFmHYieg+HWwPzHCa5SIxYfqum/h4p04s5NtvgDhIC8VUAgbiz4qSXlj5Jw
         D+5m6yLnV+1b9yTx4gc2q59CLEj8v25GzuaYH3l4MePh/TmnmduBLhn9yHmG4cLuAk1+
         QZaF85nefgSyPJkChl0BNHjnGvBvKmvtJxVaw=
MIME-Version: 1.0
In-Reply-To: <4CE17FB6.7000800@redhat.com>
References: <4CD538CA.8010901@xs4all.nl>
	<87wroostw3.fsf@basil.nowhere.org>
	<m2hbfsu57i.fsf@igel.home>
	<87k4kospnd.fsf@basil.nowhere.org>
	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
	<4CE17FB6.7000800@redhat.com>
Date: Mon, 15 Nov 2010 23:07:15 +0100
Message-ID: <AANLkTim-2XE=4MbfDLXkg+jj=P5wj2cVKBHemRHLZn2L@mail.gmail.com>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
From: Richard Guenther <richard.guenther@gmail.com>
To: Jeff Law <law@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andreas Schwab <schwab@linux-m68k.org>,
        Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 7:45 PM, Jeff Law <law@redhat.com> wrote:
> On 11/08/10 03:49, Richard Guenther wrote:
>>
>> On Mon, Nov 8, 2010 at 12:03 AM, Andi Kleen<andi@firstfloor.org>  wrote:
>>>
>>> Andreas Schwab<schwab@linux-m68k.org>  writes:
>>>>
>>>> The asm fails to mention that it modifies *regs.
>>>
>>> It has a memory clobber, that should be enough, no?
>>
>> No.  A memory clobber does not cover automatic storage.
>
> A memory clobber should clobber anything in memory, including autos in
> memory; if it doesn't, then that seems like a major problem.  I'd like to
> see the rationale behind not clobbering autos in memory.

Non-address taken automatic storage.  (note that we don't excercise this
in optimization yet)

It's difficult to model thins kind of non-aliased memory with this kind
of aliasing mechanism (apart from taking all asms as clobbering
everything as we currently do).

Richard.

> Jeff
>
