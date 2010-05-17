Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0EQS5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:57:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52009 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab0EQS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:57:54 -0400
To: jiayingz@google.com (Jiaying Zhang)
Cc: hch@infradead.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       mrubin@google.com
Subject: Re: [PATCH, RFC] addjust discard request to be aligned with hwsect size to support SSDs with larger sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100513051953.532821BC316@ruihe.smo.corp.google.com>
Date: Mon, 17 May 2010 14:57:22 -0400
In-Reply-To: <20100513051953.532821BC316@ruihe.smo.corp.google.com> (Jiaying
	Zhang's message of "Wed, 12 May 2010 22:19:53 -0700 (PDT)")
Message-ID: <yq1pr0u8igd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090204.4BF191A8.00A4:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jiaying" == Jiaying Zhang <jiayingz@google.com> writes:

Jiaying,

Jiaying> The currect blkdev_issue_discard() function assumes 512 sector
Jiaying> size.

All of the block layer works on 512-byte sector units.  We don't
generally convert to logical blocks until we're in the disk driver.


Jiaying> We have seen some problem when using discard on a SSD that has
Jiaying> larger sector size. The following patch adjusts the starting
Jiaying> address and size of a discard request to be aligned with hwsect
Jiaying> size.

Jiaying> + int hwsect_shift =
Jiaying>  	blksize_bits(bdev_logical_block_size(bdev)) - 9;

Let's stop using the term hardware sector size.  It's an anachronism.

I guess I could understand if you aligned to the physical block size.
But the logical doesn't make much sense to me.

What is your logical block size?  Right now we only handle 512 bytes and
4KB in the discard path.

-- 
Martin K. Petersen	Oracle Linux Engineering
