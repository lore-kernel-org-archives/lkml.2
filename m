Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0LPNq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 08:46:29 -0500
Received: from mx04.teleca.com ([212.92.145.6]:37844 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab0LPNq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 08:46:26 -0500
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Dec 2010 08:46:26 EST
Message-ID: <4D0A16F9.9000503@nokia.com>
Date: Thu, 16 Dec 2010 16:41:13 +0300
From: Roman Borisov <ext-roman.borisov@nokia.com>
MIME-Version: 1.0
To: ext Eric Sandeen <sandeen@redhat.com>, jack@suse.cz
CC: Aaro Koskinen <aaro.koskinen@nokia.com>, tytso@mit.edu,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        ext-phil.2.carmody@nokia.com
Subject: Re: [PATCH] ext4: fix typo in ext4_find_entry()
References: <1291826002-24989-1-git-send-email-aaro.koskinen@nokia.com> <4CFFC609.1090506@redhat.com>
In-Reply-To: <4CFFC609.1090506@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2010 13:38:03.0063 (UTC) FILETIME=[7661CC70:01CB9D26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 08:53 PM, ext Eric Sandeen wrote:
> On 12/08/2010 10:33 AM, Aaro Koskinen wrote:
>> There should be a check for NUL character instead of '0'.
>>
>> Reported-by: Phil Carmody<ext-phil.2.carmody@nokia.com>
>> Signed-off-by: Aaro Koskinen<aaro.koskinen@nokia.com>
>> ---
>>   fs/ext4/namei.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index 92203b8..dc40e75 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -872,7 +872,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
>>   	if (namelen>  EXT4_NAME_LEN)
>>   		return NULL;
>>   	if ((namelen<= 2)&&  (name[0] == '.')&&
>> -	    (name[1] == '.' || name[1] == '0')) {
>> +	    (name[1] == '.' || name[1] == '\0')) {
>>   		/*
>>   		 * "." or ".." will only be in the first block
>>   		 * NFS may look up ".."; "." should be handled by the VFS
>
> Yep, as it was reviewed on the list when originally sent, oops! ;)
>
> -Eric

Hi,

the same fix should be done for ext3 patch which is planned to be in 
mainline: http://www.spinics.net/lists/linux-ext4/msg21215.html

Roman
