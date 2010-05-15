Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0EOObX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 10:31:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:54079 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab0EOObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 10:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XUh381c03vk2zmE9zkoUtp+x3wwf8snxyx2/ekQDMd1YpxtjVSU5hmCUDJa7LZ/+ub
         qGt1zZ0xlpaEFqTR6qX0iDuIxc2kjw5urwVJtCblk7qqSxCxbyuChvAF2Cu+wqpFReow
         NdHV4Td+H7RIjJ3cuunANRtzxMFT6Uq8cWmfk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1005141626250.20193@router.home>
References: <1273869997-12720-1-git-send-email-gthelen@google.com>
	 <alpine.DEB.2.00.1005141626250.20193@router.home>
Date: Sat, 15 May 2010 23:31:16 +0900
X-Google-Sender-Auth: MzuVEHXiNTuBblx8KUnrlJIkyuU
Message-ID: <AANLkTil4zgqBtBAp--P8VdynpbohxVosQ-qFiQQ_c5Bb@mail.gmail.com>
Subject: Re: [PATCH] mm: Consider the entire user address space during node 
	migration
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Cc: Greg Thelen <gthelen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, Mel Gorman <mel@csn.ul.ie>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Mysteriously, I haven't receive original post.
So now I'm guessing you acked following patch.

http://lkml.org/lkml/2010/5/14/393

but I don't think it is correct.

> -	check_range(mm, mm->mmap->vm_start, TASK_SIZE, &nmask,
> +	check_range(mm, mm->mmap->vm_start, TASK_SIZE_MAX, &nmask,
> 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);

Because TASK_SIZE_MAX is defined on x86 only. Why can we ignore other platform?
Please put following line anywhere.

#define TASK_SIZE_MAX TASK_SIZE


But this patch is conceptually good. if it fixes the bug. I'll ack gladly.

Thanks.
