Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab0DIAAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 20:00:47 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58325 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215Ab0DIAAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 20:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rSmMRA7MRAcSBGnvgIOfDViJAPy+/dOaRwRaFSZYPBtfAdb3yjvYFutedmN9PO1JP/
         Zhw9uwwpl4a3rIdeMk6LrbEGT4vkjbnxmnMsTSI+VBjb+Yd7uqPZj92ibDPVzA1i/n3R
         Buc6tIaPQ9Bgni5JU5mxey5XgEHccAHbbXKXQ=
Date: Fri, 9 Apr 2010 02:00:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, peterz@infradead.org,
       aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100409000036.GC6672@nowhere>
References: <20100323213338.GA29170@redhat.com> <20100406141321.GA8416@nowhere> <20100406153115.GB5744@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406153115.GB5744@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 07:31:15PM +0400, Cyrill Gorcunov wrote:
> > I fear the cpu clock is not going to help you detecting any hard lockups.
> > If you're stuck in an interrupt or an irq disabled loop, your cpu clock is
> > not going to fire.
> >
> 
> I guess it's not supposed to. For such cases only nmi irqs may help for which
> the perf events are there (/me need to check if we program apic timer for anything
> like that). But it should help for other deadlocks. Or I miss something?


Actually not. What the hardlockup detector does it to check the progression
of irqs.

So it detects true hardlockups: stuck in an irq disabled section.
If you don't have NMI to detect that (here this made by hardware clock based
on cpu cycles overflows), then you're screwed. The hardlockup detector is
useless with a maskable irq based clock.

