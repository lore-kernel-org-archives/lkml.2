Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1BGHwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:52:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52587 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1BGHwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:52:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Sq3UjN8Vr3GEpttdbaj2cx0fsbUqcR8xSOkEaF0B30/0z+uyQgQssNTU7wyGLdYfOz
         V/s3zNQC4hK6ZSU5zrEVUKkHtjrVZ6C7pxjCsUy+wh2QlJjRHeOjDcG/6dNC01kg4AfC
         a/eOtxjqX0mspEdoH52Ke603wUNGgFNqjqEGI=
MIME-Version: 1.0
In-Reply-To: <20110206084440.a6c2df3b.rdunlap@xenotime.net>
References: <4D4EBAF4.9070403@gmail.com>
	<20110206084440.a6c2df3b.rdunlap@xenotime.net>
Date: Mon, 7 Feb 2011 08:52:41 +0100
Message-ID: <AANLkTi=T3TGYcxm2=C6QtYss09H9R+m0Zk9KDQepMqiL@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: XIP doesn't depend on block
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/6 Randy Dunlap <rdunlap@xenotime.net>:
> On Sun, 06 Feb 2011 16:15:00 +0100 Marco Stornelli wrote:
>
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> XIP doesn't depend on block symbol, then we can reorder the Kconfig.
>> For ext2 doesn't change the Kconfig behavior but if other fs will use
>> FS_XIP it won't need to include block support if not needed.
>
> Hi Marco,
>
> Do you know of a filesystem where this matters?
>

Yes, for example mine (pramfs) :)

>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>> ---
>>
>> --- Kconfig.orig      2011-01-19 00:14:02.000000000 +0100
>> +++ Kconfig   2011-02-06 16:04:51.000000000 +0100
>
> This filename should include path, like
> --- fs/Kconfig.orig
> +++ fs/Kconfig
>
>> @@ -9,13 +9,6 @@ if BLOCK
>>  source "fs/ext2/Kconfig"
>>  source "fs/ext3/Kconfig"
>>  source "fs/ext4/Kconfig"
>> -
>
> The 3 filesystems above are immediately under:
>
> if BLOCK
>
> so ext[234] depend on BLOCK.  Why would it matter about FS_XIP?
>

I don't know but for example even POSIX ACL was under "if BLOCK",
maybe there is only an historical refuse.

Marco
