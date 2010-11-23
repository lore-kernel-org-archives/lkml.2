Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab0KWAkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:40:40 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45712 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab0KWAkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XJLUsmIoRjo5+x1Zx2U528gi7b/v+0Bl60nsGf9wwfax3sADOD0N/vH1IZdoq356C2
         f0oGPel3IcQNP5Aa2uVUrdeE4sFz6PMV9PFek7fNx80YCZwo6vk6BMziJjOxYzVpFW+X
         k1CO5H7AKZlqdhvSyMx1OX1UKrtUgcJjt39JA=
MIME-Version: 1.0
In-Reply-To: <20101122135855.6825700d.akpm@linux-foundation.org>
References: <1290385461-29831-1-git-send-email-vapier@gentoo.org> <20101122135855.6825700d.akpm@linux-foundation.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 22 Nov 2010 19:40:16 -0500
X-Google-Sender-Auth: Sxa-9jwsoIIO-OMYvThWcZKNI-A
Message-ID: <AANLkTikJQ4usvm9tx1Xm+LcfFgduMVRqPyQPpkYUyjff@mail.gmail.com>
Subject: Re: [PATCH] romfs: have romfs_fs.h pull in necessary headers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 16:58, Andrew Morton wrote:
> On Sun, 21 Nov 2010 19:24:21 -0500 Mike Frysinger wrote:
>> This header uses things like __be32, so pull in linux/types.h.
>>
>> Further, it uses BLOCK_SIZE, so pull in linux/fs.h.
>>
>> --- a/include/linux/romfs_fs.h
>> +++ b/include/linux/romfs_fs.h
>> @@ -1,6 +1,9 @@
>>  #ifndef __LINUX_ROMFS_FS_H
>>  #define __LINUX_ROMFS_FS_H
>>
>> +#include <linux/types.h>
>> +#include <linux/fs.h>
>> +
>>  /* The basic structures of the romfs filesystem */
>>
>>  #define ROMBSIZE BLOCK_SIZE
>
> Better changelogs please.
>
> Does this fix any build error?  If so, is that build error present in
> 2.6.36 or earlier?

headers should include the headers that define types/things that the
header itself needs
-mike
