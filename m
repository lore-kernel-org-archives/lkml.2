Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0EQT1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:27:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1044 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab0EQT1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:27:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=nkRjB1ciPVtEb+PUCFJF2jnPRNqzNzBdx1EN0GDkckzQTOODOVZzcLd2d+XOypl0+
	UjTMLpFpw6o6M3fFaIcJQ==
MIME-Version: 1.0
In-Reply-To: <20100516133820.GA25820@infradead.org>
References: <20100513051953.532821BC316@ruihe.smo.corp.google.com>
	 <20100516133820.GA25820@infradead.org>
Date: Mon, 17 May 2010 12:27:28 -0700
Message-ID: <AANLkTikkNMPgc3ppjNvq1c_xwBB13hZ_AEMZymqRUjyn@mail.gmail.com>
Subject: Re: [PATCH, RFC] addjust discard request to be aligned with hwsect 
	size to support SSDs with larger sector size
From: Jiaying Zhang <jiayingz@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, mrubin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 6:38 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, May 12, 2010 at 10:19:53PM -0700, Jiaying Zhang wrote:
>> The currect blkdev_issue_discard() function assumes 512 sector size.
>> We have seen some problem when using discard on a SSD that has larger
>> sector size. The following patch adjusts the starting address and size of
>> a discard request to be aligned with hwsect size.
>
> Looks good,
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
>> -     if (!blk_queue_discard(q))
>> +     if (!blk_queue_discard(q) || q->limits.max_discard_sectors == 0)
>>               return -EOPNOTSUPP;
>
> But this change is unrelated.  It's fine with me, but needs a patch of
> it's own with a proper description.
>
I will break the patch into two.

Thanks!

Jiaying
>
