Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1D0NEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:04:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61689 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab1D0NEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sU4B+QKbmJjWj3wzoOWkpqKZctEB0qUV6RcsbV8NUvex4gbkdqrqnnMOOHYS6iDZOp
         YsSDjExErQQ4PHW90CR+KEG3M64c1UfRR9ECl82xohI2H+x3Ri0ZC1buFEdn9Gy248cG
         TzBG5iyoCQ+hTJPiIMbmigzJkEZlUDgMMZLLg=
Date: Wed, 27 Apr 2011 15:04:06 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] signal: sys_sigprocmask() needs
 retarget_shared_pending()
Message-ID: <20110427130406.GG31015@htj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com>
 <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com>
 <20110426194822.GA8520@redhat.com>
 <20110426195002.GF8520@redhat.com>
 <BANLkTinp8FGQu2D1NVVc7xfEsqopook7Hg@mail.gmail.com>
 <20110427125710.GA21281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427125710.GA21281@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just my 5 cents.

On Wed, Apr 27, 2011 at 02:57:10PM +0200, Oleg Nesterov wrote:
> Yes, sigprocmask(how) is ugly, but there are sys_rt_sigprocmask() and
> sys_sigprocmask() which have to handle these SIG_* operations anyway.
> So, I think we should do:
> 
> 	1. Almost all callers of sigprocmask() use SIG_SETMASK, we can
> 	   simply change them to use set_current_blocked().

I agree.  We don't need to worry about atomicity here, so there's no
reason to encode bitops (be it and/or or andn/xor) when the
determination of the new value can be simply done in the caller.

Thanks.

-- 
tejun
