Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0HRTal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:30:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50841 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab0HRTaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:30:39 -0400
Message-ID: <4C6C34E0.3050601@vlnb.net>
Date: Wed, 18 Aug 2010 23:30:40 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <4C6540C5.8070108@vlnb.net> <4C6546E0.7070208@kernel.org>
In-Reply-To: <4C6546E0.7070208@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:BeYy8G0lgWcphvQygX0ygVqlPwuyqevMI55gt7nfIog
 YiCJUuXa/56vEwt6lX6phxaidAN+VDmQLRT8Fd6CKNX2LdtbT/
 DEdTlcGrWhReTe9QFXfqXafmcuGeY/nuKvMsnwKsx9fRQ6uGnO
 yCinUrXNoVgMcLOHedWJMQYrt7Aw2v2EJGtj5+v9SUuxMBQm5Q
 K34vRuwDN8IB8Hnbo8Gbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Tejun Heo, on 08/13/2010 05:21 PM wrote:
>> If requested, I can develop the interface further.
>
> I still think the benefit of ordering by tag would be marginal at
> best, and what have you guys measured there?  Under the current
> framework, there's no easy way to measure full ordered-by-tag
> implementation.  The mechanism for filesystems to communicate the
> ordering information (which would be a partially ordered graph) just
> isn't there and there is no way the current usage of ordering-by-tag
> only for barrier sequence can achieve anything close to that level of
> difference.

Basically, I measured how iSCSI link utilization depends from amount of 
queued commands and queued data size. This is why I made it as a table. 
 From it you can see which improvement you will have removing queue 
draining after 1, 2, 4, etc. commands depending of commands sizes.

For instance, on my previous XFS rm example, where rm of 4 files took 
3.5 minutes with nobarrier option, I could see that XFS was sending 1-3 
  32K commands in a row. From my table you can see that if it sent all 
them at once without draining, it would have about 150-200% speed increase.

Vlad
