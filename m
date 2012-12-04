Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2LDJ2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:28:49 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:40254 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab2LDJ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:28:45 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5 5/8] fat: restructure export_operations
References: <1353504277-5947-1-git-send-email-linkinjeon@gmail.com>
	<87hao35uqz.fsf@devron.myhome.or.jp>
	<CAKYAXd_X8Jkq=PdV+dVPTO_EAPHoZ37MynpjvkrPTDahWyUOTA@mail.gmail.com>
Date: Tue, 04 Dec 2012 18:28:40 +0900
In-Reply-To: <CAKYAXd_X8Jkq=PdV+dVPTO_EAPHoZ37MynpjvkrPTDahWyUOTA@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 4 Dec 2012 15:23:27 +0900")
Message-ID: <87obia17zr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> +static struct dentry *fat_fh_to_dentry_nostale(struct super_block *sb,
>>> +					       struct fid *fh, int fh_len,
>>> +					       int fh_type)
>>> +{
>>> +	struct inode *inode = NULL;
>>> +	struct fat_fid *fid = (struct fat_fid *)fh;
>>> +	loff_t i_pos;
>>> +
>>> +	switch (fh_type) {
>>> +	case FILEID_FAT_WITHOUT_PARENT:
>>> +		if (fh_len < FAT_FID_SIZE_WITHOUT_PARENT)
>>> +			return NULL;
>>> +	case FILEID_FAT_WITH_PARENT:
>>> +		if ((fh_len < FAT_FID_SIZE_WITH_PARENT) &&
>>> +			(fh_type == FILEID_FAT_WITH_PARENT))
>>> +			return NULL;
>>
>> Do we have to care (FILEID_FAT_WITH_PARENT and fh_len < 5) here?
>>
>> 	if (fh_len < 2)
>> 		return NULL;
>>
>> 	switch (fh_type) {
>> 	case FILEID_INO32_GEN:
>> 	case FILEID_INO32_GEN_PARENT:
>> 		inode = get_inode(sb, fid->i32.ino, fid->i32.gen);
>> 		break;
>> 	}
>>
>> 	return d_obtain_alias(inode);
>>
>> generic_fh_to_dentry() is above. I wonder why we have to care
>> fat_fid->parent* here.
> Let me think, if ‘subtree’ checking is enabled then we should check
> the length condition over here also? Please share if there are any
> other comments also.

I'm not sure what did you mean. Where is "subtree" check you are
talking? This is fh_to_dentry(), so we don't use parent at all, so
length == 3 is enough?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
