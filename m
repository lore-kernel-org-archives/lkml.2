Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2IFDFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:05:22 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:42455 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2IFDFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:05:21 -0400
Message-ID: <504812E7.3000700@linux.vnet.ibm.com>
Date: Thu, 06 Sep 2012 11:05:11 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] slab: fix the DEADLOCK issue on l3 alien lock
References: <5044692D.7080608@linux.vnet.ibm.com> <5046B9EE.7000804@linux.vnet.ibm.com> <0000013996b6f21d-d45be653-3111-4aef-b079-31dc673e6fd8-000000@email.amazonses.com>
In-Reply-To: <0000013996b6f21d-d45be653-3111-4aef-b079-31dc673e6fd8-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12090603-3568-0000-0000-0000026C85BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 09:55 PM, Christoph Lameter wrote:
> On Wed, 5 Sep 2012, Michael Wang wrote:
> 
>> Since the cachep and cachep->slabp_cache's l3 alien are in the same lock class,
>> fake report generated.
> 
> Ahh... That is a key insight into why this occurs.
> 
>> This should not happen since we already have init_lock_keys() which will
>> reassign the lock class for both l3 list and l3 alien.
> 
> Right. I was wondering why we still get intermitted reports on this.
> 
>> This patch will invoke init_lock_keys() after we done enable_cpucache()
>> instead of before to avoid the fake DEADLOCK report.
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Thanks for your review.

And add Paul to the cc list(my skills on mailing is really poor...).

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

