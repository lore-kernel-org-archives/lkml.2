Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2LMXSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:18:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50168 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab2LMXSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:18:03 -0500
X-AuditID: cbfee61b-b7f616d00000319b-00-50ca62176b0b
From: =?UTF-8?B?7J207LC966eM?= <cm224.lee@samsung.com>
To: =?UTF-8?B?J+ydtOywveunjCc=?= <cm224.lee@samsung.com>,
        "'Namjae Jeon'" <linkinjeon@gmail.com>, jaegeuk.kim@samsung.com
Cc: "'Namjae Jeon'" <namjae.jeon@samsung.com>, linux-fsdevel@vger.kernel.org,
        "'Amit Sahrawat'" <a.sahrawat@samsung.com>,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1355409851-6389-1-git-send-email-linkinjeon@gmail.com>
 <060d01cdd986$e708a180$b519e480$%lee@samsung.com>
In-reply-to: <060d01cdd986$e708a180$b519e480$%lee@samsung.com>
Subject: RE: [f2fs-dev] [PATCH v2] f2fs: fix up f2fs_get_parent issue	to
	retrieve correct parent inode number
Date: Fri, 14 Dec 2012 08:17:42 +0900
Message-id: <060e01cdd988$0d4d45c0$27e7d140$%lee@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3ZQF1LYmlTU4nES2S2vrhAJR8PzQARjg3gAABWgcA=
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zfV3xpFMBBpemMlvs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWsWL6aqeCTSsWGSStZGxhb5boYOTkkBEwkXv86xAxh
	i0lcuLeerYuRi0NIYBmjxP4FU9hgii69XcUIkZjOKLGyewErhPOHUWL91D52kCo2ATOJjfeu
	sIDYIgKVErtfz2MBKWIW2McoserYerBRQgLlEu03NjOB2JwCdhKNV1eB2cIC+RKnXz1gBLFZ
	BFQlVh5uBxvKK2ArsbVvKZQtKPFj8j2wBcwC6hKT5i1ihrC1JZ68uwB0EQfQqeoSj/7qgpgi
	AlYS+7pUICpEJPa9eAc1XUDi2+RDLBDVshKbDjCDXCkhsIpd4vWqrSwQD0tKHFxxg2UCo8Qs
	JItnIVk8C8niWUhWLGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kREmXSOxhXNVgcYhTg
	YFTi4f0gdCpAiDWxrLgy9xCjBAezkghvrx9QiDclsbIqtSg/vqg0J7X4EKMP0OUTmaVEk/OB
	CSCvJN7Q2NjEzMTUxNzS1NwUh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsYQ5cYNMif7
	ffrPHv90aWJAVFAw1y+3m5u2bEzcpSQ+vdd6DUu8rfm/e1e29jMvvNR2wM8mIDPstFWv/oc5
	fz7tdmjgvbqz3VUzv4Pl0HL247Y8W3tERA4Ze2VP4X4UacAVcnBf5sGw1EZ5O8HPq+Vcr7K7
	TG1Y22DddOJb9OytstxT5/XU8yixFGckGmoxFxUnAgDYsr3J3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQV2xpFMBBl9vWlns2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmrFi+mqngk0rF
	hkkrWRsYW+W6GDk5JARMJC69XcUIYYtJXLi3nq2LkYtDSGA6o8TK7gWsEM4fRon1U/vYQarY
	BMwkNt67wgJiiwhUSux+PY8FpIhZYB+jxKpjIO2cQB3lEu03NjOB2JwCdhKNV1eB2cIC+RKn
	Xz0AW8cioCqx8nA72FBeAVuJrX1LoWxBiR+T74EtYBZQl5g0bxEzhK0t8eTdBaCLOIBOVZd4
	9FcXxBQRsJLY16UCUSEise/FO8YJjEKzkAyahWTQLCSDZiFpWcDIsopRNLUguaA4KT3XSK84
	Mbe4NC9dLzk/dxMjOIafSe9gXNVgcYhRgINRiYf3g9CpACHWxLLiytxDjBIczEoivL1+QCHe
	lMTKqtSi/Pii0pzU4kOMPkB/TmSWEk3OB6aXvJJ4Q2MTMyNLIzMLIxNzcxzCSuK8zR4pAUIC
	6YklqdmpqQWpRTDjmDg4pRoY1/9Qrvr/5Ki5fODnvbPuBKQJhotydRxxYf8dEn86Q1RuXuTH
	O7UvnpY6TQxe1fjkw+U56wPuTCqyPevxqD9v+fQ37zeXHDPo/FzxRZvrgR33uwO9Eer8T68c
	O7ZWNkqRr/SIlNDjtIuCCTefMHZW5L8POjqrMSLUqm3HxvV2oZv87TZ/SvKsUWIpzkg01GIu
	Kk4EABxWRzIOAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I've missed too. Forget this, please.

> -----Original Message-----
> From: 이창만 [mailto:cm224.lee@samsung.com]
> Sent: Friday, December 14, 2012 8:09 AM
> To: 'Namjae Jeon'; jaegeuk.kim@samsung.com
> Cc: 'Namjae Jeon'; linux-fsdevel@vger.kernel.org; 'Amit Sahrawat'; linux-
> kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH v2] f2fs: fix up f2fs_get_parent issue to
> retrieve correct parent inode number
> 
> 
> 
> > -----Original Message-----
> > From: Namjae Jeon [mailto:linkinjeon@gmail.com]
> > Sent: Thursday, December 13, 2012 11:44 PM
> > To: jaegeuk.kim@samsung.com
> > Cc: Namjae Jeon; Amit Sahrawat; Namjae Jeon; linux-kernel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org
> > Subject: [f2fs-dev] [PATCH v2] f2fs: fix up f2fs_get_parent issue to
> > retrieve correct parent inode number
> >
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > Test Case:
> > [NFS Client]
> > ls -lR .
> >
> > [NFS Server]
> > while [ 1 ]
> > do
> > echo 3 > /proc/sys/vm/drop_caches
> > done
> >
> > Error on NFS Client: "No such file or directory"
> >
> > When cache is dropped at the server, it results in lookup failure at the
> > NFS client due to non-connection with the parent. The default path is it
> > initiates a lookup by calculating the hash value for the name, even
> though
> > the hash values stored on the disk for "." and ".." is maintained as zero,
> > which results in failure from find_in_block due to not matching HASH
> values.
> > Fix up, by using the correct hashing values for these entries.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  fs/f2fs/dir.c  |    4 ++--
> >  fs/f2fs/hash.c |    4 ++++
> >  2 files changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> > index b4e24f3..a158406 100644
> > --- a/fs/f2fs/dir.c
> > +++ b/fs/f2fs/dir.c
> > @@ -540,13 +540,13 @@ int f2fs_make_empty(struct inode *inode, struct
> inode
> > *parent)
> >
> >  	de = &dentry_blk->dentry[0];
> >  	de->name_len = cpu_to_le16(1);
> > -	de->hash_code = 0;
> > +	de->hash_code = f2fs_dentry_hash(".", 1);
> >  	de->ino = cpu_to_le32(inode->i_ino);
> >  	memcpy(dentry_blk->filename[0], ".", 1);
> >  	set_de_type(de, inode);
> >
> >  	de = &dentry_blk->dentry[1];
> > -	de->hash_code = 0;
> > +	de->hash_code = f2fs_dentry_hash("..", 2);
> >  	de->name_len = cpu_to_le16(2);
> >  	de->ino = cpu_to_le32(parent->i_ino);
> >  	memcpy(dentry_blk->filename[1], "..", 2);
> > diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
> > index a60f042..5e48bac 100644
> > --- a/fs/f2fs/hash.c
> > +++ b/fs/f2fs/hash.c
> > @@ -76,6 +76,10 @@ f2fs_hash_t f2fs_dentry_hash(const char *name, int len)
> >  	const char *p;
> >  	__u32 in[8], buf[4];
> >
> > +	if ((len <= 2) && (name[0] == '.') &&
> > +		(name[1] == '.' || name[1] == '\0'))
> > +		return 0;
> > +
> 
> How about this?
> if (!memcmp(name, ".", len) || !memcmp(name, "..", len))
> 	return 0;
> 
> 
> >  	/* Initialize the default seed for the hash checksum functions */
> >  	buf[0] = 0x67452301;
> >  	buf[1] = 0xefcdab89;
> > --
> > 1.7.9.5
> >
> >
> > -------------------------------------------------------------------------
> --
> > ---
> > LogMeIn Rescue: Anywhere, Anytime Remote support for IT. Free Trial
> > Remotely access PCs and mobile devices and provide instant support
> > Improve your efficiency, and focus on delivering more value-add services
> > Discover what IT Professionals Know. Rescue delivers
> > http://p.sf.net/sfu/logmein_12329d2d
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
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

