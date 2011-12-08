Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1LHPZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:25:32 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:8907 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1LHPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:25:29 -0500
X-Greylist: delayed 3795 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Dec 2011 10:25:29 EST
X-Authority-Analysis: v=2.0 cv=ZPFVaAHb c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=zQGhUK9Iw4MA:10 a=LNmbJxpDd3oA:10 a=8nJEP1OIZ-IA:10 a=WnuCyevxgrplMXuIXp0A:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4EE0D6E6.9000807@cfl.rr.com>
Date: Thu, 08 Dec 2011 10:25:26 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <cover.1322709471.git.psusi@cfl.rr.com> <4ED6F320.5060709@cfl.rr.com> <20111208123038.GA16493@nb.redhat.com> <4EE0C814.2000807@cfl.rr.com> <20111208151650.GB16934@nb.redhat.com>
In-Reply-To: <20111208151650.GB16934@nb.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/8/2011 10:16 AM, Karel Zak wrote:
>   Is it safe to alter the partition size in arbitrary way if the
>   partition is used by any process?
>
>   Vivek's BLKPG_EXTEND_PARTITIONV seems more safety, because it extends
>   a partition size only, so all offsets in all running stuff are still
>   valid.
>
>   Maybe you need to check bdevp->bd_openers and returns -EBUSY if you
>   want to alter the begin of the partition.

I disallowed altering the start of the partition ( that would just be 
crazy ), but altering the end has been supported on lvm for years now. 
Ext4 can not perform an online shrink, but btrfs can, and I was able to 
successfully have btrfs shrink the fs and then use BLKPG_RES_PARTITION 
to shrink the partition.

