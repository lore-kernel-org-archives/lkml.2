Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1L0IgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 03:36:13 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:18633 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021Ab1L0IgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 03:36:08 -0500
X-IronPort-AV: E=Sophos;i="4.71,415,1320620400"; 
   d="scan'208";a="136957654"
Date: Tue, 27 Dec 2011 09:36:04 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/mtd/maps/lantiq-flash.c: drop iounmap for
 devm_ allocated data
In-Reply-To: <1324974236.1165.43.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.02.1112270935410.1838@localhost6.localdomain6>
References: <1324921081-13161-2-git-send-email-julia@diku.dk> <1324974236.1165.43.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011, Artem Bityutskiy wrote:

> On Mon, 2011-12-26 at 18:38 +0100, Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> Data allocated with devm_ioremap or devm_ioremap_nocache should not be
>> freed using iounmap, because doing so causes a dangling pointer, and a
>> subsequent double free.
>>
>> The semantic match that finds this problem is as follows:
>> (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @r@
>> expression x;
>> @@
>> (
>>  x = devm_ioremap(...)
>> |
>>  x = devm_ioremap_nocache(...)
>> )
>>
>> @@
>> expression r.x;
>> @@
>> * iounmap(x)
>> // </smpl>
>
> Thanks Julia,
>
> surely this semantic patch script is worth adding to scripts/coccinelle?
> Are you going to take care of this?

OK, I will do that.

julia
