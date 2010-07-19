Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab0GSEgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 00:36:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48340 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab0GSEgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 00:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bZiX/GcB+iyOaNgFxAhtrW1tuuS+swkS3y7I1Y38HgDHIzvR342FHLVZoElv6D7lWL
         7CJTMN61cuFgH5mifWVx5bf2J96X+E84cjr2CIGZUM+Me+FetATIrjqY96WL6tSdEJfK
         2X3vUwkt3wFp7aWJ9LzPDHnP4gmieeBNnZrgA=
MIME-Version: 1.0
In-Reply-To: <4C42B98E.4020208@vflare.org>
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org>
	<1279283870-18549-8-git-send-email-ngupta@vflare.org>
	<4C42B2E4.4040504@cs.helsinki.fi>
	<4C42B98E.4020208@vflare.org>
Date: Mon, 19 Jul 2010 13:36:42 +0900
Message-ID: <AANLkTinjJLaDVenwNcxgN7ycr97XLN_DVi1ckXBZetZm@mail.gmail.com>
Subject: Re: [PATCH 7/8] Use xvmalloc to store compressed chunks
From: Minchan Kim <minchan.kim@gmail.com>
To: ngupta@vflare.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Sun, Jul 18, 2010 at 5:21 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> On 07/18/2010 01:23 PM, Pekka Enberg wrote:
>> Nitin Gupta wrote:
>>> @@ -528,17 +581,32 @@ static int zcache_store_page(struct zcache_inode_rb *znode,
>>>          goto out;
>>>      }
>>>
>>> -    dest_data = kmap_atomic(zpage, KM_USER0);
>>> +    local_irq_save(flags);
>>
>> Does xv_malloc() required interrupts to be disabled? If so, why doesn't the function do it by itself?
>>
>
>
> xvmalloc itself doesn't require disabling interrupts but zcache needs that since
> otherwise, we can have deadlock between xvmalloc pool lock and mapping->tree_lock
> which zcache_put_page() is called. OTOH, zram does not require this disabling of
> interrupts. So, interrupts are disable separately for zcache case.

cleancache_put_page always is called with spin_lock_irq.
Couldn't we replace spin_lock_irq_save with spin_lock?

-- 
Kind regards,
Minchan Kim
