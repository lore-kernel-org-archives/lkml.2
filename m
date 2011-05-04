Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1EDVy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:54:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38800 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1EDVyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:54:25 -0400
Message-ID: <4DC1CB06.9060101@oracle.com>
Date: Wed, 04 May 2011 16:54:14 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110429 Lightning/1.0b2 OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/UAFCAFCATUAFLAF_1301673577011-962016341 Thunderbird/3.1.10
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <15392.1304535887@localhost> <4DC1A49C.4010101@redhat.com>
In-Reply-To: <4DC1A49C.4010101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DC1CB0F.00C2:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 02:10 PM, Josef Bacik wrote:
> On 05/04/2011 03:04 PM, Valdis.Kletnieks@vt.edu wrote:
>> On Wed, 04 May 2011 13:58:39 EDT, Josef Bacik said:
>>
>>> -SEEK_HOLE: this moves the file pos to the nearest hole in the file
>>> from the
>>> given position.
>>
>> Nearest, or next? Solaris defines it as "next", for a good reason -
>> otherwise
>> you can get stuck in a case where the "nearest" hole is back towards the
>> start of the file - and "seek data" will bounce back to the next byte at
>> the other end of the hole.
>>
>
> Yeah sorry the log says "nearest" but the code says "next", if you look
> at it thats how it works. Thanks,

The comments in fs.h say "closest".  You may want to change them to 
"next" as well.

Thanks,
Shaggy
