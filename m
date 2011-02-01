Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1BASIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:08:40 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:44110 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752799Ab1BASIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:08:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sMwyykdTcldpEsBe+C1H3991qRbiUZbhOK1fgk/eI5ipLPBCVpq8crl7ZPKlobr5yxG1R5iDMsjt5NO2PLXdwaEo8ObLZ9laBIEDnvXGJfsXwfiA6AZXMLFyTnHszkvZ;
Date: Tue, 1 Feb 2011 10:08:33 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Hugh Dickins <hughd@google.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
Message-ID: <20110201100833.3219687e@jbarnes-desktop>
In-Reply-To: <20110201094643.366bc073@jbarnes-desktop>
References: <849307$bc24ct@azsmga001.ch.intel.com>
	<1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LSU.2.00.1102010909270.1586@sister.anvils>
	<20110201094643.366bc073@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 09:46:43 -0800
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tue, 1 Feb 2011 09:34:12 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
> > As you know (I went off-list to send more info at the weekend), this
> > behaviour is very elusive, probably depends on more than one issue,
> > comes and goes with irrelevant patches and config changes and reboots.
> 
> Are you still seeing underruns during normal activity?  I wonder if the
> ones you were seeing before were only reported at 60Hz due to vblank
> interrupt processing.  If we failed to clear the underrun status, we'd
> report one every time we got a vblank interrupt (since the underruns
> don't report interrupts by themselves).
> 
> If so, that may just be a red herring in this case.

More random questions arise from the info provided:
 - why are we ending up in the flip code at all?  fvwm shouldn't
   trigger that path...
 - what's with all the underruns?  it looks like we *do* ack those
   flags as needed, so apparently they're valid, but they indicate a
   serious problem with the display pipeline; maybe self-refresh
   shouldn't be enabled on your system (that would increase memory
   latency and potentially cause underruns), running with
   i915.powersave=0 would disable that feature

The lack of text really does sound like a render cache flushing
problem, but the other issues are worrying as well, and could be
compounding things.  And the last time I saw the issue, it was related
to compositing and required an X server fix.  But supposedly you're not
using compositing, so...

-- 
Jesse Barnes, Intel Open Source Technology Center
