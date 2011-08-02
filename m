Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1HBNEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 09:04:53 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50930 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab1HBNEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 09:04:46 -0400
Message-ID: <4E37F5C6.8060908@parallels.com>
Date: Tue, 2 Aug 2011 10:04:06 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH 4/4] parse options in the vfs level
References: <1311947059-17209-1-git-send-email-glommer@parallels.com> <1311947059-17209-5-git-send-email-glommer@parallels.com> <20110731013456.GM5404@dastard>
In-Reply-To: <20110731013456.GM5404@dastard>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.54.7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2011 10:34 PM, Dave Chinner wrote:
> On Fri, Jul 29, 2011 at 05:44:19PM +0400, Glauber Costa wrote:
>> This patch introduces a simple generic vfs option parser.
>> Right now, the only option we have is to limit the size of the dcache.
>>
>> So any user that wants to have a dcache entries limit, can specify:
>>
>>    mount -o whatever_options,vfs_dcache_size=XXX<dev>  <mntpoint>
>>
>> It is supposed to work well with remounts, allowing it to change
>> multiple over the course of the filesystem's lifecycle.
>>
>> I find mount a natural interface for handling filesystem options,
>> so that's what I've choosen. Feel free to yell at it at will if
>> you disagree.
>
> IMO, the whole point of having a configurable cache size maximum is
> that is can be changed at runtime. Tying it to mount options is a
> painful way to acheive that because the only way to change it would
> be via a remount command.
And what's wrong with a remount command? It's a quite natural operation.
Furthermore, changing it at runtime is important - and as you noted, 
quite doable, but it is not "the whole point of it".
The whole point of it is to allow a piece of the fs hierarchy to have
a limit on the cache sizes. So I expect the most common usage to be
at mount itself. Specifically for the use case I have in mind, when
a new container is created.

> I'm not sure what the best API is, but I'd prefer something that is
> specific to a superblock, not a vfs mount. Perhaps something in
> /sys/fs?

I am not sure either, but I still believe my proposal is superior to 
write-to-a-file specifically. Writing to a file, be it in proc, sys, or 
wherever, leaves a window of opportunity open between mounting a 
filesystem and limiting its caches. Doing it on mount is atomic.

Effectively, I see this limit as a property of a particular instance of 
a mounted filesystem. Since all properties of a filesystem are specified 
during mount, this becomes a natural extension.

Let me know what you think


