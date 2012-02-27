Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2B0XOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:14:39 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:45362 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab2B0XOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:14:37 -0500
Message-ID: <4F4C0E46.9090000@oracle.com>
Date: Mon, 27 Feb 2012 17:14:14 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Thunderbird/10.0.2
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: [RFC PATCH 18/22] ext3: add support for .read_iter and .write_iter
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com> <1330377576-3659-19-git-send-email-dave.kleikamp@oracle.com> <4F4C04EE.7080306@zabbo.net>
In-Reply-To: <4F4C04EE.7080306@zabbo.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090202.4F4C0E4D.00AF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 04:34 PM, Zach Brown wrote:
> 
>>   drivers/block/loop.c |   55 ++++++++++++++++++-
>>   fs/ext3/file.c       |    2 +
>>   fs/ext3/inode.c      |  149
>> ++++++++++++++++++++++++++++++++++----------------
>>   include/linux/loop.h |    1 +
>>   4 files changed, 160 insertions(+), 47 deletions(-)
> 
> It looks like the patch that teaches loop to use the kernel aio
> interface got combined with the patch that adds the _bvec entry points
> to ext3.

Okay, looking back, your patchset had them separate. This was my error.
I'll separate them again.

>> +    if (file->f_op->write_iter&&  file->f_op->read_iter) {
>> +        file->f_flags |= O_DIRECT;
>> +        lo_flags |= LO_FLAGS_USE_AIO;
>> +    }
> 
> This manual setting of f_flags still looks very fishy to me.  I remember
> finding that pattern somewhere else but that's not very comforting :).
> 
> - z
