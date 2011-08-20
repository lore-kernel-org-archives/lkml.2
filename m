Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1HTPff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 11:35:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29250 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab1HTPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 11:35:31 -0400
Message-ID: <4E4FD48B.8030101@oracle.com>
Date: Sat, 20 Aug 2011 08:36:43 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <4E4F814B.5070202@gmail.com> <4E4F865B.2010608@gmail.com>
In-Reply-To: <4E4F865B.2010608@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E4FD440.0063:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2011 03:03 AM, Marco Stornelli wrote:
> Il 20/08/2011 11:41, Marco Stornelli ha scritto:
>> Hi,
>>
>> Il 28/06/2011 17:33, Josef Bacik ha scritto:
>>> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.
>>> Turns out
>>> using fiemap in things like cp cause more problems than it solves, so
>>> lets try
>>> and give userspace an interface that doesn't suck. We need to match
>>> solaris
>>> here, and the definitions are
>>>
>>> *o* If /whence/ is SEEK_HOLE, the offset of the start of the
>>> next hole greater than or equal to the supplied offset
>>> is returned. The definition of a hole is provided near
>>> the end of the DESCRIPTION.
>>>
>>> *o* If /whence/ is SEEK_DATA, the file pointer is set to the
>>> start of the next non-hole file region greater than or
>>> equal to the supplied offset.
>>>
>>
>> I'm implementing the SEEK_DATA/SEEK_HOLE management for pramfs and I've
>> got some doubts about the right behavior:
>>
>> 1) when we use SEEK_DATA/SEEK_HOLE, the offset used in lseek means
>> always the offset from the start of the file, right?
>>
>> 2) in case of a file with hole at the beginning and data at the end, if
>> I do lseek(fd, 0, SEEK_HOLE) I should receive the end of the file
>> because the idea is to search the *next* hole and we have always a
>> virtual hole at the end of the file, right?
>
> Just to be precise about this question: the alternative here, it's to 
> return the same position because we are already in a hole.

Yes, the offset is from the start of the file.

And yes, same offset is ok. I think the word next should be
dropped from the definition. It is misleading.
