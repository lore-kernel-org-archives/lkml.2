Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab1ECCSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 22:18:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51364 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1ECCSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 22:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YH/DwOmjChGC3t9Z2mvSNfOnQsJ3B/5dnaV6T8d34f1+921D/YCAOC02z1glirjX+8
         TZ/iWQjm7DH7PZD4Vv+i8LjRZak71aiMYEsCmwDUuGiYKqne3Bobw3Mp0Wi9bgimKOfD
         NcqFkBJKig3hRP7cSar3Znevqsr2sjx1OCliQ=
Message-ID: <4DBF66C0.9020600@gmail.com>
Date: Tue, 03 May 2011 10:21:52 +0800
From: =?UTF-8?B?5bq35YmR5paM?= <kjbmail@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Subject: Re: Can I/OAT DMA engineer access PCI MMIO space
References: <4DBA8F30.2060206@gmail.com> <1304316260.1589.2.camel@vkoul-udesk3>
In-Reply-To: <1304316260.1589.2.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I try to use ioatdam to copy data from system memory to pci MMIO space:
>> If dst points to a memory space, the operation would pass.
>> But if dst points to a pci MMIO space, it failed with kernel oops.
>> It seems the code:
>> BUG_ON(is_ioat_bug(chanerr));
>> in drivers/dma/ioat/dma_v3.c, line 365 cause the oops.
>> Is there anyway to access pci MMIO space using ioat?
>> The datasheet says that ioat supports MMIO access.
> Did you map the IO memory in kernel using ioremap and friends first?
>
yes, I had used 'ioremap_nocache' to map the IO memory and I can use
memcpy to copy data to this region. The async_tx should have been 
correctly configured as
I can use aync_memcpy to copy data between different system memory address.

