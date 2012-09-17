Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2IQWw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:52:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37404 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab2IQWwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:52:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120917142800.GH30673@fieldses.org>
References: <1347798200-2765-1-git-send-email-linkinjeon@gmail.com>
	<20120917142800.GH30673@fieldses.org>
Date: Tue, 18 Sep 2012 07:52:54 +0900
Message-ID: <CAKYAXd8kC5rZOaFS5kDitQ9R6yuy-WQFVLx+S584ph-p8d=vvg@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] Documentation: update nfs option in filesystem/vfat.txt
From: Namjae Jeon <linkinjeon@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/17, J. Bruce Fields <bfields@fieldses.org>:
> On Sun, Sep 16, 2012 at 08:23:20AM -0400, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> update nfs option in filesystem/vfat.txt
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  Documentation/filesystems/vfat.txt |   19 ++++++++++++++-----
>>  1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/filesystems/vfat.txt
>> b/Documentation/filesystems/vfat.txt
>> index de1e6c4..3371b8e 100644
>> --- a/Documentation/filesystems/vfat.txt
>> +++ b/Documentation/filesystems/vfat.txt
>> @@ -141,13 +141,22 @@ discard       -- If set, issues discard/TRIM
>> commands to the block
>>  		 device when blocks are freed. This is useful for SSD devices
>>  		 and sparse/thinly-provisoned LUNs.
>>
>> -nfs           -- This option maintains an index (cache) of directory
>> -		 inodes by i_logstart which is used by the nfs-related code to
>> -		 improve look-ups.
>> -
>> -		 Enable this only if you want to export the FAT filesystem
>> +nfs=full_unstable|limited_stable
>
Hi Bruce.
> You still want to accept just "nfs" (defaulting to "full_unstable"
> behavior), for backwards compatibility.
Agree. I will consider backwards compatibilty as your opinion.
>
> Also I don't find this full_unstable/limited_stable terminology very
> intuitive.  "stable" and "limited" could mean too many different things.
>
> Maybe "nostale_ro|stale_rw" ?
Yes, It would be better!
>
>> +	      -- Enable this only if you want to export the FAT filesystem
>>  		 over NFS
>>
>> +		 full_unstable:This option maintains an index (cache) of
>> +		 directory inodes by i_logstart which is used by
>> +		 the nfs-related code to improve look-ups.Full file operations
>> +		 (read/write) over NFS is supported but with cache eviction
>> +		 at NFS server, this could result in ESTALE issues.
>> +
>> +		 limited_stable:This options makes NFS support for FAT as
>> +		 read-only and provides stable inode based on the on-disk
>> +		 location of the MS-DOS directory entry.This helps in
>> +		 reconstruction of the inodes in case of lookup failure,
>> +		 making FAT behaviour stable with respect to ESTALE issues.
>
> This option still scares me a little.  Maybe a little more explanation:
>
> 		This option bases the inode number and filehandle on
> 		the location of an file in the MS-DOS directory entry.
> 		This ensures that ESTALE will not be returned after a
> 		file is evicted from the inode cache.  However, it means
> 		that operations such as rename, create, and unlink could
> 		cause filehandles that previously pointed at one file to
> 		point at a different file, potentially causing data
> 		corruption.  For this reason, this option also mounts
> 		the filesystem readonly.
Okay, I will update.

Thanks for your review!
>
> --b.
>
>> +
>>  <bool>: 0,1,yes,no,true,false
>>
>>  TODO
>> --
>> 1.7.9.5
>>
>
