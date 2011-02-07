Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1BGSZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:25:59 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23128 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab1BGSZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:25:58 -0500
Date: Mon, 7 Feb 2011 19:24:43 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: tadeusz.struk@intel.com
cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, aidan.o.mahony@intel.com,
        gabriele.paoloni@intel.com, adrian.hoban@intel.com
Subject: Re: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
In-Reply-To: <4d502ccb.p+rKcuFjWCnBlXY9%tadeusz.struk@intel.com>
Message-ID: <alpine.LNX.2.00.1102071922220.27796@swampdragon.chaosbits.net>
References: <4d502ccb.p+rKcuFjWCnBlXY9%tadeusz.struk@intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, tadeusz.struk@intel.com wrote:

> From: 
> Date: Sun, 16 Jan 2011 16:41:11 +0000
> Subject: RE: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in rfc4106_set_hash_subkey().
> 
> Hi Jesper,
> Thanks, but I think there is still a problem here. You don't want to kfree req_data
> when the kmalloc failed. I think it should look as follows.  
> Are you ok with this?
> 
Fine by me.

I was aware of the kfree(NULL) thing, but desided to leave it as is for 
two reasons - 1) kfree(NULL) is harmless and this is an error path, so the 
extra function call doesn't matter much. 2) I wanted to preserve 
deallocations in the reverse order of the allocations. But sure, moving 
that kfree is a tiny optimization of the error path, so I'm fine with it.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

