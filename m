Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0H2Xi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:38:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53544 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0H2Xi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e1zptaFfYXQCC8rH0volefRqHQ4BP1iDw6Q6t6Y9Ijl9M34MvPyrqfOWkFaLy35vkz
         3ivulmknlkNhQapM4wVDBwVYOh5X2rNmqGcnToswnkweJt6GY/4qiHOg2tSCnobsZq2a
         Xic4S3qj9RqDXyRBnKqLVrj1xTRuUs0yaWHeo=
MIME-Version: 1.0
In-Reply-To: <AANLkTinnhht86aKkmHKypmgmThJP8a1rGEXFkwyW7dc3@mail.gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-11-git-send-email-brgerst@gmail.com>
	<AANLkTinnhht86aKkmHKypmgmThJP8a1rGEXFkwyW7dc3@mail.gmail.com>
Date: Sun, 29 Aug 2010 19:38:57 -0400
Message-ID: <AANLkTik7Gv3xoZphR0VRkHdr3Z1tvO484S-zkYncC2K7@mail.gmail.com>
Subject: Re: [PATCH 10/11] x86: Remove unnecessary ifdefs from i387 code.
From: Brian Gerst <brgerst@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 3:00 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
>> Remove ifdefs for code that the compiler can optimize away on 64-bit.
>>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>
>> @@ -74,10 +74,8 @@ static void __cpuinit init_thread_xstate(void)
>>
>>        if (cpu_has_fxsr)
>>                xstate_size = sizeof(struct i387_fxsave_struct);
>> -#ifdef CONFIG_X86_32
>>        else
>>                xstate_size = sizeof(struct i387_fsave_struct);
>> -#endif
>>  }
>
> I guess this is OK but keep in mind that cpu_has_fsxr is _not_
> optimized by the compiler on 64-bit so the change probably increases
> kernel text by few bytes.
>
> Acked-by: Pekka Enberg <penberg@kernel.org>
>

FXSR is a required feature on 64-bit, therefore cpu_has_fxsr is always true.

--
Brian Gerst
