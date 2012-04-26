Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab2DZNsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 09:48:06 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:44724 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab2DZNsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 09:48:04 -0400
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Don Zickus <dzickus@redhat.com>, Wim Van Sebroeck <wim@iguana.be>
CC: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:core/locking] watchdog, hpwdt: Remove priority option for
 NMI callback
Thread-Topic: [tip:core/locking] watchdog, hpwdt: Remove priority option for
 NMI callback
Thread-Index: AQHNI3yXFW0e5IsBfki+nIx2AvGBWZatCMeAgAAV6cA=
Date: Thu, 26 Apr 2012 13:47:03 +0000
Message-ID: <9774516974AF5F4C8A2C3C69CD341233203A83B5@G9W0755.americas.hpqcorp.net>
References: <1333051877-15755-2-git-send-email-dzickus@redhat.com>
 <tip-09ee10143658cd021d879ead61ead72a196302b6@git.kernel.org>
 <20120426071339.GI6553@spo001.leaseweb.com>
 <20120426122659.GS28185@redhat.com>
In-Reply-To: <20120426122659.GS28185@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.12.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim:


Don is correct. We did have a separate discussion about this after I denied the original patch. It is all good now.

And thanks for cutting in the port 0x72 patch.

Thanks,
Tom 

-----Original Message-----
From: Don Zickus [mailto:dzickus@redhat.com] 
Sent: Thursday, April 26, 2012 7:27 AM
To: Wim Van Sebroeck
Cc: mingo@kernel.org; hpa@zytor.com; linux-kernel@vger.kernel.org; torvalds@linux-foundation.org; peterz@infradead.org; Mingarelli, Thomas; akpm@linux-foundation.org; tglx@linutronix.de; linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] watchdog, hpwdt: Remove priority option for NMI callback

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
