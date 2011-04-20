Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1DTJbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:31:23 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:48339 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab1DTJbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:31:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DAEA862.5040507@cam.ac.uk>
Date: Wed, 20 Apr 2011 10:33:22 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Ryan Mallon <ryan@bluewatersys.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, greg@kroah.com,
        adobriyan@gmail.com
Subject: Re: [PATCH 2/3] debugfs: move to new strtobool
References: <a> <1303213427-12798-3-git-send-email-jic23@cam.ac.uk> <4DADF0D3.3040006@bluewatersys.com>
In-Reply-To: <4DADF0D3.3040006@bluewatersys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/11 21:30, Ryan Mallon wrote:
> On 04/19/2011 11:43 PM, Jonathan Cameron wrote:
>> No functional changes requires that we eat errors from strtobool.
>> If people want to not do this, then it should be fixed at a later date.
> 
> May as well fix it now or it will get forgotten about. A second patch on
> top of this can fix the bug.
What worries me about this 'fix' is that it may well break some 'interesting'
bit of userspace code.  It would count as a userspace api change, be it
a fairly minor one.

Greg, do you thing it's worth returning an error on a non bool value?
> 
> ~Ryan
> 
>> V2: Simplification suggested by Rusty Russell removes the need for
>> additional variable ret.
>>
>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>> ---
>>  fs/debugfs/file.c |   17 ++++-------------
>>  1 files changed, 4 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
>> index 89d394d..568304d 100644
>> --- a/fs/debugfs/file.c
>> +++ b/fs/debugfs/file.c
>> @@ -429,25 +429,16 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
>>  {
>>  	char buf[32];
>>  	int buf_size;
>> +	bool bv;
>>  	u32 *val = file->private_data;
>>  
>>  	buf_size = min(count, (sizeof(buf)-1));
>>  	if (copy_from_user(buf, user_buf, buf_size))
>>  		return -EFAULT;
>>  
>> -	switch (buf[0]) {
>> -	case 'y':
>> -	case 'Y':
>> -	case '1':
>> -		*val = 1;
>> -		break;
>> -	case 'n':
>> -	case 'N':
>> -	case '0':
>> -		*val = 0;
>> -		break;
>> -	}
>> -	
>> +	if (strtobool(buf, &bv) == 0)
>> +		*val = bv;
>> +
>>  	return count;
>>  }
>>  
> 
> 

