Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1EKT3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:29:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47361 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab1EKT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:29:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r3AElS+px40Vov6eQcLlDX4ot9aQLwrPP+XByxECrFo5kVSYfSZ6zhTxr0YcmK+PGT
         mhpHElBw0rnP4hVaxQJEeszMJOkTN6RvIE/5yk6x17QlAVJaYQ65LwL+MPB8aIfY1NGC
         ik2tN4bn0d0icDsG0pdK4BPz5C8kg+cw797Co=
Date: Wed, 11 May 2011 21:29:02 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 09/11] job control: reorganize wait_task_stopped()
Message-ID: <20110511192902.GC24245@mtj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-10-git-send-email-tj@kernel.org>
 <20110511154854.GB23688@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511154854.GB23688@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 11, 2011 at 05:48:54PM +0200, Oleg Nesterov wrote:
> >   It seems that WNOHANG wait correctness has never been guaranteed and
> >   everybody has been happy with it for very long time.
> 
> Yes, the window is tiny. May be it was never noticed or never
> reported because this is hard to diagnose/reproduced.

Yeah, most likely.

> > As such,
> >   although this reorganization improves the situation a bit, I don't
> >   consider this to be a bug fix.
> 
> But it is?
> 
> Can't we push this patch ahead of these changes? I can merge it into
> ptrace branch.

It doesn't really fix the problem tho.  The whole thing is full of
holes and I think it would be better to just declare "WNOHANG might
fail even when it's not supposed to, retry later" than making the
locking heavier there, which could easily be much more relevant
regression.  Of course, if we can fix it without adding extra locking
or too much complexity, it would be nice.

Anyways, yeah, sure.  I'll resend it as a separate patch.

Thanks.

-- 
tejun
