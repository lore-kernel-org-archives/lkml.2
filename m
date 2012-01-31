Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2AaQCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:02:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab2AaQCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:02:34 -0500
Message-ID: <4F28102C.1070207@redhat.com>
Date: Tue, 31 Jan 2012 16:00:44 +0000
From: Niels de Vos <ndevos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mikulas Patocka <mpatocka@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH v3] fs: Invalidate the cache for a parent block-device
 if fsync() is called for a partition
References: <4F213E1A.4060808@redhat.com> <1327584802-14298-1-git-send-email-ndevos@redhat.com> <20120126134051.6add3cd2.akpm@linux-foundation.org> <20120126214534.GA9319@infradead.org>
In-Reply-To: <20120126214534.GA9319@infradead.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 09:45 PM, Christoph Hellwig wrote:
> On Thu, Jan 26, 2012 at 01:40:51PM -0800, Andrew Morton wrote:
>> The Right Thing To Do here is to make the kernel behave logically and
>> predictably, then modify the userspace tools.  But if we're modifying
>> the userspace tools then we would just change userspace to issue a
>> BLKFLSBUF to /dev/sda and leave the kernel alone.
> 
> The right fix is to make partition and whole disk access coherent,
> which is fairly simply:
> 
>  - create the block device inode/mapping per gendisk, and only reference
>    count it per block_device
>  - make sure blkdev_get_block(s) applies the correct offset if used on
>    partitions
> 

This surely looks like a better way to fix this issue. I am not sure yet
how much work that would involve and if I am the right person to fix
this. If nobody beats me to it, I might send a patch for review some
(undefined) time later.

Thanks for the suggestions,
Niels
