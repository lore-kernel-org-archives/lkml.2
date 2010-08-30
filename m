Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0H3AZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 20:25:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45576 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab0H3AZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 20:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wapMNPrjXIBbSMNnAyz0s8TsUR98Qs4EYHgXGChi4WdEp3DV/1AyZR8Kls8VqWK3z4
         ND17LcYFE3l3RWsyPO+hgQVYf9JS90dHlQHc8PgY3lylMqWf9XdmjXx4qhERXLwkBg+x
         NvyPDt7Gty7avzYOZp+q/WjT31tbOGjk3IHB0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=G+=Hc3e8Z+HH6yJPGi4TM3TyYZ6UvdUpHyBsC@mail.gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-7-git-send-email-brgerst@gmail.com>
	<AANLkTi=G+=Hc3e8Z+HH6yJPGi4TM3TyYZ6UvdUpHyBsC@mail.gmail.com>
Date: Sun, 29 Aug 2010 20:25:16 -0400
Message-ID: <AANLkTinVQFHG1nh5XBd1tJ29fBDjQc=QRThXySiPWd2q@mail.gmail.com>
Subject: Re: [PATCH 06/11] x86-64: Fix %cs value in convert_from_fxsr()
From: Brian Gerst <brgerst@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 2:41 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
>> While %ds still contains the userspace selector, %cs is KERNEL_CS
>> at this point.  Always get %cs from pt_regs.
>>
>> It actually is possible to get the correct segments for compat tasks,
>> but that involves using the [f]xsave instruction without a REX.W prefix.
>>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>
> It might be just me but the above description doesn't explain
> anything. What's the problem here? What is this fixing?

The %cs segment being reported to a compat task is flat out wrong.  It
is getting KERNEL_CS when it should be some userspace segment.  The
code segment may still be wrong, because the %cs in pt_regs may not
have been the segment where the instruction that flagged the exception
executed from.  That could be fixed by using fxsave without a REX.W
prefix when saving the state of compat tasks, which would save the
segment and 32-bit offset instead of the 64-bit offset for the code
and data pointers.  This is such a corner case that it probably isn't
worth putting much effort into fixing unless someone demonstrates a
real need for it.

--
Brian Gerst
