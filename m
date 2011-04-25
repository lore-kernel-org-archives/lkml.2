Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab1DYLts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:49:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60187 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab1DYLtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IS+UsIK8yghGZ9l79oGZUmOuZF3H96YXrA/QdLo5DvCXMJdewOoz8qsA54sWfKjuzI
         kf3ywMmX27Ik6JOxTJboUXPGIBcBWNc0QViuteQSAAbmb0BXsqUSV/PudxF5/k+cjMvO
         XOS+kX97XnFTbvdZse5p6XsGN5ATgsyBCLKAc=
Date: Mon, 25 Apr 2011 13:49:42 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] signal: introduce do_sigtimedwait() to factor out
 compat/native code
Message-ID: <20110425114942.GO17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com>
 <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com>
 <20110423175940.GC484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110423175940.GC484@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just one more thing.

On Sat, Apr 23, 2011 at 07:59:40PM +0200, Oleg Nesterov wrote:
> +int do_sigtimedwait(sigset_t *these, siginfo_t *info, long timeout)

Maybe @these isn't the base name here?  It implies that these are the
signals the function is interested in but in reality it is the
negation of that.  The original function should be blamed for using
the same name while negating its meaning but separating out the
function makes the inconsitency stand out.

Thanks.

-- 
tejun
