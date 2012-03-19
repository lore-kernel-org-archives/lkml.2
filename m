Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032507Ab2CSSzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:55:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34172 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030918Ab2CSSzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:55:08 -0400
Message-ID: <4F678100.1000707@linux.vnet.ibm.com>
Date: Mon, 19 Mar 2012 13:54:56 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] staging: zsmalloc: add user-definable alloc/free funcs
References: <1331931888-14175-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120316213227.GB24556@kroah.com>
In-Reply-To: <20120316213227.GB24556@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031918-3270-0000-0000-000004E7742C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 04:32 PM, Greg Kroah-Hartman wrote:
> On Fri, Mar 16, 2012 at 04:04:48PM -0500, Seth Jennings wrote:
>> This patch allows a zsmalloc user to define the page
>> allocation and free functions to be used when growing
>> or releasing parts of the memory pool.
>>
>> The functions are passed in the struct zs_pool_ops parameter
>> of zs_create_pool() at pool creation time.  If this parameter
>> is NULL, zsmalloc uses alloc_page and __free_page() by default.
>>
>> While there is no current user of this functionality, zcache
>> development plans to make use of it in the near future.
> 
> I'm starting to get tired of seeing new features be added to this chunk
> of code, and the other related bits, without any noticable movement
> toward getting it merged into the mainline tree.

Fair enough

> 
> So, I'm going to take a stance here and say, no more new features until
> it gets merged into the "real" part of the kernel tree, as you all
> should not be spinning your wheels on new stuff, when there's no
> guarantee that the whole thing could just be rejected outright tomorrow.
> 
> I'm sorry, I know this isn't fair for your specific patch, but we have
> to stop this sometime, and as this patch adds code isn't even used by
> anyone, its a good of a time as any.

So, this the my first "promotion from staging" rodeo.  I would love to
see this code mainlined ASAP.  How would I/we go about doing that?

I guess another way to ask is, what needs to be done in the way of
code quality and acks in the community to promote zcache to
/drivers/misc for example?

Also, the tmem part of zcache will (probably, Dan?) be broken
out an placed in /lib.

--
Seth

