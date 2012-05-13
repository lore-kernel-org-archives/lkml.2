Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2EMQHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:07:16 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:48858 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2EMQHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:07:15 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Joe Perches <joe@perches.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 2/2] fat: use fat_msg_ratelimit in fat__get_entry.
References: <1336907039-18638-1-git-send-email-linkinjeon@gmail.com>
	<1336924011.31383.6.camel@joe2Laptop>
Date: Mon, 14 May 2012 01:07:11 +0900
In-Reply-To: <1336924011.31383.6.camel@joe2Laptop> (Joe Perches's message of
	"Sun, 13 May 2012 08:46:51 -0700")
Message-ID: <87bolsdpzk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Sun, 2012-05-13 at 07:03 -0400, Namjae Jeon wrote:
>> So this patch use fat_msg_ratelimit function about this message to decrease this messages.
> []
>> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
>> index aca191b..b2cdbf4 100644
>> --- a/fs/fat/dir.c
>> +++ b/fs/fat/dir.c
>> @@ -98,8 +98,8 @@ next:
>>  
>>  	*bh = sb_bread(sb, phys);
>>  	if (*bh == NULL) {
>> -		fat_msg(sb, KERN_ERR, "Directory bread(block %llu) failed",
>> -		       (llu)phys);
>> +		fat_msg_ratelimit(sb, KERN_ERR, "Directory bread(block %llu) "
>> +				"failed", (llu)phys);
>
> Please don't split format strings.
> It's much harder to grep.

Please fight with 80 columns guys before requesting it.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
