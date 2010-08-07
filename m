Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab0HGHbU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 03:31:20 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:36082 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab0HGHbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 03:31:17 -0400
Message-ID: <4C5D0BC2.1040706@linux.vnet.ibm.com>
Date: Sat, 07 Aug 2010 09:31:14 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Josef Bacik <josef@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: PATCH 3/6 - direct-io: do not merge logically non-contiguous
 requests
References: <4C5BE8DB.5030503@linux.vnet.ibm.com> <20100806120358.GA31601@infradead.org>
In-Reply-To: <20100806120358.GA31601@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/06/2010 02:03 PM, Christoph Hellwig wrote:
> Something is deeply wrong here.  Raw block device access has a 1:1
> mapping between logical and physical block numbers.  They really should
> never be non-contiguous.

At least I did nothing I know about to break it :-)

As I mentioned just iozone using direct I/O (-I flag of iozone then 
using O_DIRECT for the file) on a ext2 file-system.
The file system was coming clean out of mkfs the file was written with 
iozone one step before the traced read run.

The only uncommon thing here might be the block device, which is a scsi 
disk on our SAN servers (I'm running on s390) - so the driver in charge 
is zfcp (drivers/s390/scsi/).
I could use dasd (drivers/s390/block) disks as well, but I have no 
blktrace of them yet - what I already know is that they show a similar 
cost increase. On monday I should be able to get machine resources to 
verify that both disk types are affected.

Let me know if I can do anything else on my system to shed some light on 
the matter.



-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
