Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab1HPG5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:57:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50295 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1HPG5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 02:57:08 -0400
Message-ID: <4E4A149E.5080608@oracle.com>
Date: Tue, 16 Aug 2011 14:56:30 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] xen-blkback: sync I/O after backend disconnected
References: <4E48A6A6.4040706@oracle.com> <20110815144610.GA3707@infradead.org>
In-Reply-To: <20110815144610.GA3707@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E4A14B8.0064:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/11 22:46, Christoph Hellwig wrote:
> On Mon, Aug 15, 2011 at 12:55:02PM +0800, Joe Jin wrote:
>> When backend disconnect, sync IO requests to the disk.
> 
> Care to explain why?

When backend disconnect, I think we'd better flush all dirty data 
to the disk ASAP.

> 
> Also you'll just need a sync_blockdev, fsync_bdev does far to many
> things that don't make any sense when you don't have a file system
> mounted on a device.
> 

xen-blkback support physical device and loopback file, so I think
here should be fsync_bdev()? 

Thanks,
Joe
