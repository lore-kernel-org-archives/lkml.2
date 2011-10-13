Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab1JMAFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:05:52 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:55722 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1JMAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:05:50 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=d+geQ/tqU9SqvX6TeKtcPB7snF2nudecYQ9K08j2zdA= c=1 sm=1
 a=hjn-XhmR8WgA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=xljPVTFQWZwO3GH7l7oA:9
 a=_FYTXFFIgqIbzbYVn_EA:7 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH 12/28] ext4: Use i_generation in inode-related metadata checksums
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20111012212838.GP12447@tux1.beaverton.ibm.com>
Date: Wed, 12 Oct 2011 18:06:43 -0600
Cc: Theodore Tso <tytso@mit.edu>, Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <E16A098F-00C8-4484-8AE2-7ED75FCFA676@dilger.ca>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075502.20506.15728.stgit@elm3c44.beaverton.ibm.com> <BFA9D351-575B-4B48-B5D8-D01DF5317A7C@dilger.ca> <20111012212838.GP12447@tux1.beaverton.ibm.com>
To: djwong@us.ibm.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-12, at 3:28 PM, Darrick J. Wong wrote:
> On Wed, Oct 12, 2011 at 12:52:30PM -0700, Andreas Dilger wrote:
>> On 2011-10-08, at 12:55 AM, Darrick J. Wong wrote:
>>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>>> index f18bfe3..fdf0b1e 100644
>>> --- a/fs/ext4/ioctl.c
>>> +++ b/fs/ext4/ioctl.c
>>> @@ -149,6 +149,10 @@ flags_out:
>>> 		if (!inode_owner_or_capable(inode))
>>> 			return -EPERM;
>>> 
>>> +		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>>> +				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>>> +			return -ENOTTY;
>> 
>> This should get an ext4_warning() in the non-checksum case to warn
>> users that this ioctl is deprecated and will be removed in the
>> future unless there is a good reason to keep it.
> 
> Ok.  Maybe put it in feature_removal_schedule.txt too?  Maybe not; the
> ioctl is not being totally removed, it's merely unsupported for the
> metadata_csum case.

I understand it is not being removed entirely, but since it doesn't
work at all with the checksum-enabled case, we may as well mark it
deprecated for the non-checksum case to allow us to catch any users
(however unlikely I think it is) earlier rather than later.

Cheers, Andreas





