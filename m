Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0H3Afz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 20:35:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51804 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab0H3Afy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 20:35:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CNTnTID68MvoAdkzZsdM5Vf3yk7DtRfqwti+R+SsgOxYcY2/Z0k/z6ErK2WkdDtF9m
         o5tcdCVceGoI7JOJ8m8EX3mtC3RB38XtjesLUn7T5a7+r+IozoN+8ZJ6g4UO8Esr/OzO
         0GvlRTfnFkiNDYNnTjDS/PojAJNnCFv1TUM9Q=
MIME-Version: 1.0
In-Reply-To: <AANLkTikXeC--5PuuhmJgxDr8MAg97rC5OecsV3HNPz=g@mail.gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-4-git-send-email-brgerst@gmail.com>
	<AANLkTikXeC--5PuuhmJgxDr8MAg97rC5OecsV3HNPz=g@mail.gmail.com>
Date: Sun, 29 Aug 2010 20:35:52 -0400
Message-ID: <AANLkTinZ1viu=MWZUhH6M_ztpzg7yYG-4Rh26PkDyVQ_@mail.gmail.com>
Subject: Re: [PATCH 03/11] x86: Merge tolerant_fwait()
From: Brian Gerst <brgerst@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 2:32 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
>> Now that 32-bit can handle exceptions from the kernel, switch to using
>> the 64-bit version of tolerant_fwait() without fnclex.  In the unlikely
>> event an exception is triggered, it is simply ignored.
>>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>
> Why is 32-bit able to handle exceptions? Is that part of this series
> or is it some existing commit in tip or linus?
>

Commit e2e75c915de045f0785387dc32f55e92fab0614c merged the 32-bit and
64-bit math exception handlers into one, which calls
fixup_exception().

--
Brian Gerst
