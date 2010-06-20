Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0FTWd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:33:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40203 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab0FTWdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Qe6LveCNAu5MZHGs3lGepYT+666hiffDRCYXC0duF77Bk3CjpYHGL0qDMcOzt7smgl
         FjYcJWrGCWLUxeP71hw0SoGS3/agtJSvCvd8q0PTWgR92hbBbio0r8YYVV1p91DEfdVd
         CfjiazxyvAOcDfMi91Scmh4IZrg5kVqZlUf70=
Message-ID: <4C1E9752.8040508@gmail.com>
Date: Sun, 20 Jun 2010 15:33:54 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jeff Layton <jlayton@samba.org>
CC: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6 v2]cifs Fix warnings variables set but not used
References: <1276980427-24728-1-git-send-email-justinmattock@gmail.com> <20100620171713.782e9104@tlielax.poochiereds.net>
In-Reply-To: <20100620171713.782e9104@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>   		/* since paths are not looked up by component - the parent
>>   		   directories are presumed to be good here */
>>   		renew_parental_timestamps(direntry);
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 75541af..73e540b 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1312,7 +1312,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
>>   	int rc = -EFAULT;
>>   	int bytes_written = 0;
>>   	struct cifs_sb_info *cifs_sb;
>> -	struct cifsTconInfo *pTcon;
>> +	struct cifsTconInfo *pTcon __attribute__((unused));
>
> This variable can just be removed (along with the spot where it gets
> set later).
>
>>   	struct inode *inode;
>>   	struct cifsFileInfo *open_file;
>>
>
>

one thing I want to make sure of before sending this out, is with file.c
if I remove *pTcon another warning shows up:

   CC [M]  fs/cifs/file.o
fs/cifs/file.c: In function 'cifs_partialpagewrite':
fs/cifs/file.c:1314:23: warning: variable 'cifs_sb' set but not used

with the original patch I had removed this as well, should I do this or 
is this not a good idea?

Justin P. Mattock
