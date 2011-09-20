Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1ITCNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 22:13:33 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:41441 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752898Ab1ITCNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 22:13:32 -0400
Message-ID: <4E77F6C7.4090509@tao.ma>
Date: Tue, 20 Sep 2011 10:13:27 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@google.com>
CC: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/direct-io.c: Calcuate fs_count correctly in get_more_blocks.
References: <1316420739-4734-1-git-send-email-tm@tao.ma> <20110919153149.be4ab3ca.akpm@google.com>
In-Reply-To: <20110919153149.be4ab3ca.akpm@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 06:31 AM, Andrew Morton wrote:
> On Mon, 19 Sep 2011 16:25:39 +0800
> Tao Ma <tm@tao.ma> wrote:
> 
>> In get_more_blocks, we use dio_count to calcuate fs_count and do some
>> tricky things to increase fs_count if dio_count isn't aligned. But
>> actually it still has some cornor case that can't be coverd. See the
>> following example:
>> ./dio_write foo -s 1024 -w 4096(direct write 4096 bytes at offset 1024).
>> The same goes if the offset isn't aligned to fs_blocksize.
>>
>> In this case, the old calculation counts fs_count to be 1, but actually
>> we will write into 2 different blocks(if fs_blocksize=4096). The old code
>> just works, since it will call get_block twice(and may have to allocate
>> and create extent twice for file systems like ext4). So we'd better call
>> get_block just once with the proper fs_count.
> 
> Has this been carefully tested with more than just ext4?  If so, which?
ext4 only by xfstests, fs_mark, postmark, ffsb, dbench and sysbench. But
I can try xfs later. I will update you with the test result.

Thanks
Tao
