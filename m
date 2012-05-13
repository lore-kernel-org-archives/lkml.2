Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2EMQKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:10:51 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:48862 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2EMQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:10:50 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Joe Perches <joe@perches.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 1/2] fat: add fat_msg_ratelimit.
References: <1336907005-18602-1-git-send-email-linkinjeon@gmail.com>
	<1336923908.31383.4.camel@joe2Laptop>
Date: Mon, 14 May 2012 01:10:47 +0900
In-Reply-To: <1336923908.31383.4.camel@joe2Laptop> (Joe Perches's message of
	"Sun, 13 May 2012 08:45:08 -0700")
Message-ID: <877gwgdptk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Sun, 2012-05-13 at 07:03 -0400, Namjae Jeon wrote:
>> I tried to add fat_msg_ratelimit to limit many message at once.
>> 
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>> ---
>>  fs/fat/fat.h  |    9 +++++++--
>>  fs/fat/misc.c |   18 ++++++++++--------
>>  2 files changed, 17 insertions(+), 10 deletions(-)
>> 
>> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
>> index 951d12b..3c581c7 100644
>> --- a/fs/fat/fat.h
>> +++ b/fs/fat/fat.h
>> @@ -333,8 +333,13 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...);
>>  	__fat_fs_error(sb, 1, fmt , ## args)
>>  #define fat_fs_error_ratelimit(sb, fmt, args...) \
>>  	__fat_fs_error(sb, __ratelimit(&MSDOS_SB(sb)->ratelimit), fmt , ## args)
>> -__printf(3, 4) __cold
>> -void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
>> +__printf(4, 5) __cold
>> +void __fat_msg(struct super_block *sb, int report, const char *level,
>> +			const char *fmt, ...);
>> +#define	fat_msg(sb, level, fmt, args...)		\
>> +	__fat_msg(sb, 1, level, fmt, ## args)
>> +#define	fat_msg_ratelimit(sb, level, fmt, args...)	\
>> +	__fat_msg(sb, __ratelimit(&MSDOS_SB(sb)->ratelimit), level, fmt, ## args)
>
> I think it better to move the test above the call
> and not change the fat_msg function at all.
>
> #define fat_msg_ratelimit(sb, level, fmt, args...)		\
> do {								\
> 	if (! __ratelimit(&MSDOS_SB(sb)->ratelimit))		\
> 		fsg_msg(sb, level, fmt, ##args);		\
> } while (0)

Looks sane. I myself don't care either "fat_fs_error vs yours" style.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
