Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2LMXJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:09:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61229 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2LMXJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:09:31 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-95-50ca602929f8
From: =?UTF-8?B?7J207LC966eM?= <cm224.lee@samsung.com>
To: "'Namjae Jeon'" <linkinjeon@gmail.com>, jaegeuk.kim@samsung.com
Cc: "'Amit Sahrawat'" <a.sahrawat@samsung.com>,
        "'Namjae Jeon'" <namjae.jeon@samsung.com>,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org
References: <1355409851-6389-1-git-send-email-linkinjeon@gmail.com>
In-reply-to: <1355409851-6389-1-git-send-email-linkinjeon@gmail.com>
Subject: RE: [f2fs-dev] [PATCH v2] f2fs: fix up f2fs_get_parent issue to
	retrieve correct parent inode number
Date: Fri, 14 Dec 2012 08:09:28 +0900
Message-id: <060d01cdd986$e708a180$b519e480$%lee@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3ZQF1LYmlTU4nES2S2vrhAJR8PzQARjg3g
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY13NhFMBBifnSlvs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVsaXjNVNAgVbHkdi9zA+Ns0S5GTg4JAROJX5+mskLY
	YhIX7q1n62Lk4hASWMYosan9DzNM0aG+L4wQiemMEr9XfWSCcP4wStz73MECUsUmYCax8d4V
	MFtEwFHi9O+vYGOZBfYxSnTvEQKxhQScJW6sucIEYnMKuEh8+NPEBmILC+RLrF/6CayeRUBV
	4uTu/ewgNq+ArcSWv5uZIWxBiR+T77FAzFSXmDRvETOELS+xec1bIJsD6FJ1iUd/dUFMEQEj
	ietvnSEqRCT2vXjHCDFdQOLb5EMsENWyEpsOMIN8IiGwil3i0rkTLBD/SkocXHGDZQKjxCwk
	i2chWTwLyeJZSFYsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRESY1I7GFc2WBxiFOBg
	VOLh/Sh0KkCINbGsuDL3EKMEB7OSCG+vH1CINyWxsiq1KD++qDQntfgQow/Q5ROZpUST84Hx
	n1cSb2hsbGJmYmpibmlqbopDWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QDY0dWjEx+8rpi
	H4PXh3a1/7hf6tUv5jNVl+nALXP32MKD6XUPZyWet2B/mF9c3HOXTeTDOrUNDfFeEZ6aalrc
	/122Kmr2n+XeHXV/zrV0BZXnUSdizHiMJh7JvGy2qf/B/L1ySU/5M8X2HMxY8YArv8v+V1qi
	92zejt9HFs/5c/zPWaf1U1RslFiKMxINtZiLihMB0LKFeN4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQV3NhFMBBkf+iFjs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbGl4zVTQIFWx
	5HYvcwPjbNEuRk4OCQETiUN9XxghbDGJC/fWs3UxcnEICUxnlPi96iMThPOHUeLe5w4WkCo2
	ATOJjfeugNkiAo4Sp39/ZQWxmQX2MUp07xECsYUEnCVurLnCBGJzCrhIfPjTxAZiCwvkS6xf
	+gmsnkVAVeLk7v3sIDavgK3Elr+bmSFsQYkfk++xQMxUl5g0bxEzhC0vsXnNWyCbA+hSdYlH
	f3VBTBEBI4nrb50hKkQk9r14xziBUWgWkkGzkAyahWTQLCQtCxhZVjGKphYkFxQnpeca6hUn
	5haX5qXrJefnbmIER/AzqR2MKxssDjEKcDAq8fB+FDoVIMSaWFZcmXuIUYKDWUmEt9cPKMSb
	klhZlVqUH19UmpNafIjRB+jPicxSosn5wOSSVxJvaGxiZmRpZGZhZGJujkNYSZy32SMlQEgg
	PbEkNTs1tSC1CGYcEwenVANjWsi2/tvKYvLmKRa+01Qj2C1DxIpsPS/umbLgmfC7zEqeiW+u
	WTm9X/jtfJR03e0nwotKxM++nmliy/Hwior50wI+812z9A4xvTj5bRnnMintyql/2eacPX/S
	VNL70Lf5pcql9c3Ri718tT+YSepu7urv2LaE9YLsgYhXmw6cLXvxcd7r31lPlFiKMxINtZiL
	ihMB9m9LpA0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Namjae Jeon [mailto:linkinjeon@gmail.com]
> Sent: Thursday, December 13, 2012 11:44 PM
> To: jaegeuk.kim@samsung.com
> Cc: Namjae Jeon; Amit Sahrawat; Namjae Jeon; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org
> Subject: [f2fs-dev] [PATCH v2] f2fs: fix up f2fs_get_parent issue to
> retrieve correct parent inode number
> 
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Test Case:
> [NFS Client]
> ls -lR .
> 
> [NFS Server]
> while [ 1 ]
> do
> echo 3 > /proc/sys/vm/drop_caches
> done
> 
> Error on NFS Client: "No such file or directory"
> 
> When cache is dropped at the server, it results in lookup failure at the
> NFS client due to non-connection with the parent. The default path is it
> initiates a lookup by calculating the hash value for the name, even though
> the hash values stored on the disk for "." and ".." is maintained as zero,
> which results in failure from find_in_block due to not matching HASH values.
> Fix up, by using the correct hashing values for these entries.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/dir.c  |    4 ++--
>  fs/f2fs/hash.c |    4 ++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index b4e24f3..a158406 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -540,13 +540,13 @@ int f2fs_make_empty(struct inode *inode, struct inode
> *parent)
> 
>  	de = &dentry_blk->dentry[0];
>  	de->name_len = cpu_to_le16(1);
> -	de->hash_code = 0;
> +	de->hash_code = f2fs_dentry_hash(".", 1);
>  	de->ino = cpu_to_le32(inode->i_ino);
>  	memcpy(dentry_blk->filename[0], ".", 1);
>  	set_de_type(de, inode);
> 
>  	de = &dentry_blk->dentry[1];
> -	de->hash_code = 0;
> +	de->hash_code = f2fs_dentry_hash("..", 2);
>  	de->name_len = cpu_to_le16(2);
>  	de->ino = cpu_to_le32(parent->i_ino);
>  	memcpy(dentry_blk->filename[1], "..", 2);
> diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
> index a60f042..5e48bac 100644
> --- a/fs/f2fs/hash.c
> +++ b/fs/f2fs/hash.c
> @@ -76,6 +76,10 @@ f2fs_hash_t f2fs_dentry_hash(const char *name, int len)
>  	const char *p;
>  	__u32 in[8], buf[4];
> 
> +	if ((len <= 2) && (name[0] == '.') &&
> +		(name[1] == '.' || name[1] == '\0'))
> +		return 0;
> +

How about this?
if (!memcmp(name, ".", len) || !memcmp(name, "..", len))
	return 0;


>  	/* Initialize the default seed for the hash checksum functions */
>  	buf[0] = 0x67452301;
>  	buf[1] = 0xefcdab89;
> --
> 1.7.9.5
> 
> 
> ---------------------------------------------------------------------------
> ---
> LogMeIn Rescue: Anywhere, Anytime Remote support for IT. Free Trial
> Remotely access PCs and mobile devices and provide instant support
> Improve your efficiency, and focus on delivering more value-add services
> Discover what IT Professionals Know. Rescue delivers
> http://p.sf.net/sfu/logmein_12329d2d
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

