Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0DZXEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:04:43 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47141 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab0DZXEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Sy266KMRws8QbeTVqx0rlnvcxefHBL1pyzgXf6q9W5T1NOghO04/s/ywErlDfwgK1I
         SqvNQammq/bf0LOJBAaMRyfXflSRgKmFQ1P5NA5tWre7mdL5kIP5gtt4RBf2LfsaOdku
         qmmV8bdkn74R7Qnayn6GX+r1cwr6PI/KdsrRE=
Date: Tue, 27 Apr 2010 01:04:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, jblunck@suse.de, mingo@elte.hu,
       jkacur@redhat.com
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Message-ID: <20100426230434.GC5695@nowhere>
References: <alpine.LFD.2.00.1004251040340.3739@i5.linux-foundation.org> <201004261030.21751.arnd@arndb.de> <alpine.LFD.2.00.1004261104310.3739@i5.linux-foundation.org> <20100426.134207.229746269.davem@davemloft.net> <20100426220936.GB5695@nowhere> <alpine.LFD.2.00.1004261525410.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004261525410.3739@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 03:32:51PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 27 Apr 2010, Frederic Weisbecker wrote:
> > 
> > I've queued it for the next merge window in
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	bkl/ioctl
> 
> Btw, I hope you took the second version, that had the two additional fixes 
> from Arnd (and my expansion of his fix to au1550_ac97.c).


Yeah.


 
> Looking at the arch code, I doubt there are any big architecture-specific 
> things. But there could easily be some other drivers like au1550_ac97.c 
> that only get enabled on certain architectures and missed the grepping for 
> some reason.
> 
> That said, because of Arnd's fix, I did end up grepping for 
> 'file_operations' and old-style gcc initializers (ie "ioctl: xyz" rather 
> than the proper ".ioctl = xyz"), and the grep came up empty.
> 
> But it's possible that there's something hiding: with all of serial, 
> bluetooth, block drivers, sound, socket proto's and v4l2 each having their 
> own 'ioctl' pointers, it's not entirely trivial to grep for it all and be 
> sure..
> 
> So there might be one or two cases still hiding, but it looks unlikely. 
> And I'm almost certain that it definitely isn't more than just one or two.


Ok, thanks.

