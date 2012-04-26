Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2DZM1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:27:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab2DZM1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:27:49 -0400
Date: Thu, 26 Apr 2012 08:26:59 -0400
From: Don Zickus <dzickus@redhat.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        thomas.mingarelli@hp.com, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] watchdog, hpwdt: Remove priority option for
 NMI callback
Message-ID: <20120426122659.GS28185@redhat.com>
References: <1333051877-15755-2-git-send-email-dzickus@redhat.com>
 <tip-09ee10143658cd021d879ead61ead72a196302b6@git.kernel.org>
 <20120426071339.GI6553@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426071339.GI6553@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 09:13:39AM +0200, Wim Van Sebroeck wrote:
> > 
> > Therefore hpwdt's priority mechanism doesn't make sense any
> > more.  They will be always first on the NMI_UNKNOWN queue, if
> > they register.
> > 
> > Removing this parameter cleans up the code and simplifies things
> > for the next patch which changes how nmis are registered.
> > 
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
> > Cc: Wim Van Sebroeck <wim@iguana.be>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Link: http://lkml.kernel.org/r/1333051877-15755-2-git-send-email-dzickus@redhat.com
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> This is the feedback I have from Tom which he discussed with Don:
> > I don't like this patch because the Virtual NMI button doesn't come through the pretimeout routine. It is taken by the
> system as an IOCK NMI error and no log messages in our IML.
> > Our BIOS is not able to source the NMI.
> 
> And since then it became quiet. Imho: this needs more discussion...

Tom and I discussed this offline.  The result was patch 2 of this series.
The problem he had, had nothing to do with this patch (which was just a
cleanup really).  Tom tested the second patch and was happy with the
results.

If there is any other issues, I am assuming Tom would have let me know a
while ago.  But I believe all his issues are addressed.  Tom?

Cheers,
Don
