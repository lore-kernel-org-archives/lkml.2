Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0GJV4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:56:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61191 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab0GJVz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iT9JuZSUs4+uC7jaGfyt3FdHc35pH/US4rBI5mjGnEMxwrXGd6wVKdGOzlFuzxToB7
         s4AAq2ysDltwZK8gs636VqxojnsK+2n28umI/A+iCfxQyCJZkSQ6O9VbYiGnsxX7fAyn
         d2GuYOGmLo7jQdrQsQ9hbQ2m9LKK/z1rjkvOU=
Date: Sun, 11 Jul 2010 01:55:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] x86: Early-boot serial I/O support
Message-ID: <20100710215554.GE6615@lenovo>
References: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi> <20100710210750.GC6615@lenovo> <4C38E7FD.9020403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C38E7FD.9020403@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 02:37:01PM -0700, H. Peter Anvin wrote:
> On 07/10/2010 02:07 PM, Cyrill Gorcunov wrote:
> > On Sat, Jul 10, 2010 at 10:40:20PM +0300, Pekka Enberg wrote:
> >> This patch adds serial I/O support to very early boot printf(). It's useful for
> >> debugging boot code when running Linux under KVM, for example. The actual code
> >>  
> >> +#define cpu_relax()	asm volatile("rep; nop" ::: "memory")
> >> +
> 
> We don't need "memory" here since the early boot environment is
> single-threaded.
> 
> 	-hpa
> 

I rather wonder -- can't we use cpu_relax() from processor.h? Or there
is some type conflicts?

	-- Cyrill
