Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab0KWB1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 20:27:51 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47599 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab0KWB1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 20:27:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=ZzkrcewARSsn3l0QchJXuKBElqOHdjyhNq1fZgPjxw2e81ruY2j9NbQi2khwTygU5h
         Q5XdjyyyFePPHA9qG5nwIH0e+gXQjitqgftLafPpumvgYOPjvH5lD9mEGOXveNYR3bsb
         6TYeTUw3ODqVUNACZh0eVp/o7gTxDjYySbjUg=
MIME-Version: 1.0
In-Reply-To: <20101122164356.ab44c4ae.akpm@linux-foundation.org>
References: <1290385461-29831-1-git-send-email-vapier@gentoo.org>
 <20101122135855.6825700d.akpm@linux-foundation.org> <AANLkTikJQ4usvm9tx1Xm+LcfFgduMVRqPyQPpkYUyjff@mail.gmail.com>
 <20101122164356.ab44c4ae.akpm@linux-foundation.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 22 Nov 2010 20:27:28 -0500
X-Google-Sender-Auth: M5TF_leQ6MUvbX4yBdJ-hJzMM7Y
Message-ID: <AANLkTi=QptitoRwjh1vCgxkgYg6M=6qL7V5H6vZnYNOs@mail.gmail.com>
Subject: Re: [PATCH] romfs: have romfs_fs.h pull in necessary headers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 19:43, Andrew Morton wrote:
> On Mon, 22 Nov 2010 19:40:16 -0500 Mike Frysinger wrote:
>> On Mon, Nov 22, 2010 at 16:58, Andrew Morton wrote:
>> > On Sun, 21 Nov 2010 19:24:21 -0500 Mike Frysinger wrote:
>> >> This header uses things like __be32, so pull in linux/types.h.
>> >>
>> >> Further, it uses BLOCK_SIZE, so pull in linux/fs.h.
>> >>
>> >> --- a/include/linux/romfs_fs.h
>> >> +++ b/include/linux/romfs_fs.h
>> >> @@ -1,6 +1,9 @@
>> >> __#ifndef __LINUX_ROMFS_FS_H
>> >> __#define __LINUX_ROMFS_FS_H
>> >>
>> >> +#include <linux/types.h>
>> >> +#include <linux/fs.h>
>> >> +
>> >> __/* The basic structures of the romfs filesystem */
>> >>
>> >> __#define ROMBSIZE BLOCK_SIZE
>> >
>> > Better changelogs please.
>> >
>> > Does this fix any build error? __If so, is that build error present in
>> > 2.6.36 or earlier?
>>
>> headers should include the headers that define types/things that the
>> header itself needs
>
> I take that to mean "no" and "no", hence the fix is not needed in
> 2.6.37 and is not needed in -stable.

it's been broken for years, so people have long worked around it.  the
history is clear that there is no regression.  but headers should be
correct unto themselves.
-mike
