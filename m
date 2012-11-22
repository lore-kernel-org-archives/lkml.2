Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab2KVUHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:07:49 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:50783 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2KVUHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:07:45 -0500
MIME-Version: 1.0
In-Reply-To: <20121121140109.GA7549@shaftnet.org>
References: <1353422714-18327-1-git-send-email-pizza@shaftnet.org>
	<CACVXFVM=+Gus1_6U82G6_mszoRNsqb24Y+F7UPPLPBgzQasaew@mail.gmail.com>
	<20121120161011.GD18015@shaftnet.org>
	<20121120163309.GB4990@kroah.com>
	<20121120181203.GA7922@shaftnet.org>
	<20121121093528.4fe11c26@tom-ThinkPad-T410>
	<20121121140109.GA7549@shaftnet.org>
Date: Thu, 22 Nov 2012 09:45:23 +0800
Message-ID: <CACVXFVOuGQTLKSuFmTnv50-Eo0hzZSA2gh65upWu-E+439Dvsg@mail.gmail.com>
Subject: Re: [PATCH] [firmware_class] Fix compile with no builtin firmware
From: Ming Lei <tom.leiming@gmail.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 10:01 PM, Solomon Peachy <pizza@shaftnet.org> wrote:
> On Wed, Nov 21, 2012 at 09:35:28AM +0800, Ming Lei wrote:
>> Solomon, I can't duplicate the build failure with your .config on 3.7-rc5-next.
>
> Okay, so it's since been fixed.
>
>> >  * The #ifdef wraps code that pertains solely to built-in firmware, (ie
>> >    CONFIG_FIRMWARE_IN_KERNEL) and has an #else path for when it's disabled.
>> >  * There is no point in a CONFIG_FW_LOADER test inside firmware_class.c
>> >    when the file isn't even compiled unless CONFIG_FW_LOADER is defined.
>>
>> Enabling CONFIG_EXTRA_FIRMWARE still can make one firmware built in kernel
>> even though CONFIG_FIRMWARE_IN_KERNEL isn't defined, so your patch will break
>> this case.
>
> So... isn't the logical solution here to make CONFIG_EXTRA_FIRMARE
> depend on (or enable) CONFIG_FIRMWARE_IN_KERNEL?  After all, the two are
> apparently related.

No, it is not related closely, CONFIG_FIRMWARE_IN_KERNEL means
that all in-kernel-tree firmware blobs should be included in kernel binary,
but CONFIG_EXTRA_FIRMARE means that one additional firmware
image will be put into kernel binary.

>
> I can update my patch to include this, and rewrite the commit message so
> it's relevant to modern kernels, or I can just drop this and forget the
> whole affair.

Considered that there is no your problem in -linus tree or -next tree and
the current code works for long time, maybe it is better to not touch the code.
Or suggest you to study this kind of config options and firmware/Makefie first,
then figure out one proper patch.

Thanks,
-- 
Ming Lei
