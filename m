Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0H2SjI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:39:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34267 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0H2SjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=d+dvH4bcNoRzk2AziKKKMW8V8HD/NOx3/aOeWiCFkbbx6tPtAS8i4uATV3UvKHp9Sd
         IuFqXPwrp8rXvi2POgsIlhoHyALuIfSZvp2kIQz5NNcOsmFgzH0EyqoMLetWRNkLtoNc
         cQI//gz44qzQ9WaZoUqTO8NsOmxbLmEeyJcQQ=
MIME-Version: 1.0
In-Reply-To: <1283011478-27237-6-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-6-git-send-email-brgerst@gmail.com>
Date: Sun, 29 Aug 2010 21:38:27 +0300
X-Google-Sender-Auth: KDv0mbVjJxN65ksSMNomatX8Ddw
Message-ID: <AANLkTimFWOqqCf_YmnMKDFsL_yQ4Sv3gpEihw1mjjtwc@mail.gmail.com>
Subject: Re: [PATCH 05/11] x86-64: Disable preemption when using TS_USEDFPU
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Consolidates code and fixes the below race for 64-bit.
>
> commit 9fa2f37bfeb798728241cc4a19578ce6e4258f25
> Author: torvalds <torvalds>
> Date:   Tue Sep 2 07:37:25 2003 +0000
>
>    Be a lot more careful about TS_USEDFPU and preemption
>
>    We had some races where we testecd (or set) TS_USEDFPU together
>    with sequences that depended on the setting (like clearing or
>    setting the TS flag in %cr0) and we could be preempted in between,
>    which screws up the FPU state, since preemption will itself change
>    USEDFPU and the TS flag.
>
>    This makes it a lot more explicit: the "internal" low-level FPU
>    functions ("__xxxx_fpu()") all require preemption to be disabled,
>    and the exported "real" functions will make sure that is the case.
>
>    One case - in __switch_to() - was switched to the non-preempt-safe
>    internal version, since the scheduler itself has already disabled
>    preemption.
>
>    BKrev: 3f5448b5WRiQuyzAlbajs3qoQjSobw
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
