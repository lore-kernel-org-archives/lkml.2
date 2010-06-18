Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942Ab0FRR73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:59:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46520 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933932Ab0FRR7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AkJQAmfDkO4eYKoybXAGHDlNCS4CWHM9whvwdjcmCW4V6xCG+VKi6P9DyTuGlpNx2Z
         54kMyo71GVD46da1QFcbb0nQkHPFkTDOqM6/BgOXNmPQhgfrdiPOhOsJTa3jS1QSsUGH
         AP8hLJ9+WeaNLfFhyxKWGAjPSCsoe8y/K5bzw=
Date: Fri, 18 Jun 2010 19:57:26 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: Dan Carpenter <error27@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [patch] x86, pat: freeing invalid memtype messages
Message-ID: <20100618175726.GA2785@joi.lan>
References: <20100617134559.GA29824@bicker>
 <20100617161728.GA2741@joi.lan>
 <4C1B1691.6020809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1B1691.6020809@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 02:47:45PM +0800, Xiaotian Feng wrote:
> On 06/18/2010 12:17 AM, Marcin Slusarz wrote:
> > On Thu, Jun 17, 2010 at 03:45:59PM +0200, Dan Carpenter wrote:
> >> Commit 20413f27163 "x86, pat: Fix memory leak in free_memtype" added an
> >> error message in free_memtype() if rbt_memtype_erase() returns NULL.
> >> The problem is that if CONFIG_X86_PAT is enabled, we use a different
> >> implimentation of rbt_memtype_erase() that always returns NULL.
> >>
> >> I've modified rbt_memtype_erase() to return an ERR_PTR() on errors and
> >> made free_memtype() check for that instead.
> >>
> >> Addresses:  https://bugzilla.kernel.org/show_bug.cgi?id=16205
> >>
> >> Signed-off-by: Dan Carpenter<error27@gmail.com>
> >
> > This patch is probably ok, but it does not address my bug.
> > I have CONFIG_X86_PAT=y, so rbt_memtype_erase does not always return NULL.
> 
> Could you please try boot with kernel parameter "debugpat", and
> show me the output of reserve_memtype/free_memtype ?
> 

reserve_memtype added 0xfed00000-0xfed01000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf780000-0xbf78d000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf79a000-0xbf79d000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf798000-0xbf799000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf780000-0xbf781000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf798000-0xbf799000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf7dc000-0xbf7dd000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf780000-0xbf781000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf798000-0xbf799000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf780000-0xbf781000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf798000-0xbf799000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf78f000-0xbf790000, track uncached-minus, req uncached-minus, ret uncached-minus
reserve_memtype added 0xbf78f000-0xbf790000, track uncached-minus, req uncached-minus, ret uncached-minus
free_memtype request 0xbf798000-0xbf799000
reserve_memtype added 0xbf798000-0xbf799000, track uncached-minus, req uncached-minus, ret uncached-minus
free_memtype request 0xbf798000-0xbf799000
reserve_memtype added 0xbf798000-0xbf799000, track uncached-minus, req uncached-minus, ret uncached-minus
free_memtype request 0xbf798000-0xbf799000
reserve_memtype added 0xbf798000-0xbf799000, track uncached-minus, req uncached-minus, ret uncached-minus
free_memtype request 0xbf798000-0xbf799000
reserve_memtype added 0xbf799000-0xbf79a000, track uncached-minus, req uncached-minus, ret uncached-minus
free_memtype request 0xbf799000-0xbf79a000
reserve_memtype added 0xbf799000-0xbf79a000, track uncached-minus, req uncached-minus, ret uncached-minus
swapper:1 freeing invalid memtype bf799000-bf79a000


http://kadu.net/~joi/kernel/2010.06.09/2.6.35-rc3-debugpat.txt

Marcin
