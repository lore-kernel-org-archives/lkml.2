Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1D0IWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:22:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52613 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab1D0IW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YLAlDYltmWw/OPfhJ8bXK05yLq/b3kKDdeHQG3OlZ0iU9Lox4yM+jeOuTXWAo3quON
         ETV1U7uC05BquoyYEOxUfy3KHxIK9Wmedfo/DUH9RG4FJDkQSEhygLMoCVjipHbPI97q
         PPCeDRXbGgvRWJJbB5d/+YRnKdK+hrLO7N3NE=
Date: Wed, 27 Apr 2011 16:22:24 +0800
From: Lifeng Sun <lifongsun@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Applying inappropriate ioctl operation on socket should
 return ENOTTY
Message-ID: <20110427082224.GC20313@md5.ntu.edu.sg>
References: <1303882625-28115-1-git-send-email-lifongsun@gmail.com>
 <1303883910.2699.53.camel@edumazet-laptop>
 <20110427063730.GA20313@md5.ntu.edu.sg>
 <1303887457.2699.60.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303887457.2699.60.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21hg (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:57 Wed 04/27/11 Apr, Eric Dumazet wrote:
> You quote manpage for a library call, not a system call.

okay, let me quote the one for ioctl system call:

man 2 ioctl

int ioctl(int d, int request, ...);

ERRORS
   EBADF  d is not a valid descriptor.
   EFAULT argp references an inaccessible memory area.
   EINVAL Request or argp is not valid.
   ENOTTY d is not associated with a character special device.
   ENOTTY The specified request does not apply to the kind of object
     that the descriptor d references.

we see ENOTTY and EFAULT refine EVINAL and it should return ENOTTY or
EFAULT whenever possible rather than EINVAL, otherwise we could always
return EBADF or EINVAL.

Regarding to isatty, well, it's only a library call, isn't it? :-) If
you insist on the significance of the manpage of isatty, there are
also a lot of ioctl operations return ENOTTY, if not less than those
return EINVAL, for inappropriated command and eventually violate the
ERRORS section of the manpage. Certainly we could complain to c
library maintainers.


> If you feel your glibc doesnt implement well this, please complain to
> glibc maintainer.


-- 
