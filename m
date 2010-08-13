Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561Ab0HMMZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 08:25:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab0HMMZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 08:25:44 -0400
Message-ID: <4C6539C4.6070907@redhat.com>
Date: Fri, 13 Aug 2010 14:25:40 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100802 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: "J. R. Okajima" <hooanon05@yahoo.co.jp>, linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Q. NFS, return value of close(2)
References: <4387.1281540989@jrobl>	 <1281544299.3262.2.camel@heimdal.trondhjem.org>  <7396.1281546264@jrobl> <1281546396.3262.7.camel@heimdal.trondhjem.org>
In-Reply-To: <1281546396.3262.7.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 07:06 PM, Trond Myklebust wrote:
>> commit e56f956a08a6227004cd9b7747df6a089dbb3594
>> Author: J. R. Okajima <hooanon05@yahoo.co.jp>
>> Date:   Thu Aug 12 02:00:02 2010 +0900
>>
>>     NFS: fix the return value of nfs_file_fsync()
>>     
>>     By the commit
>>     	af7fa16 2010-08-03 NFS: Fix up the fsync code
>>     close(2) became returning the non-zero value even if it went well.
>>     nfs_file_fsync() should return 0 when "status" is positive.
>>     
>>     Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>

Hi,

please can you send this patch to Linus' tree?
NFS is currently broken, so it will save time for people trying
to bisect the problem.

It breaks even elementary operation on nfs mounts
# cat a > b
cat: write error

Patch above from nfs-git fixed the problem for me
http://git.linux-nfs.org/?p=trondmy/nfs-2.6.git;a=commitdiff;h=0702099bd86c33c2dcdbd3963433a61f3f503901

Thanks,
Milan
--
mbroz@redhat.com
