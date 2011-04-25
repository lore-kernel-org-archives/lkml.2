Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab1DYLFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:05:42 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34125 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab1DYLFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rvWBCnASuvbIY9uyhA4QYwkM0kUaG0TQGhd9UWpWeJQr5V2v0x8ak5zSNzR0K38/SU
         FjTC6r8UMg6nlT5CF2bz+SACisym27X86H+G9z2TBM5it2VPSczGDr+TwDo2u6fkkuDL
         tdE9d+YnpKRI6bKsNb1mc0nPiznhnBwDMYZ4s=
Date: Mon, 25 Apr 2011 13:05:36 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] signal: sigprocmask: narrow the scope of
 ->siglock
Message-ID: <20110425110536.GG17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <20110418134538.GE15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134538.GE15951@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 03:45:38PM +0200, Oleg Nesterov wrote:
> No functional changes, preparation to simplify the review of the next change.
> 
> 1. We can read current->block lockless, nobody else can ever change this mask.

                 current->blocked

> 
> 2. Calculate the resulting sigset_t outside of ->siglock into the temporary
>    variable, then take ->siglock and change ->blocked.
> 
> Also, kill the stale comment about BKL.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
