Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab0JES1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:27:54 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:15961
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821Ab0JES1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:27:53 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9TXY6-01-1ME-02
X-M-MSG: 
Date: Tue, 5 Oct 2010 20:27:39 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Richter, Robert" <robert.richter@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 0/3] Basic support for LWP
Message-ID: <20101005182739.GE173@escobedo.osrc.amd.com>
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>
 <alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
 <20101005145155.GD173@escobedo.osrc.amd.com>
 <alpine.LFD.2.00.1010051730060.2556@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010051730060.2556@localhost6.localdomain6>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_b=2E_M=FCnchen=3B_Ges?=
	=?iso-8859-1?Q?ch=E4ftsf=FChrer=3A_Andrew_Bowd=2C_Alberto_Bozzo=3B_Sitz?=
	=?iso-8859-1?Q?=3A_Dornach=2C_Gemeinde_Aschheim=2C_Landkreis_M=FCnchen=3B?=
	=?iso-8859-1?Q?_Registergericht_M=FCnchen=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 11:34:11AM -0400, Thomas Gleixner wrote:
> So it's the end result. Ok, then explain the following sentence:
>  
> > > > This code adds basic support for LWP to the context switch code, which
> > > > is the minimum needed to use LWP. Support for other LWP features like
> > > > interrupts will be added later.
> 
> If your patch _IS_ the end result then there are no other LWP
> features, right ?

Ok, you got me there. I should have checked again before I wrote this.

There is at one other optional feature. Thats the support for a
thresholding interrupt, which the OS should relay to the user process
in one way or another.

But thats not required to use LWP instructions. Maybe Robert will add
it to perf some day, or maybe not. It is completely optional, and how
it is implemented at some point in the future is completely irrelevant
to the basic support of LWP.

> If there are, then your patch is _NOT_ the end result and we really
> want to know what is coming.

As far as I am concerned, it _is_ the end result. It implements the
necessary changes to make LWP usable, and that's it.

Whatever support for optional features Robert or anybody else may be
going to implement or not affects in no way the necessity of managing
the LWP state for user processes. Those are two completely unrelated
issues.

Now, since this was obviously not made clear enough before:

  Don't merge this code anywhere yet. This is an RFC and nothing else.
  It implements a basic change necessary to support a new instruction
  set, which just so happens to be a profiling mechanism, too. Please
  review the code and flame me for anything that you don't like in it.
  

Hans



PS: The patches were not delivered to LKML previously, so I'll resend
them.

-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

