Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937435Ab0CPGJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:09:49 -0400
Received: from smtp124.mail.ukl.yahoo.com ([77.238.184.55]:24961 "HELO
	smtp124.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935545Ab0CPGJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:09:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=325BtjKYlNLN+BcXCt6tD+hJfjvkECcrkeU5TQz2jrdl3FvP7WGacrjLl8BiwjwT9vklzQ+LtBR33GBRizsHkuSNomG1rMQUrwrmp18x/T7jEX91YZMFOkiFzFFfiSOQNpXOjlynt3/XVcVlNfiQ0xeHUCD1hBdNc3w8mzRKiDw=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: et4YdXYVM1mTkJd9Wze8.N_1x6RpRtv2WQgOCRjwqeLU8nGZ3_J07DsuM9zBVA4EdM.z5mK95QU8EFFfHb74FbJu4Hmqzh4sGj3iBq6ZN7jEA1MiX9MR6_.a2xEErmu0KH69CAvCfmw3KotnYP43RA5wDpu8.VasNPzaKhh8UM6pcqXON8EOGh16p3JfGKnl08AO55uT0fWqJdg0xJDYRjw11d2ifRRVyiLtvU32I0Tgyh73K1BbLXL8xU8anUVgSjFV9L71qJtS3JQ1qzCkDTy3.It9UPKSIQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B9F20A7.4040708@yahoo.es>
Date: Tue, 16 Mar 2010 07:09:43 +0100
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH v4 04/11] swiotlb: support NOT_COHERENT_CACHE PowerPC
 platforms
References: <1268421166-4791-1-git-send-email-albert_herranz@yahoo.es>	<1268421166-4791-5-git-send-email-albert_herranz@yahoo.es> <20100316105423B.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100316105423B.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Fri, 12 Mar 2010 20:12:39 +0100
> Albert Herranz <albert_herranz@yahoo.es> wrote:
> 
>> The current SWIOTLB code does not support NOT_COHERENT_CACHE platforms.
>> This patch adds support for NOT_COHERENT_CACHE platforms to SWIOTLB by
>> adding two platform specific functions swiotlb_dma_sync_page() and
>> swiotlb_dma_sync() which can be used to explicitly manage cache coherency.
>>
>> On PowerPC these functions are mapped to their corresponding
>> __dma_sync_page() and __dma_sync() functions.
>> On other architectures using SWIOTLB these functions are optimized out.
>>
>> This will be used later to support SWIOTLB on the Nintendo Wii video game
>> console.
>>
>> CC: linuxppc-dev@lists.ozlabs.org
>> CC: linux-kernel@vger.kernel.org
>> CC: x86@kernel.org
>> CC: linux-ia64@vger.kernel.org
>> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
>> ---
>>  arch/ia64/include/asm/swiotlb.h    |   10 ++++++++++
>>  arch/powerpc/include/asm/swiotlb.h |    3 +++
>>  arch/x86/include/asm/swiotlb.h     |   10 ++++++++++
>>  lib/swiotlb.c                      |   30 ++++++++++++++++++++++++------
>>  4 files changed, 47 insertions(+), 6 deletions(-)
> 
> Why can't you use dma_sync_single_* instead of inventing new
> swiotlb sync functions?
> 

At least on PowerPC, the DMA ops are per-device hooks. We attach the swiotlb DMA ops functions to those hooks when we are using swiotlb.
So calling dma_sync_single_*() would end up calling swiotlb_sync_single_*() which is not what we want.

Thanks,
Albert

