Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2HNFgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 01:36:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50591 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2HNFgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 01:36:51 -0400
Message-ID: <5029E3EF.9080301@vflare.org>
Date: Mon, 13 Aug 2012 22:36:47 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 0/7] zram/zsmalloc promotion
References: <1344406340-14128-1-git-send-email-minchan@kernel.org> <20120814023530.GA9787@kroah.com>
In-Reply-To: <20120814023530.GA9787@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 07:35 PM, Greg Kroah-Hartman wrote:
> On Wed, Aug 08, 2012 at 03:12:13PM +0900, Minchan Kim wrote:
>> This patchset promotes zram/zsmalloc from staging.
>> Both are very clean and zram is used by many embedded product
>> for a long time.
>>
>> [1-3] are patches not merged into linux-next yet but needed
>> it as base for [4-5] which promotes zsmalloc.
>> Greg, if you merged [1-3] already, skip them.
> 
> I've applied 1-3 and now 4, but that's it, I can't apply the rest
> without getting acks from the -mm maintainers, sorry.  Please work with
> them to get those acks, and then I will be glad to apply the rest (after
> you resend them of course...)
>

On a second thought, I think zsmalloc should stay in drivers/block/zram
since zram is now the only user of zsmalloc since zcache and ramster are
moving to another allocator. Secondly, zsmalloc does not provide
standard slab like interface, so should not be part of mm/. At the best,
it could be moved to lib/ with header in include/linux just like genalloc.

Thanks,
Nitin

