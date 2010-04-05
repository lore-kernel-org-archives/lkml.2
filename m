Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0DERaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 13:30:11 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:44850 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab0DERaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 13:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=NeAgLSBcEgvIwFRL/5q90FXZuayhvClH9XAwOKaG/4mIeNUnWSG4so2yGvnk61NX7W
         7UOIX1xr/pCHJFT6DJDxC1DOzju0s/H48Xnjxm+Jz3YhHdD9oxKM7vljohzI8YqqX7B6
         bsDiNqHg4hzmdKz6PTlU1At6uEpqAS0La87rM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1004050853300.23149@router.home>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
	 <1270114166.2078.107.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004011050340.16531@router.home>
	 <1270195589.2078.116.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004050853300.23149@router.home>
Date: Mon, 5 Apr 2010 20:30:06 +0300
X-Google-Sender-Auth: af7f8636c01468fa
Message-ID: <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm CC'ing Tejun)

On Mon, Apr 5, 2010 at 4:54 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Fri, 2 Apr 2010, Zhang, Yanmin wrote:
>
>> My testing command on my 2 socket machine:
>> #hackbench 100 process 20000
>>
>> With 2.6.33, it takes for about 96 seconds while 2.6.34-rc2 (or the latest tip tree)
>> takes for about 101 seconds.
>>
>> perf shows some functions around SLUB have more cpu utilization, while some other
>> SLUB functions have less cpu utilization.
>
> Hmnmmm... The dynamic percpu areas use page tables and that data is used
> in the fast path. Maybe the high thread count causes tlb trashing?

Hmm indeed. I don't see anything particularly funny in the SLUB percpu
conversion so maybe this is a more issue with the new percpu
allocator?
