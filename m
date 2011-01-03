Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab1ACMyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 07:54:49 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:61140 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab1ACMyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 07:54:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tF/7YUFCVzUNLtQfaxqCDR1+3uEv5yKt2doeEaQOO87I2ilVUkXjwMwvzbGAphojKA
         A7Nmzn9vDcAXJSjPHSbiF/ptomnSwJ2ztxIek9rk2jg6KcqrMD4Rtc4N2urOinSZFoID
         bCZXv73EZxE93zRIv2GvB1irp/4RUSeDgLatk=
Message-ID: <4D21C707.3010505@gmail.com>
Date: Mon, 03 Jan 2011 20:54:31 +0800
From: YangSheng <sickamd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Update atime from future.
References: <1293631121-12667-1-git-send-email-sickamd@gmail.com> <20110103021708.d5abf7bd.akpm@linux-foundation.org>
In-Reply-To: <20110103021708.d5abf7bd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 06:17 PM, Andrew Morton wrote:
> On Wed, 29 Dec 2010 21:58:41 +0800 yangsheng<sickamd@gmail.com>  wrote:
>
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
> Why do you believe this change is needed?  Did you observe some problem
> which it fixes?  If so, please fully describe that problem.
>    
If atime has been set to future(maybe cause by some accident system time 
adjust or wrong set by touch). It cannot be update to reflect fact 
access time before system time running over one day.

Thanks



