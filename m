Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0ICIXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:23:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34365 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab0ICIX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:23:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nEp3EYeakOz8ESGUtcwrqsMRZTChRHDWjgG14g1CTLx3g4jUD2nKO3xUfK1TEkqtli
         UeitQorMxwzNw37xwStaFNQZeeZwLxuUV6jzozhom4OZdzr8mxNtD/Bp4P0ABBJy/0RZ
         s0kYr/vuvHhrM77qjzGjUNphED5SZv1+6lu8U=
Message-ID: <4C80B07B.7050102@suse.cz>
Date: Fri, 03 Sep 2010 10:23:23 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] FS: btrfs, use helpers for rlimits
References: <1265832009-8070-1-git-send-email-jslaby@suse.cz> <20100210200134.GK18175@think>
In-Reply-To: <20100210200134.GK18175@think>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 09:01 PM, Chris Mason wrote:
> Thanks, I have this queued up for .34

Hi, this is still not merged. Was it lost?

> On Wed, Feb 10, 2010 at 09:00:09PM +0100, Jiri Slaby wrote:
>> Make sure compiler won't do weird things with limits. E.g. fetching
>> them twice may return 2 different values after writable limits are
>> implemented.
>>
>> I.e. either use rlimit helpers added in
>> 3e10e716abf3c71bdb5d86b8f507f9e72236c9cd
>> or ACCESS_ONCE if not applicable.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Chris Mason <chris.mason@oracle.com>
>> Cc: linux-btrfs@vger.kernel.org
>> ---
>>  fs/btrfs/inode.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index c41db6d..5aa0cef 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -3256,8 +3256,7 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
>>  		return 0;
>>  
>>  	if (attr->ia_size > inode->i_size) {
>> -		unsigned long limit;
>> -		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
>> +		unsigned long limit = rlimit(RLIMIT_FSIZE);
>>  		if (attr->ia_size > inode->i_sb->s_maxbytes)
>>  			return -EFBIG;
>>  		if (limit != RLIM_INFINITY && attr->ia_size > limit) {
>> -- 
>> 1.6.6.1
>>


-- 
js
suse labs
