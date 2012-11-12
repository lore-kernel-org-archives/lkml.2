Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2KLBqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 20:46:10 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:59363 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2KLBqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 20:46:07 -0500
Message-ID: <50A054D4.2070404@gmail.com>
Date: Mon, 12 Nov 2012 09:45:56 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: steffen.klassert@secunet.com, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/9] net: xfrm: use __this_cpu_read per-cpu helper
References: <509C688B.5010502@gmail.com> <0000013ae6ccff86-695eb9f4-23b6-4196-a575-e12d05e1a659-000000@email.amazonses.com>
In-Reply-To: <0000013ae6ccff86-695eb9f4-23b6-4196-a575-e12d05e1a659-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter said, at 2012/11/10 4:12:
> On Fri, 9 Nov 2012, Shan Wei wrote:
> 
>> v3 fix compile warning:
>> net/xfrm/xfrm_ipcomp.c: In function 'ipcomp_alloc_tfms':
>> net/xfrm/xfrm_ipcomp.c:285: warning: assignment from incompatible pointer type
> 
> Why exactly is the pointer type not compatible? Looks like we have a
> problem here.
> 

pos->tfms(struct crypto_comp **tfms) is a double pointer that point to struct crypto_comp.
returned value is a pointer that point to struct crypto_comp;
So, we need to dereference and then read.

+ tfm = __this_cpu_read(*pos->tfms);

I will update this patch in v4 to fix it.

Thanks~
