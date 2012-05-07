Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab2EGI3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:29:50 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51333 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab2EGI3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:29:44 -0400
MIME-Version: 1.0
In-Reply-To: <1336378205.1933.3.camel@x61.thuisdomein>
References: <1336377752-23985-1-git-send-email-levinsasha928@gmail.com> <1336378205.1933.3.camel@x61.thuisdomein>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 7 May 2012 10:29:23 +0200
Message-ID: <CA+1xoqcWvJbGgaWt-5XvANH5zZiMXpZVZEQv4cWTr1XHdPu-7Q@mail.gmail.com>
Subject: Re: [PATCH] ramster: depend on CONFIG_NET for sock_* functions
To: Paul Bolle <pebolle@tiscali.nl>
Cc: gregkh@linuxfoundation.org, dan.magenheimer@oracle.com,
        sjenning@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 10:10 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Mon, 2012-05-07 at 10:02 +0200, Sasha Levin wrote:
>> Building ramster without CONFIG_NET would cause linkage issue due to missing
>
> I'd say s/CONFIG_NET/NET/
>
>> sock_*() functions in cluster/tcp.c
>>
>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
>> ---
>>  drivers/staging/ramster/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/ramster/Kconfig b/drivers/staging/ramster/Kconfig
>> index 4af1f8d..8e334cb 100644
>> --- a/drivers/staging/ramster/Kconfig
>> +++ b/drivers/staging/ramster/Kconfig
>> @@ -1,6 +1,6 @@
>>  config RAMSTER
>>       bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
>> -     depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM
>> +     depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM && CONFIG_NET
>
> s/CONFIG_NET/NET/ again, I'd say. How was this tested?

Hm... ran the build again with the patch and noticed it stopped
complaining, but apparently it wasn't enough.
