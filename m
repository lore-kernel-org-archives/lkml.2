Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab0EOCyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 22:54:08 -0400
Received: from crca.org.au ([74.207.252.120]:40553 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745Ab0EOCyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 22:54:06 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BEE0CC5.60804@crca.org.au>
Date: Sat, 15 May 2010 12:53:57 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Matt Reimer <mattjreimer@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
References: <Pine.LNX.4.44L0.1005142235580.11498-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005142235580.11498-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 15/05/10 12:37, Alan Stern wrote:
> On Fri, 14 May 2010, Nigel Cunningham wrote:
>
>> Hi.
>
>>> Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card present
>>>
>>> Devices can come and go bus during suspend or resume, when the
>>> writeback thread is frozen, resulting in a hang. Prevent the hang
>>> by thawing the writeback thread in del_gendisk().
>
>> Why not just make it unfreezeable to start with?
>
> If the writeback thread were unfreezable, it might wake up and try to
> write dirty pages back to disks after they were already suspended.
> That would not lead to good consequences...

If it syncs data as it should when we freeze processes, there won't be 
any problem. Perhaps this is just an argument against making syncing 
optional?

Regards,

Nigel
