Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2EBM1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:27:14 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:39456 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001Ab2EBM1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:27:13 -0400
X-IronPort-AV: E=Sophos;i="4.75,516,1330902000"; 
   d="scan'208";a="156390692"
Date: Wed, 2 May 2012 14:27:11 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: question about fs/jffs2/readinode.c
In-Reply-To: <1335960469.10293.49.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.02.1205021426530.1880@hadrien>
References: <alpine.DEB.2.02.1204280701210.1917@hadrien> <1335960469.10293.49.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2012, Artem Bityutskiy wrote:

> On Sat, 2012-04-28 at 07:06 +0200, Julia Lawall wrote:
>> The function read_direntry in fs/jffs2/readinode.c contains the following
>> code:
>>
>>          err = jffs2_flash_read(c, (ref_offset(ref)) + read,
>>                                 rd->nsize - already, &read, &fd->name[already]);
>>  	if (unlikely(read != rd->nsize - already) && likely(!err))
>>                        return -EIO;
>>
>>          if (unlikely(err)) {
>>                  JFFS2_ERROR("read remainder of name: error %d\n", err);
>>                  jffs2_free_full_dirent(fd);
>>                  return -EIO;
>>          }
>>
>> Is it intentional that the first if doesn't free fd?  At first I thought
>> that that might be the case, because what would be the point of having two
>> conditionals if they are going to do the same thing.  But I can't see why
>> fd should not be freed either, so maybe the two conditionals are just
>> there to give different error messages?
>
> Hi Julia,
>
> I think this is a bug and thes conditionals can be joined into one.

Thanks!  I will send a patch soon.

julia
