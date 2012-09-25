Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab2IYPHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:07:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31269 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab2IYPHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:07:46 -0400
Message-ID: <5061C8A2.1020605@oracle.com>
Date: Tue, 25 Sep 2012 10:07:14 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: Re: Out of memory on 3.5 kernels
References: <505B1FA0.6030100@broadcom.com> <20120921194931.GA732@schottelius.org> <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 05:43 PM, David Rientjes wrote:
> On Fri, 21 Sep 2012, Nico Schottelius wrote:
> 
>>  Active / Total Objects (% used)    : 1165130 / 1198087 (97.2%)
>>  Active / Total Slabs (% used)      : 81027 / 81027 (100.0%)
>>  Active / Total Caches (% used)     : 69 / 101 (68.3%)
>>  Active / Total Size (% used)       : 1237249.81K / 1246521.94K (99.3%)
>>  Minimum / Average / Maximum Object : 0.01K / 1.04K / 15.23K
>>
>>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
>> 993607 993607 100%    1.21K  75358       26   2411456K jfs_ip
> 
> Well that doesn't look good.  100% of the inode cache for jfs are being 
> used which either means
> 
>  - there's a memory leak, or

maybe a missing iput() somewhere?

Nico, does unmounting the usb drive after killing the backup clean up
the jfs inode cache?

>  - there's some sort of throttling issue in jfs.
> 
> And those objects are consuming ~2.3GB of slab on your 4GB machine and 
> seems to only have occurred between v3.4.2 to v3.5.3.

Almost nothing in jfs has changed between these releases. Only this:

vfs: Rename end_writeback() to clear_inode()

> It would be interesting to see what kmemleak would tell us.
> 
> Adding Dave Kleikamp to the cc.
> 
