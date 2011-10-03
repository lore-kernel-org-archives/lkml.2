Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab1JCHUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 03:20:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1JCHUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 03:20:45 -0400
MIME-Version: 1.0
In-Reply-To: <1317620365.1804.7.camel@Joe-Laptop>
References: <1317617737-22035-1-git-send-email-linkinjeon@gmail.com>
	<1317620365.1804.7.camel@Joe-Laptop>
Date: Mon, 3 Oct 2011 16:20:44 +0900
Message-ID: <CAKYAXd-inw0qeRKcU+5+HOB9BQJBo461zbBiG8iXOesRekWcKA@mail.gmail.com>
Subject: Re: [PATCH 1/2] udf : enable error print in udf_read_tagged().
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/3 Joe Perches <joe@perches.com>:
> On Mon, 2011-10-03 at 13:55 +0900, Namjae Jeon wrote:
>> While reading metadata, if a problem occurs,
>> Print out only one of the five case.(It also does not show a checksum properly.)
>> Because currently it have been disable by undef udf_debug.
>> If there is a problem with scratched disc or loader, the user needs to know which error happened.
>> And I use pr_fmt instead of printk by joe's suggestion. I try to modify totally it to pr_fmt also.
> []
>> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> []
>> @@ -21,7 +23,7 @@
>>  #ifdef UDFFS_DEBUG
>>  #define udf_debug(f, a...) \
>>  do { \
>> -     printk(KERN_DEBUG "UDF-fs DEBUG %s:%d:%s: ", \
>> +     pr_debug("DEBUG %s:%d:%s: ", \
>>               __FILE__, __LINE__, __func__); \
>>       printk(f, ##a); \
>
> This isn't the same.
>
> You should probably just use
>
> #define udf_debug(fmt, ...)                                             \
>        pr_debug("DEBUG %s:%d:%s: " fmt,                                \
>                 __FILE__, __LINE__, __func__, __VA_ARGS__)
>
> or maybe let dynamic_debug add
> __FILE__, __LINE__ and __func__
> via the appropriate controls,
> so this might be appropriate.
>
> #define udf_debug(fmt, ...)                                             \
>        pr_debug("DEBUG " fmt, __VA_ARGS__)
>
Thanks joe~
>
>
