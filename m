Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1FNGph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:45:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38212 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1FNGpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mpAFUL1cV40ipV5yH/rkg7vZ6ifEV7FWc23IwJtX9oItymih2yYb2Bi6NupQ/De2Wn
         wF8sQIr2RodPAUsAajlQ64Z9Jguxu/BpMvLUKMVqvFik5Y+ofSuWahf7M91OcUkVEVOZ
         2kVInZqe5obLHB16SsW/oJNcWNuJLXNy4/cAo=
Date: Tue, 14 Jun 2011 08:45:29 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 17/17] ptrace: implement PTRACE_LISTEN
Message-ID: <20110614064529.GC8141@htj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <1306710760-16440-18-git-send-email-tj@kernel.org>
 <20110602173330.GA20384@redhat.com>
 <20110613141023.GA8141@htj.dyndns.org>
 <20110613203341.GA15695@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613203341.GA15695@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Mon, Jun 13, 2011 at 10:33:41PM +0200, Oleg Nesterov wrote:
> >   and I don't see
> >   good reasons to optimize it.  Moreover, I think it doesn't hurt to
> >   have a way to reliably trigger spurious notification.
> 
> Well. I don't really understand why, but OK. Let's keep it this way.

So that we can just send SIGCONT to test how applications hold up
against spurious notifications.  ie. making corner case a bit more
common and easier to reproduce so that it's more discoverable /
debuggable.

> > However, I think it's
> >   done the current way for a reason - always trying to wake up on
> >   SIGCONT is more robust in case something went out of sync
> 
> Hmm. I am wondering if we can ever see why == 0 && __TASK_STOPPED with
> the recent fixes...

Probably not but I still think it's a better style to make SIGCONT
_always_ wake up.  <obligatory inaccurate car analogy> It's like a car
brake.  If transmission is in parking, gear interlocking should keep
the wheels from spinning and brake pedal input may be bypassed safely
for most cases, but, still, it's better to guarantee that stepping on
the brake pedal always makes the brake pads squeezed. </a>

Thanks.

-- 
tejun
