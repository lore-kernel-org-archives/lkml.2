Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0H3Gou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 02:44:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46765 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab0H3Got convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 02:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ISL5PkvALnasKNJeGgKqkb4RBxxOHc56oNTyfx8J/foX9ORu+3sZ55Gj6qFcQgyLLf
         cW3aeV5a/HnNdkBeiTmFg6ESGM8tqGmhsMhj6L+XQ1otzttN96cjEs0IQhNte/wO3qh1
         paNQcEUtg28jT7vdANzoGsQRRosIbW6Lt2p58=
MIME-Version: 1.0
In-Reply-To: <AANLkTinVQFHG1nh5XBd1tJ29fBDjQc=QRThXySiPWd2q@mail.gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-7-git-send-email-brgerst@gmail.com>
	<AANLkTi=G+=Hc3e8Z+HH6yJPGi4TM3TyYZ6UvdUpHyBsC@mail.gmail.com>
	<AANLkTinVQFHG1nh5XBd1tJ29fBDjQc=QRThXySiPWd2q@mail.gmail.com>
Date: Mon, 30 Aug 2010 09:44:48 +0300
X-Google-Sender-Auth: 4IqQNG6wHnSIAQXG2YAbXQU_HA8
Message-ID: <AANLkTikcZ1sWe4+j+Q6nw7ZNy-fi-=ojdvnZP5+N+QQY@mail.gmail.com>
Subject: Re: [PATCH 06/11] x86-64: Fix %cs value in convert_from_fxsr()
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
>>> While %ds still contains the userspace selector, %cs is KERNEL_CS
>>> at this point.  Always get %cs from pt_regs.
>>>
>>> It actually is possible to get the correct segments for compat tasks,
>>> but that involves using the [f]xsave instruction without a REX.W prefix.
>>>
>>> Signed-off-by: Brian Gerst <brgerst@gmail.com>

On Sun, Aug 29, 2010 at 2:41 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> It might be just me but the above description doesn't explain
>> anything. What's the problem here? What is this fixing?

On Mon, Aug 30, 2010 at 3:25 AM, Brian Gerst <brgerst@gmail.com> wrote:
> The %cs segment being reported to a compat task is flat out wrong.  It
> is getting KERNEL_CS when it should be some userspace segment.  The
> code segment may still be wrong, because the %cs in pt_regs may not
> have been the segment where the instruction that flagged the exception
> executed from.  That could be fixed by using fxsave without a REX.W
> prefix when saving the state of compat tasks, which would save the
> segment and 32-bit offset instead of the 64-bit offset for the code
> and data pointers.  This is such a corner case that it probably isn't
> worth putting much effort into fixing unless someone demonstrates a
> real need for it.

I sort of was able to deduce most of that from the original
description. However, I still don't quite understand what the problem
causes. Just a wrong cs reported to a signal handler or something
else?
