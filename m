Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1BARe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:34:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17265 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab1BAReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:34:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NfUaqb/lnpgNFF4ILKHnvHpBUNWXH5w69peRH37rirwCd5x43Q9cgoVmzrjDTFi2eT
         YLyZHYUJXM9u/+m1ch9g==
Date: Tue, 1 Feb 2011 09:34:12 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
In-Reply-To: <1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk>
Message-ID: <alpine.LSU.2.00.1102010909270.1586@sister.anvils>
References: <849307$bc24ct@azsmga001.ch.intel.com> <1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Chris Wilson wrote:

> Hugh Dickins found that characters in xterm were going missing and oft
> delayed. Being the curious type, he managed to associate this with the
> new high-precision vblank patches; disabling these he found, restored
> the orderliness of his characters.
> 
> The oddness begins when one realised that Hugh was not using vblanks at
> all on his system (fvwm and some xterms). Instead, all he had to go on
> were warning of a pipe underrun, curiously enough at around 60Hz. He
> poked and found that in addition to the underrun warning, the hardware
> was flagging the start of a new frame, a vblank, which in turn was
> kicking off the pending vblank processing code.
> 
> There is little we can do for the underruns on Hugh's machine, a
> Crestline [965GM], which must have its FIFO watermarks set to 8.
> However, we do not need to process the vblank if we know that they are
> disabled...
> 
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

Thanks a lot for devising this, Chris, I really appreciate it.

But so far I can't be more enthusiastic than "seems to be a good
improvement most of the time" - though I've not spent long on this
laptop since putting it on to -rc3.

I've not seen it go wrong on x86_64, but my first boot with it on
i386 behaved just as badly as before; thereafter it's not gone wrong
yet (and I had to double-check boot.omsg to make sure I'd really been
running what I thought I was running the first time).  I'm relying
upon it to type this mail, which I wouldn't have managed before.

As you know (I went off-list to send more info at the weekend), this
behaviour is very elusive, probably depends on more than one issue,
comes and goes with irrelevant patches and config changes and reboots.

So I don't yet have a lot of confidence that your patch will work out
better in the long run than what I tried at the weekend (when moving
do_intel_finish_page_flip's do_gettimeofday back into the work->event
block worked well until the evening).  If I had time, I'd experiment
further - but I don't have time, so I'll just keep running with your
patch to gather more confidence in it.

So far, so (fairly) good.

Thanks,
Hugh
