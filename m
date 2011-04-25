Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab1DYLTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:19:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40405 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab1DYLTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P9l7uvY3Uj9g2RrOUsfZo6pS0RNLuo6vaCn+cJ2kseksqnrINBrYkpXVWM+kdO+pxU
         8kutjvEXzx5MZw07AmZlkYlB0ouHfjMtmzo5hfZeS/BSxuh4LulLw9dMVUaNLgdR3Sgc
         AYEax2RPcNcOlHP1SejMWLORfyIvGQypBnLB8=
Date: Mon, 25 Apr 2011 13:19:49 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] x86: signal: handle_signal() should use
 set_current_blocked()
Message-ID: <20110425111949.GI17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <20110418134615.GG15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134615.GG15951@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 03:46:15PM +0200, Oleg Nesterov wrote:
> This is ugly, but if sigprocmask() needs retarget_shared_pending() then
> handle signal should follow this logic. In theory it is newer correct to
							  never?

> add the new signals to current->blocked, the signal handler can sleep/etc
> so we should notify other threads in case we block the pending signal and
> nobody else has TIF_SIGPENDING.
> 
> Of course, this change doesn't make signals faster :/

I don't think it's gonna make things go much slower either except for
pathological cases.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
