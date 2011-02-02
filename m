Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1BBKeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 05:34:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63531 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab1BBKeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:34:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hd01tg0ThjNclpxXwy/MVMtIq+e2eAA+L9nXEpxqnFDA1SnrPi3YZI/cPVbBROL+kZ
         nEx1F1JYA32rFcms+QPAU+r0x4Fd38KMap/HCD0XgKYZh5lsVAbbjKamg2gBMdmd9lI1
         eZyLvzt+mIbc7DS49NpUWmHQ5WJfWuBNho/Hk=
Date: Wed, 2 Feb 2011 11:34:02 +0100
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ptrace: use safer wake up on ptrace_detach()
Message-ID: <20110202103402.GB24115@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-3-git-send-email-tj@kernel.org>
 <20110128184601.CBF7C180996@magilla.sf.frob.com>
 <20110131103855.GD7459@htj.dyndns.org>
 <20110201102618.GE14211@htj.dyndns.org>
 <20110201162729.f75be47d.akpm@linux-foundation.org>
 <20110202053331.C27C6183D88@magilla.sf.frob.com>
 <20110201213828.c3df7e87.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201213828.c3df7e87.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 01, 2011 at 09:38:28PM -0800, Andrew Morton wrote:
> On Tue,  1 Feb 2011 21:33:31 -0800 (PST) Roland McGrath <roland@redhat.com> wrote:
> 
> > > Am unable to work out why you tagged it for backporting.  It fixes some
> > > observed bug?  Perhaps a regression?
> > 
> > No observed bug, only theoretical ones (AFAIK, never even a ginned-up
> > synthetic test case has been demonstrated).  Certainly not a regression,
> > since it has been this (wrong) way since the dawn of time.  I don't think
> > this first change is dangerous for -stable, but I have seen no positive
> > rationale for pushing it there.
> > 
> 
> OK, thanks.  I shall destabilize my copy of this patch.

It can be used as an attack vector.  I don't think it will take too
much effort to come up with an attack which triggers oops somewhere.
Most sleeps are wrapped in condition test loops and should be safe but
we have quite a number of places where sleep and wakeup conditions are
expected to be interlocked.  Although the window of opportunity is
tiny, ptrace can be used by non-privileged users and with some loading
the window can definitely be extended and exploited.

The chance of this problem being visible under normal usage is
extremely low so no wonder there is no related bug report but that is
very different from being safe against targeted attacks.

As the likelihood of causing user noticeable breakage is very low, I
think we better push it through -stable.

Thanks.

-- 
tejun
