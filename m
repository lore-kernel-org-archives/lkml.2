Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab0FYS76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 14:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208Ab0FYS74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 14:59:56 -0400
Message-ID: <4C24FC71.6020001@redhat.com>
Date: Fri, 25 Jun 2010 14:58:57 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Daniel Taylor <Daniel.Taylor@wdc.com>
CC: Mike Fedyk <mfedyk@mikefedyk.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>, Mat <jackdachef@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       The development of BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal fragmentation
 in Btrfs)
References: <4C07C321.8010000@redhat.com><AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com><4C1B7560.1000806@gmail.com><AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com><4C1BA3E5.7020400@gmail.com><20100623234031.GF7058@shareable.org><469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com> <AANLkTil5Gl0-rWClRsLZby_c37bQu5RB_tCgHsxTFshO@mail.gmail.com> <469D2D911E4BF043BFC8AD32E8E30F5B24AEBB@wdscexbe07.sc.wdc.com>
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEBB@wdscexbe07.sc.wdc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 06:06 PM, Daniel Taylor wrote:
>
>
>    
>> -----Original Message-----
>> From: mikefedyk@gmail.com [mailto:mikefedyk@gmail.com] On
>> Behalf Of Mike Fedyk
>> Sent: Wednesday, June 23, 2010 9:51 PM
>> To: Daniel Taylor
>> Cc: Daniel J Blueman; Mat; LKML;
>> linux-fsdevel@vger.kernel.org; Chris Mason; Ric Wheeler;
>> Andrew Morton; Linus Torvalds; The development of BTRFS
>> Subject: Re: Btrfs: broken file system design (was Unbound(?)
>> internal fragmentation in Btrfs)
>>
>> On Wed, Jun 23, 2010 at 8:43 PM, Daniel Taylor
>> <Daniel.Taylor@wdc.com>  wrote:
>>      
>>> Just an FYI reminder.  The original test (2K files) is utterly
>>> pathological for disk drives with 4K physical sectors, such as
>>> those now shipping from WD, Seagate, and others.  Some of the
>>> SSDs have larger (16K0 or smaller blocks (2K).  There is also
>>> the issue of btrfs over RAID (which I know is not entirely
>>> sensible, but which will happen).
>>>
>>> The absolute minimum allocation size for data should be the same
>>> as, and aligned with, the underlying disk block size.  If that
>>> results in underutilization, I think that's a good thing for
>>> performance, compared to read-modify-write cycles to update
>>> partial disk blocks.
>>>        
>> Block size = 4k
>>
>> Btrfs packs smaller objects into the blocks in certain cases.
>>
>>      
> As long as no object smaller than the disk block size is ever
> flushed to media, and all flushed objects are aligned to the disk
> blocks, there should be no real performance hit from that.
>
> Otherwise we end up with the damage for the ext[234] family, where
> the file blocks can be aligned, but the 1K inode updates cause
> the read-modify-write (RMW) cycles and and cost>10% performance
> hit for creation/update of large numbers of files.
>
> An RMW cycle costs at least a full rotation (11 msec on a 5400 RPM
> drive), which is painful.
>    

Also interesting is to note that you can get a significant overheard 
even with 0 byte length files. Path names, metadata overhead, etc can 
consume (depending on the pathname length) quite a bit of space per file.

Ric

