Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab0JGOU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:20:58 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:37818 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab0JGOU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:20:57 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zzbb2dK1432N98dN9371Pzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9XBUF-01-OUL-02
X-M-MSG: 
Date: Thu, 7 Oct 2010 16:20:39 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "Richter, Robert" <robert.richter@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "acme@redhat.com" <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "eranian@gmail.com" <eranian@gmail.com>
Subject: Re: [RFC 0/3] Basic support for LWP
Message-ID: <20101007142039.GC17424@escobedo.osrc.amd.com>
References: <alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
 <20101005145155.GD173@escobedo.osrc.amd.com>
 <alpine.LFD.2.00.1010051730060.2556@localhost6.localdomain6>
 <20101005182739.GE173@escobedo.osrc.amd.com>
 <20101005190501.GA21916@elte.hu>
 <20101006073558.GJ13563@erda.amd.com>
 <AANLkTi=T0QmcKeZcgcR+GKk-9OwQUB_x8XdHiNuU7tE_@mail.gmail.com>
 <AANLkTimwVuosF24_gBOTpMydfcj-SQPFyZM4uu=vEPbL@mail.gmail.com>
 <4CADD257.7080203@zytor.com>
 <AANLkTin+PXzz4qJHX6kHiQW8Rqdrv=hrvq4iWuaOnGiV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <AANLkTin+PXzz4qJHX6kHiQW8Rqdrv=hrvq4iWuaOnGiV@mail.gmail.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach
 b. Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 10:11:42AM -0400, Stephane Eranian wrote:
> On Thu, Oct 7, 2010 at 3:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 10/07/2010 03:46 AM, Stephane Eranian wrote:
> >>
> >> As for the patch itself, I am not an expert at xsave/xrstor, but it seems to
> >> me you could decouple LWP from FPU. I think  Brian had the same comment.
> >> I suspect this can be done and it will certainly look cleaner.
> >>
> >
> > Well, once you're using XSAVE you're not decoupled from the FPU.  Worse,
> > if you're using XSAVE and not honoring CR0.TS you have a major design flaw.
> >
> Is that to say, that if you use LWP you will have to save/restore FPU state even
> though you're not actually using it?

No, you don't necessarily have to care about the FPU stuff. XSAVE can
save different states individually to the same buffer, and XRSTOR can
restore them individually. You just have to make sure CR0.TS is not
set when you execute the XSAVE or XRSTOR instruction.

That's what I did and it worked :)


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

