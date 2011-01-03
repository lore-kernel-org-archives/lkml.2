Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1ACQol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:44:41 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50134 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1ACQoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:44:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h+zNNHLfAxgpxY2wiyNoFqHAVU7QOOVGzQKp2CPHesOJipYcIvbPncfJUi619lMUFA
         pfPqcFjaeyIvvBXlZcPaeItBXLFdsgAHbocCeOSjzGjTZdxTJLZAE/Wz7ux7bMJOFITL
         RPvmEcx+x5A5uDl0x7rOonTFJJlRW0Xwnvodc=
Message-ID: <4D21FCEB.80502@gmail.com>
Date: Tue, 04 Jan 2011 00:44:27 +0800
From: YangSheng <sickamd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Update atime from future.
References: <1293631121-12667-1-git-send-email-sickamd@gmail.com> <1294050468.2429.2.camel@dolmen>
In-Reply-To: <1294050468.2429.2.camel@dolmen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 06:27 PM, Steven Whitehouse wrote:
> Hi,
>
> On Wed, 2010-12-29 at 21:58 +0800, yangsheng wrote:
>    
>> Signed-off-by: sickamd@gmail.com
>> ---
>>   fs/inode.c |    8 +++++++-
>>   1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index da85e56..6c8effd 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -1469,7 +1469,13 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
>>   		return 1;
>>
>>   	/*
>> -	 * Is the previous atime value older than a day? If yes,
>> +	 * Is the previous atime value in future? If yes,
>> +	 * update atime:
>> +	 */
>> +	if ((long)(now.tv_sec - inode->i_atime.tv_sec)<  0)
>> +		return 1;
>> +	/*
>> +	 * Is the previous atime value old than a day? If yes,
>>   	 * update atime:
>>   	 */
>>   	if ((long)(now.tv_sec - inode->i_atime.tv_sec)>= 24*60*60)
>>      
> I don't think this is a good plan for cluster filesystems, since if the
> times on the nodes are not exactly synchronised (we do highly recommend
> people run ntp or similar) then this might lead to excessive atime
> updating. The current behaviour is to ignore atimes which are in the
> future for exactly this reason,
>    
I agreed in theory.  Anyway, a two-way update may cause shake in some 
case. Like a cluster environment with time gap between cluster members. 
But future atime also is a trouble things i think. Of course, I hope a 
clever patch to fix them all.

Thanks
yangsheng
