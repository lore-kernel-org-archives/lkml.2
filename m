Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1GAJsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:48:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab1GAJr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:47:57 -0400
Message-ID: <4E0D97C5.5040005@redhat.com>
Date: Fri, 01 Jul 2011 11:47:49 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3/4] Staging: zram: allow partial page operations
References: <1307712529-9757-1-git-send-email-jmarchan@redhat.com> <1307712529-9757-2-git-send-email-jmarchan@redhat.com> <1307712529-9757-3-git-send-email-jmarchan@redhat.com> <4DF2493F.8040507@vflare.org>
In-Reply-To: <4DF2493F.8040507@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 06:41 PM, Nitin Gupta wrote:
> On 06/10/2011 06:28 AM, Jerome Marchand wrote:
>> Commit 7b19b8d45b216ff3186f066b31937bdbde066f08 (zram: Prevent overflow
>> in logical block size) introduced ZRAM_LOGICAL_BLOCK_SIZE constant to
>> prevent overflow of logical block size on 64k page kernel.
>> However, the current implementation of zram only allow operation on block
>> of the same size as a page. That makes theorically legit 4k requests fail
>> on 64k page kernel.
>>
>> This patch makes zram allow operation on partial pages. Basically, it
>> means we still do operations on full pages internally, but only copy the
>> relevent segments from/to the user memory.
>>
> 
> Couldn't we just change struct queue_limits.logical_block_size type to 
> unsigned int or something so it could hold value of 64K? Then we could
> avoid making all these changes to handle partial page requests.

I've finally done some tests. At least FAT filesystems are unable to cope
with 64k logical blocks. Probably some other fs are affected too. I we want
to support them, zram need to handle operation on partial pages.

Jérôme

> 
> Thanks,
> Nitin
