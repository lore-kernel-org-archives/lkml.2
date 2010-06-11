Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab0FKQ40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:56:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508Ab0FKQ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:56:25 -0400
Message-ID: <4C126AAB.4040802@redhat.com>
Date: Fri, 11 Jun 2010 11:56:11 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: Tao Ma <tao.ma@oracle.com>, linux-ext4@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: fiemap is broken for sparse file in ext4?
References: <4C119C2E.2090801@oracle.com>	<4C11B6D8.8070909@redhat.com>	<4C11C41C.9070000@oracle.com>	<4C125A6C.2090805@redhat.com> <AANLkTim9xIyL842wapccPIwEPVgd3BY8_r0tBGfGgvOt@mail.gmail.com>
In-Reply-To: <AANLkTim9xIyL842wapccPIwEPVgd3BY8_r0tBGfGgvOt@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Freemyer wrote:
> On Fri, Jun 11, 2010 at 11:46 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> Tao Ma wrote:
>>
>>>> What are you using to call fiemap?  Here it seems to be working:
>>> I just wrote a simple test program by calling ioctl. It is attached.
>>> btw, you need to call it immediately after dd so that we have a chance
>>> that ext4 don't have time to allocate extents. ;)
>> OK I take it back, I do see it.  *cough* too many different filesystems
>> on this box ... ;)
>>
>> Yes, it does look like a bug.
>>
>> -Eric
> 
> I'm not clear how this is supposed to work.
> 
> Is this just a userspace bug in that FIEMAP_FLAG_SYNC is needed in the
> fiemap call, or is there a kernel bug as well?

The flag is optional, though maybe filefrag should use it.

Without it, we should get the proper logical offset and a delalloc-flagged
extent returned

> If fiemap is called with the FIEMAP_FLAG_SYNC flag is there currently a problem?

yep, we should get one delalloc extent in the results and we don't.

-Eric

> Thanks
> Greg

