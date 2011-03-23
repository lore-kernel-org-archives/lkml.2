Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab1CWPWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:22:32 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:48381 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933030Ab1CWPWb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:22:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=J5KvVYhVxaw4EYpTMTQeQ+14fWxXadp875PY1XD4AyNV/imqLu5+5pYNCGJeVAUJ9fEf8RED8AXboFlVZ5ZbxHim0/bEGOrg0o+CgZ+DrcKzxlqYrwmr2qv6nQIt47DJ;
Date: Wed, 23 Mar 2011 08:22:26 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: sclark46@earthlink.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm next tree
Message-ID: <20110323082226.04510229@jbarnes-desktop>
In-Reply-To: <4D89E5E1.3070402@earthlink.net>
References: <alpine.DEB.2.00.1103170403160.3429@skynet.skynet.ie>
	<AANLkTinoTs89ThBnZ17+fPE+t1V=GycKq2EJG-LadFZQ@mail.gmail.com>
	<4D89E5E1.3070402@earthlink.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011 08:21:53 -0400
Stephen Clark <sclark46@earthlink.net> wrote:

> On 03/22/2011 10:19 PM, Linus Torvalds wrote:
> > So I had  hoped - yes, very naïve of me, I know - that this merge
> > window would be different.
> >
> > But it's not.
> >
> > On Wed, Mar 16, 2011 at 9:09 PM, Dave Airlie<airlied@linux.ie>  wrote:
> >    
> >> i915: big 855 fix, lots of output setup refactoring, lots of misc fixes.
> >>      
> > .. and apparently a lot of breakage too. My crappy laptop that I abuse
> > for travel is - once more - broken by the updates. I cannot suspend
> > and resume, because every resume seems to fail.
> >
> > One of the more useful failures was:
> >
> > [   61.656055] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
> > elapsed... GPU hung
> > [   61.656079] [drm] capturing error event; look for more information
> > in /debug/dri/0/i915_error_state
> > [   61.664387] [drm:i915_wait_request] *ERROR* i915_wait_request
> > returns -11 (awaiting 2 at 0, next 3)
> >
> > and I'm attaching the error_state file from that particular case here.
> > In other cases it seems to just hang entirely.
> >
> > Keith/Jesse/Chris - I don't know that it's i915, and it will take
> > forever to bisect (I'll try). But it does seem pretty likely.
> >
> >                               Linus
> >    
> Why can't the gpu be reset/restarted when this happens? When a nic card 
> gets hung it is reinitialized
> and restarted why not the gpu?

Yeah, we try to restart in this case, but often just end up back in the
same situation when the app runs again.  We could be meaner about
things and SIGILL the app, but often it's an innocent bystander, and
the real problem is kernel object synchronization and/or the DRI driver
generating bad commands.

-- 
Jesse Barnes, Intel Open Source Technology Center
