Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1C1Utu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 16:49:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40069 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1C1Utt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 16:49:49 -0400
Message-ID: <4D90F468.7020309@linux.vnet.ibm.com>
Date: Mon, 28 Mar 2011 13:49:44 -0700
From: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 1/5] fs/9p: Fix revalidate to return
 correct value
References: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4D8D0009.8030806@linux.vnet.ibm.com>
In-Reply-To: <4D8D0009.8030806@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2011 01:50 PM, Venkateswararao Jujjuri wrote:
> On 03/25/2011 04:30 AM, Aneesh Kumar K.V wrote:
>> revalidate should return>  0 on success.
>>
>> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
>
> Reviewed-by: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
>
>> ---
>>   fs/9p/vfs_dentry.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
>> index b6a3b9f..59c5ddc 100644
>> --- a/fs/9p/vfs_dentry.c
>> +++ b/fs/9p/vfs_dentry.c
>> @@ -126,7 +126,7 @@ static int v9fs_lookup_revalidate(struct dentry 
>> *dentry, struct nameidata *nd)
>>               retval = v9fs_refresh_inode_dotl(fid, inode);
>>           else
>>               retval = v9fs_refresh_inode(fid, inode);
>> -        if (retval<= 0)
>> +        if (retval<  0)
This change is causing tuxera rename test failure with acls enabled.

/root/pjd-fstest-20080816/tests/rename/10.t  (Wstat: 0 Tests: 188 Failed: 6)
   Failed tests:  65, 71, 74, 77, 79-80
The comment in namei says:
"  If d_revalidate returned 0 attempt to invalidate  the dentry 
otherwise d_revalidate is asking us
  to return a fail status." I guess we need to return 0 in the case of 
rename.
Need more closer look at this patch.

- JV



>>               return retval;
>>       }
>>   out_valid:
>

