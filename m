Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2JIACt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 20:02:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37472 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab2JIACp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 20:02:45 -0400
MIME-Version: 1.0
In-Reply-To: <20121008185347.GA5574@fieldses.org>
References: <1349598782-3286-1-git-send-email-linkinjeon@gmail.com>
	<20121008185347.GA5574@fieldses.org>
Date: Tue, 9 Oct 2012 09:02:43 +0900
Message-ID: <CAKYAXd8+R=ERxZzyH9c8i9TxK0H_tOAyosa5vqhdtF2NXMfsoQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] Documentation: update nfs option in filesystem/vfat.txt
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

2012/10/9, J. Bruce Fields <bfields@fieldses.org>:
> On Sun, Oct 07, 2012 at 04:33:02AM -0400, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> update nfs option in filesystem/vfat.txt
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  Documentation/filesystems/vfat.txt |   23 ++++++++++++++++++-----
>>  1 file changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/filesystems/vfat.txt
>> b/Documentation/filesystems/vfat.txt
>> index de1e6c4..d62f8e6 100644
>> --- a/Documentation/filesystems/vfat.txt
>> +++ b/Documentation/filesystems/vfat.txt
>> @@ -141,13 +141,26 @@ discard       -- If set, issues discard/TRIM
>> commands to the block
>>  		 device when blocks are freed. This is useful for SSD devices
>>  		 and sparse/thinly-provisoned LUNs.
>>
>> -nfs           -- This option maintains an index (cache) of directory
>> -		 inodes by i_logstart which is used by the nfs-related code to
>> -		 improve look-ups.
>> -
>> -		 Enable this only if you want to export the FAT filesystem
>> +nfs= stale_rw|nostale_ro
>> +	      -- Enable this only if you want to export the FAT filesystem
>>  		 over NFS
>>
>> +		 stale_rw:This option maintains an index (cache) of directory
>> +		 inodes by i_logstart which is used by the nfs-related code to
>> +		 improve look-ups.Full file operations (read/write) over NFS is
>> supported
>> +		 but with cache eviction at NFS server, this could result in ESTALE
>> issues.
>> +
>> +		 nostale_ro:This option bases the inode number and filehandle on the
>> on-disk
>> +		 location of a file in the MS-DOS directory entry.This ensures that
>> ESTALE
>> +		 will not be returned after a file is evicted from the inode cache.
>> However,
>> +		 it means that operations such as rename, create and unlink could
>> cause
>> +		 filehandles that previously pointed at one file to point at a
>> different file,
>> +		 potentially causing data corruption. For this reason, this option also
>> mounts
>> +		 the filesystem readonly.
>> +
>> +		 To maintain backward compatibility, '-o nfs' is also accepted,
>> defaulting to
>> +		 stale_rw
>> +
>
> The documentation makes more sense to me now, thanks.
Thanks for your review.
>
> --b.
>
