Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1GNDUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:20:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44278 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab1GNDUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:20:44 -0400
Message-ID: <4E1E6052.6030002@vflare.org>
Date: Wed, 13 Jul 2011 20:19:46 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3/4] Staging: zram: allow partial page operations
References: <1307712529-9757-1-git-send-email-jmarchan@redhat.com> <1307712529-9757-2-git-send-email-jmarchan@redhat.com> <1307712529-9757-3-git-send-email-jmarchan@redhat.com> <4DF2493F.8040507@vflare.org> <4E0D97C5.5040005@redhat.com>
In-Reply-To: <4E0D97C5.5040005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2011 02:47 AM, Jerome Marchand wrote:
> On 06/10/2011 06:41 PM, Nitin Gupta wrote:
>> On 06/10/2011 06:28 AM, Jerome Marchand wrote:
>>> Commit 7b19b8d45b216ff3186f066b31937bdbde066f08 (zram: Prevent overflow
>>> in logical block size) introduced ZRAM_LOGICAL_BLOCK_SIZE constant to
>>> prevent overflow of logical block size on 64k page kernel.
>>> However, the current implementation of zram only allow operation on block
>>> of the same size as a page. That makes theorically legit 4k requests fail
>>> on 64k page kernel.
>>>
>>> This patch makes zram allow operation on partial pages. Basically, it
>>> means we still do operations on full pages internally, but only copy the
>>> relevent segments from/to the user memory.
>>>
>>
>> Couldn't we just change struct queue_limits.logical_block_size type to
>> unsigned int or something so it could hold value of 64K? Then we could
>> avoid making all these changes to handle partial page requests.
>
> I've finally done some tests. At least FAT filesystems are unable to cope
> with 64k logical blocks. Probably some other fs are affected too. I we want
> to support them, zram need to handle operation on partial pages.
>

Sorry for late reply.

If this is the case, we surely need partial page operations. I also 
looked into these patches and they look good (though I've have not 
tested them).

Thanks,
Nitin


